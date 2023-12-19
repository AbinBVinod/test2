let config: Postgres.poolConfig = {
  ...Config.db,
  transform: {undefined: Js.null},
}
let sql = Postgres.makeSql(~config)

type chainId = int
type eventId = string
type blockNumberRow = {@as("block_number") blockNumber: int}

module ChainMetadata = {
  type chainMetadata = {
    @as("chain_id") chainId: int,
    @as("block_height") blockHeight: int,
    @as("start_block") startBlock: int,
  }

  @module("./DbFunctionsImplementation.js")
  external setChainMetadata: (Postgres.sql, chainMetadata) => promise<unit> = "setChainMetadata"

  let setChainMetadataRow = (~chainId, ~startBlock, ~blockHeight) => {
    sql->setChainMetadata({chainId, startBlock, blockHeight})
  }
}

module EventSyncState = {
  @genType
  type eventSyncState = {
    @as("chain_id") chainId: int,
    @as("block_number") blockNumber: int,
    @as("log_index") logIndex: int,
    @as("transaction_index") transactionIndex: int,
    @as("block_timestamp") blockTimestamp: int,
  }
  @module("./DbFunctionsImplementation.js")
  external readLatestSyncedEventOnChainIdArr: (
    Postgres.sql,
    ~chainId: int,
  ) => promise<array<eventSyncState>> = "readLatestSyncedEventOnChainId"

  let readLatestSyncedEventOnChainId = async (sql, ~chainId) => {
    let arr = await sql->readLatestSyncedEventOnChainIdArr(~chainId)
    arr->Belt.Array.get(0)
  }

  let getLatestProcessedBlockNumber = async (~chainId) => {
    let latestEventOpt = await sql->readLatestSyncedEventOnChainId(~chainId)
    latestEventOpt->Belt.Option.map(event => event.blockNumber)
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<eventSyncState>) => promise<unit> =
    "batchSetEventSyncState"
}

module RawEvents = {
  type rawEventRowId = (chainId, eventId)
  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Types.rawEventsEntity>) => promise<unit> =
    "batchSetRawEvents"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<rawEventRowId>) => promise<unit> =
    "batchDeleteRawEvents"

  @module("./DbFunctionsImplementation.js")
  external readEntities: (
    Postgres.sql,
    array<rawEventRowId>,
  ) => promise<array<Types.rawEventsEntity>> = "readRawEventsEntities"

  @module("./DbFunctionsImplementation.js")
  external getRawEventsPageGtOrEqEventId: (
    Postgres.sql,
    ~chainId: chainId,
    ~eventId: Ethers.BigInt.t,
    ~limit: int,
    ~contractAddresses: array<Ethers.ethAddress>,
  ) => promise<array<Types.rawEventsEntity>> = "getRawEventsPageGtOrEqEventId"

  @module("./DbFunctionsImplementation.js")
  external getRawEventsPageWithinEventIdRangeInclusive: (
    Postgres.sql,
    ~chainId: chainId,
    ~fromEventIdInclusive: Ethers.BigInt.t,
    ~toEventIdInclusive: Ethers.BigInt.t,
    ~limit: int,
    ~contractAddresses: array<Ethers.ethAddress>,
  ) => promise<array<Types.rawEventsEntity>> = "getRawEventsPageWithinEventIdRangeInclusive"

  ///Returns an array with 1 block number (the highest processed on the given chainId)
  @module("./DbFunctionsImplementation.js")
  external readLatestRawEventsBlockNumberProcessedOnChainId: (
    Postgres.sql,
    chainId,
  ) => promise<array<blockNumberRow>> = "readLatestRawEventsBlockNumberProcessedOnChainId"

  let getLatestProcessedBlockNumber = async (~chainId) => {
    let row = await sql->readLatestRawEventsBlockNumberProcessedOnChainId(chainId)

    row->Belt.Array.get(0)->Belt.Option.map(row => row.blockNumber)
  }
}

module DynamicContractRegistry = {
  type contractAddress = Ethers.ethAddress
  type dynamicContractRegistryRowId = (chainId, contractAddress)
  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Types.dynamicContractRegistryEntity>) => promise<unit> =
    "batchSetDynamicContractRegistry"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<dynamicContractRegistryRowId>) => promise<unit> =
    "batchDeleteDynamicContractRegistry"

  @module("./DbFunctionsImplementation.js")
  external readEntities: (
    Postgres.sql,
    array<dynamicContractRegistryRowId>,
  ) => promise<array<Types.dynamicContractRegistryEntity>> = "readDynamicContractRegistryEntities"

  type contractTypeAndAddress = {
    @as("contract_address") contractAddress: Ethers.ethAddress,
    @as("contract_type") contractType: string,
    @as("event_id") eventId: Ethers.BigInt.t,
  }

  ///Returns an array with 1 block number (the highest processed on the given chainId)
  @module("./DbFunctionsImplementation.js")
  external readDynamicContractsOnChainIdAtOrBeforeBlock: (
    Postgres.sql,
    ~chainId: chainId,
    ~startBlock: int,
  ) => promise<array<contractTypeAndAddress>> = "readDynamicContractsOnChainIdAtOrBeforeBlock"
}

