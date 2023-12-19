//*************
//***ENTITIES**
//*************

@spice @genType.as("Id")
type id = string

@genType.import(("./bindings/OpaqueTypes", "Nullable"))
type nullable<'a> = option<'a>

let nullable_encode = (encoder: Spice.encoder<'a>, n: nullable<'a>): Js.Json.t =>
  switch n {
  | None => Js.Json.null
  | Some(v) => v->encoder
  }

let nullable_decode = Spice.optionFromJson

@@warning("-30")
@genType
type rec eventsSummaryLoaderConfig = bool
and rewardFxdxVault_AddRewardLoaderConfig = bool
and rewardFxdxVault_SendRewardLoaderConfig = bool
and rewardFxdxVault_TotalReservesLoaderConfig = bool
and stakedFxdxVault_StakeLoaderConfig = bool
and stakedFxdxVault_TotalReservesLoaderConfig = bool
and stakedFxdxVault_UnstakeLoaderConfig = bool

@@warning("+30")

type entityRead =
  | EventsSummaryRead(id)
  | RewardFxdxVault_AddRewardRead(id)
  | RewardFxdxVault_SendRewardRead(id)
  | RewardFxdxVault_TotalReservesRead(id)
  | StakedFxdxVault_StakeRead(id)
  | StakedFxdxVault_TotalReservesRead(id)
  | StakedFxdxVault_UnstakeRead(id)

@genType
type rawEventsEntity = {
  @as("chain_id") chainId: int,
  @as("event_id") eventId: string,
  @as("block_number") blockNumber: int,
  @as("log_index") logIndex: int,
  @as("transaction_index") transactionIndex: int,
  @as("transaction_hash") transactionHash: string,
  @as("src_address") srcAddress: Ethers.ethAddress,
  @as("block_hash") blockHash: string,
  @as("block_timestamp") blockTimestamp: int,
  @as("event_type") eventType: Js.Json.t,
  params: string,
}

@genType
type dynamicContractRegistryEntity = {
  @as("chain_id") chainId: int,
  @as("event_id") eventId: Ethers.BigInt.t,
  @as("contract_address") contractAddress: Ethers.ethAddress,
  @as("contract_type") contractType: string,
}

@spice @genType.as("EventsSummaryEntity")
type eventsSummaryEntity = {
  id: id,
  rewardFxdxVault_AddRewardCount: Ethers.BigInt.t,
  rewardFxdxVault_SendRewardCount: Ethers.BigInt.t,
  rewardFxdxVault_TotalReservesCount: Ethers.BigInt.t,
  stakedFxdxVault_StakeCount: Ethers.BigInt.t,
  stakedFxdxVault_TotalReservesCount: Ethers.BigInt.t,
  stakedFxdxVault_UnstakeCount: Ethers.BigInt.t,
}

@spice @genType.as("RewardFxdxVault_AddRewardEntity")
type rewardFxdxVault_AddRewardEntity = {
  id: id,
  rewardId: Ethers.BigInt.t,
  stakeId: Ethers.BigInt.t,
  rewardAmount: Ethers.BigInt.t,
  duration: Ethers.BigInt.t,
  timestamp: Ethers.BigInt.t,
  account: string,
  isClaimed: bool,
  eventsSummary: string,
}

@spice @genType.as("RewardFxdxVault_SendRewardEntity")
type rewardFxdxVault_SendRewardEntity = {
  id: id,
  rewardId: Ethers.BigInt.t,
  stakeId: Ethers.BigInt.t,
  rewardAmount: Ethers.BigInt.t,
  duration: Ethers.BigInt.t,
  timestamp: Ethers.BigInt.t,
  account: string,
  isClaimed: bool,
  eventsSummary: string,
}

@spice @genType.as("RewardFxdxVault_TotalReservesEntity")
type rewardFxdxVault_TotalReservesEntity = {
  id: id,
  vault: string,
  rewardReserves: Ethers.BigInt.t,
  eventsSummary: string,
}