module EventsSummary = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): eventsSummaryEntity => {
    let entityDecoded = switch entityJson->eventsSummaryEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity eventsSummary using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> = "batchSetEventsSummary"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteEventsSummary"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readEventsSummaryEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    eventsSummaryEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
module RewardFxdxVault_AddReward = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): rewardFxdxVault_AddRewardEntity => {
    let entityDecoded = switch entityJson->rewardFxdxVault_AddRewardEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity rewardFxdxVault_AddReward using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> =
    "batchSetRewardFxdxVault_AddReward"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteRewardFxdxVault_AddReward"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readRewardFxdxVault_AddRewardEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    rewardFxdxVault_AddRewardEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
module RewardFxdxVault_SendReward = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): rewardFxdxVault_SendRewardEntity => {
    let entityDecoded = switch entityJson->rewardFxdxVault_SendRewardEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity rewardFxdxVault_SendReward using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> =
    "batchSetRewardFxdxVault_SendReward"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteRewardFxdxVault_SendReward"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readRewardFxdxVault_SendRewardEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    rewardFxdxVault_SendRewardEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
module RewardFxdxVault_TotalReserves = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): rewardFxdxVault_TotalReservesEntity => {
    let entityDecoded = switch entityJson->rewardFxdxVault_TotalReservesEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity rewardFxdxVault_TotalReserves using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> =
    "batchSetRewardFxdxVault_TotalReserves"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteRewardFxdxVault_TotalReserves"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readRewardFxdxVault_TotalReservesEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    rewardFxdxVault_TotalReservesEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
module StakedFxdxVault_Stake = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): stakedFxdxVault_StakeEntity => {
    let entityDecoded = switch entityJson->stakedFxdxVault_StakeEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity stakedFxdxVault_Stake using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> =
    "batchSetStakedFxdxVault_Stake"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteStakedFxdxVault_Stake"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readStakedFxdxVault_StakeEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    stakedFxdxVault_StakeEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
module StakedFxdxVault_TotalReserves = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): stakedFxdxVault_TotalReservesEntity => {
    let entityDecoded = switch entityJson->stakedFxdxVault_TotalReservesEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity stakedFxdxVault_TotalReserves using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> =
    "batchSetStakedFxdxVault_TotalReserves"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteStakedFxdxVault_TotalReserves"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readStakedFxdxVault_TotalReservesEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    stakedFxdxVault_TotalReservesEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
module StakedFxdxVault_Unstake = {
  open Types

  let decodeUnsafe = (entityJson: Js.Json.t): stakedFxdxVault_UnstakeEntity => {
    let entityDecoded = switch entityJson->stakedFxdxVault_UnstakeEntity_decode {
    | Ok(v) => Ok(v)
    | Error(e) =>
      Logging.error({
        "err": e,
        "msg": "EE700: Unable to parse row from database of entity stakedFxdxVault_Unstake using spice",
        "raw_unparsed_object": entityJson,
      })
      Error(e)
    }->Belt.Result.getExn

    entityDecoded
  }

  @module("./DbFunctionsImplementation.js")
  external batchSet: (Postgres.sql, array<Js.Json.t>) => promise<unit> =
    "batchSetStakedFxdxVault_Unstake"

  @module("./DbFunctionsImplementation.js")
  external batchDelete: (Postgres.sql, array<Types.id>) => promise<unit> =
    "batchDeleteStakedFxdxVault_Unstake"

  @module("./DbFunctionsImplementation.js")
  external readEntitiesFromDb: (Postgres.sql, array<Types.id>) => promise<array<Js.Json.t>> =
    "readStakedFxdxVault_UnstakeEntities"

  let readEntities = async (sql: Postgres.sql, ids: array<Types.id>): array<
    stakedFxdxVault_UnstakeEntity,
  > => {
    let res = await readEntitiesFromDb(sql, ids)
    res->Belt.Array.map(entityJson => entityJson->decodeUnsafe)
  }
}