@spice @genType.as("StakedFxdxVault_StakeEntity")
type stakedFxdxVault_StakeEntity = {
  id: id,
  stakeId: Ethers.BigInt.t,
  amount: Ethers.BigInt.t,
  duration: Ethers.BigInt.t,
  rewardInterestRate: Ethers.BigInt.t,
  timestamp: Ethers.BigInt.t,
  account: string,
  unstaked: bool,
  eventsSummary: string,
}

@spice @genType.as("StakedFxdxVault_TotalReservesEntity")
type stakedFxdxVault_TotalReservesEntity = {
  id: id,
  vault: string,
  reserves: Ethers.BigInt.t,
  eventsSummary: string,
}

@spice @genType.as("StakedFxdxVault_UnstakeEntity")
type stakedFxdxVault_UnstakeEntity = {
  id: id,
  stakeId: Ethers.BigInt.t,
  amount: Ethers.BigInt.t,
  duration: Ethers.BigInt.t,
  rewardInterestRate: Ethers.BigInt.t,
  timestamp: Ethers.BigInt.t,
  account: string,
  unstaked: bool,
  eventsSummary: string,
}

type entity =
  | EventsSummaryEntity(eventsSummaryEntity)
  | RewardFxdxVault_AddRewardEntity(rewardFxdxVault_AddRewardEntity)
  | RewardFxdxVault_SendRewardEntity(rewardFxdxVault_SendRewardEntity)
  | RewardFxdxVault_TotalReservesEntity(rewardFxdxVault_TotalReservesEntity)
  | StakedFxdxVault_StakeEntity(stakedFxdxVault_StakeEntity)
  | StakedFxdxVault_TotalReservesEntity(stakedFxdxVault_TotalReservesEntity)
  | StakedFxdxVault_UnstakeEntity(stakedFxdxVault_UnstakeEntity)

type dbOp = Read | Set | Delete

type inMemoryStoreRow<'a> = {
  dbOp: dbOp,
  entity: 'a,
}

//*************
//**CONTRACTS**
//*************

@genType.as("EventLog")
type eventLog<'a> = {
  params: 'a,
  blockNumber: int,
  blockTimestamp: int,
  blockHash: string,
  srcAddress: Ethers.ethAddress,
  transactionHash: string,
  transactionIndex: int,
  logIndex: int,
}

module RewardFxdxVaultContract = {
  module AddRewardEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") rewardId: Ethers.BigInt.t,
      @as("1") stakeId: Ethers.BigInt.t,
      @as("2") rewardAmount: Ethers.BigInt.t,
      @as("3") duration: Ethers.BigInt.t,
      @as("4") timestamp: Ethers.BigInt.t,
      @as("5") account: Ethers.ethAddress,
      @as("6") isClaimed: bool,
    }

    @spice @genType
    type eventArgs = {
      rewardId: Ethers.BigInt.t,
      stakeId: Ethers.BigInt.t,
      rewardAmount: Ethers.BigInt.t,
      duration: Ethers.BigInt.t,
      timestamp: Ethers.BigInt.t,
      account: Ethers.ethAddress,
      isClaimed: bool,
    }

    @genType.as("RewardFxdxVaultContract_AddReward_EventLog")
    type log = eventLog<eventArgs>

    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_AddRewardEntityHandlerContext = {
      set: rewardFxdxVault_AddRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_SendRewardEntityHandlerContext = {
      set: rewardFxdxVault_SendRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_TotalReservesEntityHandlerContext = {
      set: rewardFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_StakeEntityHandlerContext = {
      set: stakedFxdxVault_StakeEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_TotalReservesEntityHandlerContext = {
      set: stakedFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_UnstakeEntityHandlerContext = {
      set: stakedFxdxVault_UnstakeEntity => unit,
      delete: id => unit,
    }
    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("RewardFxdxVault_AddReward")
      rewardFxdxVault_AddReward: rewardFxdxVault_AddRewardEntityHandlerContext,
      @as("RewardFxdxVault_SendReward")
      rewardFxdxVault_SendReward: rewardFxdxVault_SendRewardEntityHandlerContext,
      @as("RewardFxdxVault_TotalReserves")
      rewardFxdxVault_TotalReserves: rewardFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Stake") stakedFxdxVault_Stake: stakedFxdxVault_StakeEntityHandlerContext,
      @as("StakedFxdxVault_TotalReserves")
      stakedFxdxVault_TotalReserves: stakedFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Unstake")
      stakedFxdxVault_Unstake: stakedFxdxVault_UnstakeEntityHandlerContext,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addRewardFxdxVault: Ethers.ethAddress => unit,
      //TODO only add contracts we've registered for the event in the config
      addStakedFxdxVault: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
    }
  }
  module SendRewardEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") rewardId: Ethers.BigInt.t,
      @as("1") stakeId: Ethers.BigInt.t,
      @as("2") rewardAmount: Ethers.BigInt.t,
      @as("3") duration: Ethers.BigInt.t,
      @as("4") timestamp: Ethers.BigInt.t,
      @as("5") account: Ethers.ethAddress,
      @as("6") isClaimed: bool,
    }

    @spice @genType
    type eventArgs = {
      rewardId: Ethers.BigInt.t,
      stakeId: Ethers.BigInt.t,
      rewardAmount: Ethers.BigInt.t,
      duration: Ethers.BigInt.t,
      timestamp: Ethers.BigInt.t,
      account: Ethers.ethAddress,
      isClaimed: bool,
    }

    @genType.as("RewardFxdxVaultContract_SendReward_EventLog")
    type log = eventLog<eventArgs>

    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_AddRewardEntityHandlerContext = {
      set: rewardFxdxVault_AddRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_SendRewardEntityHandlerContext = {
      set: rewardFxdxVault_SendRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_TotalReservesEntityHandlerContext = {
      set: rewardFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_StakeEntityHandlerContext = {
      set: stakedFxdxVault_StakeEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_TotalReservesEntityHandlerContext = {
      set: stakedFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_UnstakeEntityHandlerContext = {
      set: stakedFxdxVault_UnstakeEntity => unit,
      delete: id => unit,
    }
    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("RewardFxdxVault_AddReward")
      rewardFxdxVault_AddReward: rewardFxdxVault_AddRewardEntityHandlerContext,
      @as("RewardFxdxVault_SendReward")
      rewardFxdxVault_SendReward: rewardFxdxVault_SendRewardEntityHandlerContext,
      @as("RewardFxdxVault_TotalReserves")
      rewardFxdxVault_TotalReserves: rewardFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Stake") stakedFxdxVault_Stake: stakedFxdxVault_StakeEntityHandlerContext,
      @as("StakedFxdxVault_TotalReserves")
      stakedFxdxVault_TotalReserves: stakedFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Unstake")
      stakedFxdxVault_Unstake: stakedFxdxVault_UnstakeEntityHandlerContext,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addRewardFxdxVault: Ethers.ethAddress => unit,
      //TODO only add contracts we've registered for the event in the config
      addStakedFxdxVault: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
    }
  }
  module TotalReservesEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") vault: Ethers.ethAddress,
      @as("1") rewardReserves: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      vault: Ethers.ethAddress,
      rewardReserves: Ethers.BigInt.t,
    }

    @genType.as("RewardFxdxVaultContract_TotalReserves_EventLog")
    type log = eventLog<eventArgs>

    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_AddRewardEntityHandlerContext = {
      set: rewardFxdxVault_AddRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_SendRewardEntityHandlerContext = {
      set: rewardFxdxVault_SendRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_TotalReservesEntityHandlerContext = {
      set: rewardFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_StakeEntityHandlerContext = {
      set: stakedFxdxVault_StakeEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_TotalReservesEntityHandlerContext = {
      set: stakedFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_UnstakeEntityHandlerContext = {
      set: stakedFxdxVault_UnstakeEntity => unit,
      delete: id => unit,
    }
    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("RewardFxdxVault_AddReward")
      rewardFxdxVault_AddReward: rewardFxdxVault_AddRewardEntityHandlerContext,
      @as("RewardFxdxVault_SendReward")
      rewardFxdxVault_SendReward: rewardFxdxVault_SendRewardEntityHandlerContext,
      @as("RewardFxdxVault_TotalReserves")
      rewardFxdxVault_TotalReserves: rewardFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Stake") stakedFxdxVault_Stake: stakedFxdxVault_StakeEntityHandlerContext,
      @as("StakedFxdxVault_TotalReserves")
      stakedFxdxVault_TotalReserves: stakedFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Unstake")
      stakedFxdxVault_Unstake: stakedFxdxVault_UnstakeEntityHandlerContext,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addRewardFxdxVault: Ethers.ethAddress => unit,
      //TODO only add contracts we've registered for the event in the config
      addStakedFxdxVault: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
    }
  }
}
module StakedFxdxVaultContract = {
  module StakeEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") stakeId: Ethers.BigInt.t,
      @as("1") amount: Ethers.BigInt.t,
      @as("2") duration: Ethers.BigInt.t,
      @as("3") rewardInterestRate: Ethers.BigInt.t,
      @as("4") timestamp: Ethers.BigInt.t,
      @as("5") account: Ethers.ethAddress,
      @as("6") unstaked: bool,
    }

    @spice @genType
    type eventArgs = {
      stakeId: Ethers.BigInt.t,
      amount: Ethers.BigInt.t,
      duration: Ethers.BigInt.t,
      rewardInterestRate: Ethers.BigInt.t,
      timestamp: Ethers.BigInt.t,
      account: Ethers.ethAddress,
      unstaked: bool,
    }

    @genType.as("StakedFxdxVaultContract_Stake_EventLog")
    type log = eventLog<eventArgs>

    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_AddRewardEntityHandlerContext = {
      set: rewardFxdxVault_AddRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_SendRewardEntityHandlerContext = {
      set: rewardFxdxVault_SendRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_TotalReservesEntityHandlerContext = {
      set: rewardFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_StakeEntityHandlerContext = {
      set: stakedFxdxVault_StakeEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_TotalReservesEntityHandlerContext = {
      set: stakedFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_UnstakeEntityHandlerContext = {
      set: stakedFxdxVault_UnstakeEntity => unit,
      delete: id => unit,
    }
    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("RewardFxdxVault_AddReward")
      rewardFxdxVault_AddReward: rewardFxdxVault_AddRewardEntityHandlerContext,
      @as("RewardFxdxVault_SendReward")
      rewardFxdxVault_SendReward: rewardFxdxVault_SendRewardEntityHandlerContext,
      @as("RewardFxdxVault_TotalReserves")
      rewardFxdxVault_TotalReserves: rewardFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Stake") stakedFxdxVault_Stake: stakedFxdxVault_StakeEntityHandlerContext,
      @as("StakedFxdxVault_TotalReserves")
      stakedFxdxVault_TotalReserves: stakedFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Unstake")
      stakedFxdxVault_Unstake: stakedFxdxVault_UnstakeEntityHandlerContext,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addRewardFxdxVault: Ethers.ethAddress => unit,
      //TODO only add contracts we've registered for the event in the config
      addStakedFxdxVault: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
    }
  }
  module TotalReservesEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") vault: Ethers.ethAddress,
      @as("1") reserves: Ethers.BigInt.t,
    }

    @spice @genType
    type eventArgs = {
      vault: Ethers.ethAddress,
      reserves: Ethers.BigInt.t,
    }

    @genType.as("StakedFxdxVaultContract_TotalReserves_EventLog")
    type log = eventLog<eventArgs>

    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_AddRewardEntityHandlerContext = {
      set: rewardFxdxVault_AddRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_SendRewardEntityHandlerContext = {
      set: rewardFxdxVault_SendRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_TotalReservesEntityHandlerContext = {
      set: rewardFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_StakeEntityHandlerContext = {
      set: stakedFxdxVault_StakeEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_TotalReservesEntityHandlerContext = {
      set: stakedFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_UnstakeEntityHandlerContext = {
      set: stakedFxdxVault_UnstakeEntity => unit,
      delete: id => unit,
    }
    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("RewardFxdxVault_AddReward")
      rewardFxdxVault_AddReward: rewardFxdxVault_AddRewardEntityHandlerContext,
      @as("RewardFxdxVault_SendReward")
      rewardFxdxVault_SendReward: rewardFxdxVault_SendRewardEntityHandlerContext,
      @as("RewardFxdxVault_TotalReserves")
      rewardFxdxVault_TotalReserves: rewardFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Stake") stakedFxdxVault_Stake: stakedFxdxVault_StakeEntityHandlerContext,
      @as("StakedFxdxVault_TotalReserves")
      stakedFxdxVault_TotalReserves: stakedFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Unstake")
      stakedFxdxVault_Unstake: stakedFxdxVault_UnstakeEntityHandlerContext,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addRewardFxdxVault: Ethers.ethAddress => unit,
      //TODO only add contracts we've registered for the event in the config
      addStakedFxdxVault: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
    }
  }
  module UnstakeEvent = {
    //Note: each parameter is using a binding of its index to help with binding in ethers
    //This handles both unamed params and also named params that clash with reserved keywords
    //eg. if an event param is called "values" it will clash since eventArgs will have a '.values()' iterator
    type ethersEventArgs = {
      @as("0") stakeId: Ethers.BigInt.t,
      @as("1") amount: Ethers.BigInt.t,
      @as("2") duration: Ethers.BigInt.t,
      @as("3") rewardInterestRate: Ethers.BigInt.t,
      @as("4") timestamp: Ethers.BigInt.t,
      @as("5") account: Ethers.ethAddress,
      @as("6") unstaked: bool,
    }

    @spice @genType
    type eventArgs = {
      stakeId: Ethers.BigInt.t,
      amount: Ethers.BigInt.t,
      duration: Ethers.BigInt.t,
      rewardInterestRate: Ethers.BigInt.t,
      timestamp: Ethers.BigInt.t,
      account: Ethers.ethAddress,
      unstaked: bool,
    }

    @genType.as("StakedFxdxVaultContract_Unstake_EventLog")
    type log = eventLog<eventArgs>

    type eventsSummaryEntityHandlerContext = {
      get: id => option<eventsSummaryEntity>,
      set: eventsSummaryEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_AddRewardEntityHandlerContext = {
      set: rewardFxdxVault_AddRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_SendRewardEntityHandlerContext = {
      set: rewardFxdxVault_SendRewardEntity => unit,
      delete: id => unit,
    }
    type rewardFxdxVault_TotalReservesEntityHandlerContext = {
      set: rewardFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_StakeEntityHandlerContext = {
      set: stakedFxdxVault_StakeEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_TotalReservesEntityHandlerContext = {
      set: stakedFxdxVault_TotalReservesEntity => unit,
      delete: id => unit,
    }
    type stakedFxdxVault_UnstakeEntityHandlerContext = {
      set: stakedFxdxVault_UnstakeEntity => unit,
      delete: id => unit,
    }
    @genType
    type handlerContext = {
      log: Logs.userLogger,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityHandlerContext,
      @as("RewardFxdxVault_AddReward")
      rewardFxdxVault_AddReward: rewardFxdxVault_AddRewardEntityHandlerContext,
      @as("RewardFxdxVault_SendReward")
      rewardFxdxVault_SendReward: rewardFxdxVault_SendRewardEntityHandlerContext,
      @as("RewardFxdxVault_TotalReserves")
      rewardFxdxVault_TotalReserves: rewardFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Stake") stakedFxdxVault_Stake: stakedFxdxVault_StakeEntityHandlerContext,
      @as("StakedFxdxVault_TotalReserves")
      stakedFxdxVault_TotalReserves: stakedFxdxVault_TotalReservesEntityHandlerContext,
      @as("StakedFxdxVault_Unstake")
      stakedFxdxVault_Unstake: stakedFxdxVault_UnstakeEntityHandlerContext,
    }

    @genType
    type eventsSummaryEntityLoaderContext = {load: id => unit}

    @genType
    type contractRegistrations = {
      //TODO only add contracts we've registered for the event in the config
      addRewardFxdxVault: Ethers.ethAddress => unit,
      //TODO only add contracts we've registered for the event in the config
      addStakedFxdxVault: Ethers.ethAddress => unit,
    }
    @genType
    type loaderContext = {
      log: Logs.userLogger,
      contractRegistration: contractRegistrations,
      @as("EventsSummary") eventsSummary: eventsSummaryEntityLoaderContext,
    }
  }
}

@deriving(accessors)
type event =
  | RewardFxdxVaultContract_AddReward(eventLog<RewardFxdxVaultContract.AddRewardEvent.eventArgs>)
  | RewardFxdxVaultContract_SendReward(eventLog<RewardFxdxVaultContract.SendRewardEvent.eventArgs>)
  | RewardFxdxVaultContract_TotalReserves(
      eventLog<RewardFxdxVaultContract.TotalReservesEvent.eventArgs>,
    )
  | StakedFxdxVaultContract_Stake(eventLog<StakedFxdxVaultContract.StakeEvent.eventArgs>)
  | StakedFxdxVaultContract_TotalReserves(
      eventLog<StakedFxdxVaultContract.TotalReservesEvent.eventArgs>,
    )
  | StakedFxdxVaultContract_Unstake(eventLog<StakedFxdxVaultContract.UnstakeEvent.eventArgs>)

//This needs to pass a getter rather than the context since some
//values in the context could be stale if the getter is not called after
//the loader has run
type handlerContextGetter<'context> = unit => 'context

@deriving(accessors)
type eventAndContext =
  | RewardFxdxVaultContract_AddRewardWithContext(
      eventLog<RewardFxdxVaultContract.AddRewardEvent.eventArgs>,
      //See type handlerContextGetter alias
      handlerContextGetter<RewardFxdxVaultContract.AddRewardEvent.handlerContext>,
    )
  | RewardFxdxVaultContract_SendRewardWithContext(
      eventLog<RewardFxdxVaultContract.SendRewardEvent.eventArgs>,
      //See type handlerContextGetter alias
      handlerContextGetter<RewardFxdxVaultContract.SendRewardEvent.handlerContext>,
    )
  | RewardFxdxVaultContract_TotalReservesWithContext(
      eventLog<RewardFxdxVaultContract.TotalReservesEvent.eventArgs>,
      //See type handlerContextGetter alias
      handlerContextGetter<RewardFxdxVaultContract.TotalReservesEvent.handlerContext>,
    )
  | StakedFxdxVaultContract_StakeWithContext(
      eventLog<StakedFxdxVaultContract.StakeEvent.eventArgs>,
      //See type handlerContextGetter alias
      handlerContextGetter<StakedFxdxVaultContract.StakeEvent.handlerContext>,
    )
  | StakedFxdxVaultContract_TotalReservesWithContext(
      eventLog<StakedFxdxVaultContract.TotalReservesEvent.eventArgs>,
      //See type handlerContextGetter alias
      handlerContextGetter<StakedFxdxVaultContract.TotalReservesEvent.handlerContext>,
    )
  | StakedFxdxVaultContract_UnstakeWithContext(
      eventLog<StakedFxdxVaultContract.UnstakeEvent.eventArgs>,
      //See type handlerContextGetter alias
      handlerContextGetter<StakedFxdxVaultContract.UnstakeEvent.handlerContext>,
    )

type eventRouterEventAndContext = {
  chainId: int,
  event: eventAndContext,
}
@spice
type eventName =
  | @spice.as("RewardFxdxVault_AddReward") RewardFxdxVault_AddReward
  | @spice.as("RewardFxdxVault_SendReward") RewardFxdxVault_SendReward
  | @spice.as("RewardFxdxVault_TotalReserves") RewardFxdxVault_TotalReserves
  | @spice.as("StakedFxdxVault_Stake") StakedFxdxVault_Stake
  | @spice.as("StakedFxdxVault_TotalReserves") StakedFxdxVault_TotalReserves
  | @spice.as("StakedFxdxVault_Unstake") StakedFxdxVault_Unstake

let eventNameToString = (eventName: eventName) =>
  switch eventName {
  | RewardFxdxVault_AddReward => "AddReward"
  | RewardFxdxVault_SendReward => "SendReward"
  | RewardFxdxVault_TotalReserves => "TotalReserves"
  | StakedFxdxVault_Stake => "Stake"
  | StakedFxdxVault_TotalReserves => "TotalReserves"
  | StakedFxdxVault_Unstake => "Unstake"
  }

@genType
type chainId = int

type eventBatchQueueItem = {
  timestamp: int,
  chainId: int,
  blockNumber: int,
  logIndex: int,
  event: event,
}
