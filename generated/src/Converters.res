exception UndefinedEvent(string)

let eventStringToEvent = (eventName: string, contractName: string): Types.eventName => {
  switch (eventName, contractName) {
  | ("AddReward", "RewardFxdxVault") => RewardFxdxVault_AddReward
  | ("SendReward", "RewardFxdxVault") => RewardFxdxVault_SendReward
  | ("TotalReserves", "RewardFxdxVault") => RewardFxdxVault_TotalReserves
  | ("Stake", "StakedFxdxVault") => StakedFxdxVault_Stake
  | ("TotalReserves", "StakedFxdxVault") => StakedFxdxVault_TotalReserves
  | ("Unstake", "StakedFxdxVault") => StakedFxdxVault_Unstake
  | _ => UndefinedEvent(eventName)->raise
  }
}

module RewardFxdxVault = {
  let convertAddRewardViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs,
  > = Obj.magic

  let convertAddRewardLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<
      Types.RewardFxdxVaultContract.AddRewardEvent.ethersEventArgs,
    > =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        rewardId: args.rewardId,
        stakeId: args.stakeId,
        rewardAmount: args.rewardAmount,
        duration: args.duration,
        timestamp: args.timestamp,
        account: args.account,
        isClaimed: args.isClaimed,
      },
    }
  }

  let convertAddRewardLog = (
    logDescription: Ethers.logDescription<Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs = {
      rewardId: logDescription.args.rewardId,
      stakeId: logDescription.args.stakeId,
      rewardAmount: logDescription.args.rewardAmount,
      duration: logDescription.args.duration,
      timestamp: logDescription.args.timestamp,
      account: logDescription.args.account,
      isClaimed: logDescription.args.isClaimed,
    }

    let addRewardLog: Types.eventLog<Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.RewardFxdxVaultContract_AddReward(addRewardLog)
  }
  let convertAddRewardLogViem = (
    decodedEvent: Viem.decodedEvent<Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs = {
      rewardId: decodedEvent.args.rewardId,
      stakeId: decodedEvent.args.stakeId,
      rewardAmount: decodedEvent.args.rewardAmount,
      duration: decodedEvent.args.duration,
      timestamp: decodedEvent.args.timestamp,
      account: decodedEvent.args.account,
      isClaimed: decodedEvent.args.isClaimed,
    }

    let addRewardLog: Types.eventLog<Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.RewardFxdxVaultContract_AddReward(addRewardLog)
  }

  let convertSendRewardViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs,
  > = Obj.magic

  let convertSendRewardLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<
      Types.RewardFxdxVaultContract.SendRewardEvent.ethersEventArgs,
    > =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        rewardId: args.rewardId,
        stakeId: args.stakeId,
        rewardAmount: args.rewardAmount,
        duration: args.duration,
        timestamp: args.timestamp,
        account: args.account,
        isClaimed: args.isClaimed,
      },
    }
  }

  let convertSendRewardLog = (
    logDescription: Ethers.logDescription<Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs = {
      rewardId: logDescription.args.rewardId,
      stakeId: logDescription.args.stakeId,
      rewardAmount: logDescription.args.rewardAmount,
      duration: logDescription.args.duration,
      timestamp: logDescription.args.timestamp,
      account: logDescription.args.account,
      isClaimed: logDescription.args.isClaimed,
    }

    let sendRewardLog: Types.eventLog<Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.RewardFxdxVaultContract_SendReward(sendRewardLog)
  }
  let convertSendRewardLogViem = (
    decodedEvent: Viem.decodedEvent<Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs = {
      rewardId: decodedEvent.args.rewardId,
      stakeId: decodedEvent.args.stakeId,
      rewardAmount: decodedEvent.args.rewardAmount,
      duration: decodedEvent.args.duration,
      timestamp: decodedEvent.args.timestamp,
      account: decodedEvent.args.account,
      isClaimed: decodedEvent.args.isClaimed,
    }

    let sendRewardLog: Types.eventLog<Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.RewardFxdxVaultContract_SendReward(sendRewardLog)
  }

  let convertTotalReservesViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs,
  > = Obj.magic

  let convertTotalReservesLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<
      Types.RewardFxdxVaultContract.TotalReservesEvent.ethersEventArgs,
    > =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        vault: args.vault,
        rewardReserves: args.rewardReserves,
      },
    }
  }

  let convertTotalReservesLog = (
    logDescription: Ethers.logDescription<
      Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs,
    >,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs = {
      vault: logDescription.args.vault,
      rewardReserves: logDescription.args.rewardReserves,
    }

    let totalReservesLog: Types.eventLog<
      Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs,
    > = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.RewardFxdxVaultContract_TotalReserves(totalReservesLog)
  }
  let convertTotalReservesLogViem = (
    decodedEvent: Viem.decodedEvent<Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs = {
      vault: decodedEvent.args.vault,
      rewardReserves: decodedEvent.args.rewardReserves,
    }

    let totalReservesLog: Types.eventLog<
      Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs,
    > = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.RewardFxdxVaultContract_TotalReserves(totalReservesLog)
  }
}

module StakedFxdxVault = {
  let convertStakeViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.StakedFxdxVaultContract.StakeEvent.eventArgs,
  > = Obj.magic

  let convertStakeLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.StakedFxdxVaultContract.StakeEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<Types.StakedFxdxVaultContract.StakeEvent.ethersEventArgs> =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        stakeId: args.stakeId,
        amount: args.amount,
        duration: args.duration,
        rewardInterestRate: args.rewardInterestRate,
        timestamp: args.timestamp,
        account: args.account,
        unstaked: args.unstaked,
      },
    }
  }

  let convertStakeLog = (
    logDescription: Ethers.logDescription<Types.StakedFxdxVaultContract.StakeEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.StakedFxdxVaultContract.StakeEvent.eventArgs = {
      stakeId: logDescription.args.stakeId,
      amount: logDescription.args.amount,
      duration: logDescription.args.duration,
      rewardInterestRate: logDescription.args.rewardInterestRate,
      timestamp: logDescription.args.timestamp,
      account: logDescription.args.account,
      unstaked: logDescription.args.unstaked,
    }

    let stakeLog: Types.eventLog<Types.StakedFxdxVaultContract.StakeEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.StakedFxdxVaultContract_Stake(stakeLog)
  }
  let convertStakeLogViem = (
    decodedEvent: Viem.decodedEvent<Types.StakedFxdxVaultContract.StakeEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.StakedFxdxVaultContract.StakeEvent.eventArgs = {
      stakeId: decodedEvent.args.stakeId,
      amount: decodedEvent.args.amount,
      duration: decodedEvent.args.duration,
      rewardInterestRate: decodedEvent.args.rewardInterestRate,
      timestamp: decodedEvent.args.timestamp,
      account: decodedEvent.args.account,
      unstaked: decodedEvent.args.unstaked,
    }

    let stakeLog: Types.eventLog<Types.StakedFxdxVaultContract.StakeEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.StakedFxdxVaultContract_Stake(stakeLog)
  }

  let convertTotalReservesViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs,
  > = Obj.magic

  let convertTotalReservesLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<
      Types.StakedFxdxVaultContract.TotalReservesEvent.ethersEventArgs,
    > =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        vault: args.vault,
        reserves: args.reserves,
      },
    }
  }

  let convertTotalReservesLog = (
    logDescription: Ethers.logDescription<
      Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs,
    >,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs = {
      vault: logDescription.args.vault,
      reserves: logDescription.args.reserves,
    }

    let totalReservesLog: Types.eventLog<
      Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs,
    > = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.StakedFxdxVaultContract_TotalReserves(totalReservesLog)
  }
  let convertTotalReservesLogViem = (
    decodedEvent: Viem.decodedEvent<Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs = {
      vault: decodedEvent.args.vault,
      reserves: decodedEvent.args.reserves,
    }

    let totalReservesLog: Types.eventLog<
      Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs,
    > = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.StakedFxdxVaultContract_TotalReserves(totalReservesLog)
  }

  let convertUnstakeViemDecodedEvent: Viem.decodedEvent<'a> => Viem.decodedEvent<
    Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs,
  > = Obj.magic

  let convertUnstakeLogDescription = (log: Ethers.logDescription<'a>): Ethers.logDescription<
    Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs,
  > => {
    //Convert from the ethersLog type with indexs as keys to named key value object
    let ethersLog: Ethers.logDescription<
      Types.StakedFxdxVaultContract.UnstakeEvent.ethersEventArgs,
    > =
      log->Obj.magic
    let {args, name, signature, topic} = ethersLog

    {
      name,
      signature,
      topic,
      args: {
        stakeId: args.stakeId,
        amount: args.amount,
        duration: args.duration,
        rewardInterestRate: args.rewardInterestRate,
        timestamp: args.timestamp,
        account: args.account,
        unstaked: args.unstaked,
      },
    }
  }

  let convertUnstakeLog = (
    logDescription: Ethers.logDescription<Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs = {
      stakeId: logDescription.args.stakeId,
      amount: logDescription.args.amount,
      duration: logDescription.args.duration,
      rewardInterestRate: logDescription.args.rewardInterestRate,
      timestamp: logDescription.args.timestamp,
      account: logDescription.args.account,
      unstaked: logDescription.args.unstaked,
    }

    let unstakeLog: Types.eventLog<Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.StakedFxdxVaultContract_Unstake(unstakeLog)
  }
  let convertUnstakeLogViem = (
    decodedEvent: Viem.decodedEvent<Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs>,
    ~log: Ethers.log,
    ~blockTimestamp: int,
  ) => {
    let params: Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs = {
      stakeId: decodedEvent.args.stakeId,
      amount: decodedEvent.args.amount,
      duration: decodedEvent.args.duration,
      rewardInterestRate: decodedEvent.args.rewardInterestRate,
      timestamp: decodedEvent.args.timestamp,
      account: decodedEvent.args.account,
      unstaked: decodedEvent.args.unstaked,
    }

    let unstakeLog: Types.eventLog<Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs> = {
      params,
      blockNumber: log.blockNumber,
      blockTimestamp,
      blockHash: log.blockHash,
      srcAddress: log.address,
      transactionHash: log.transactionHash,
      transactionIndex: log.transactionIndex,
      logIndex: log.logIndex,
    }

    Types.StakedFxdxVaultContract_Unstake(unstakeLog)
  }
}

type parseEventError =
  ParseError(Ethers.Interface.parseLogError) | UnregisteredContract(Ethers.ethAddress)

exception ParseEventErrorExn(parseEventError)

let parseEventEthers = (~log, ~blockTimestamp, ~contractInterfaceManager): Belt.Result.t<
  Types.event,
  _,
> => {
  let logDescriptionResult = contractInterfaceManager->ContractInterfaceManager.parseLogEthers(~log)
  switch logDescriptionResult {
  | Error(e) =>
    switch e {
    | ParseError(parseError) => ParseError(parseError)
    | UndefinedInterface(contractAddress) => UnregisteredContract(contractAddress)
    }->Error

  | Ok(logDescription) =>
    switch contractInterfaceManager->ContractInterfaceManager.getContractNameFromAddress(
      ~contractAddress=log.address,
    ) {
    | None => Error(UnregisteredContract(log.address))
    | Some(contractName) =>
      let event = switch eventStringToEvent(logDescription.name, contractName) {
      | RewardFxdxVault_AddReward =>
        logDescription
        ->RewardFxdxVault.convertAddRewardLogDescription
        ->RewardFxdxVault.convertAddRewardLog(~log, ~blockTimestamp)
      | RewardFxdxVault_SendReward =>
        logDescription
        ->RewardFxdxVault.convertSendRewardLogDescription
        ->RewardFxdxVault.convertSendRewardLog(~log, ~blockTimestamp)
      | RewardFxdxVault_TotalReserves =>
        logDescription
        ->RewardFxdxVault.convertTotalReservesLogDescription
        ->RewardFxdxVault.convertTotalReservesLog(~log, ~blockTimestamp)
      | StakedFxdxVault_Stake =>
        logDescription
        ->StakedFxdxVault.convertStakeLogDescription
        ->StakedFxdxVault.convertStakeLog(~log, ~blockTimestamp)
      | StakedFxdxVault_TotalReserves =>
        logDescription
        ->StakedFxdxVault.convertTotalReservesLogDescription
        ->StakedFxdxVault.convertTotalReservesLog(~log, ~blockTimestamp)
      | StakedFxdxVault_Unstake =>
        logDescription
        ->StakedFxdxVault.convertUnstakeLogDescription
        ->StakedFxdxVault.convertUnstakeLog(~log, ~blockTimestamp)
      }

      Ok(event)
    }
  }
}

let parseEvent = (~log, ~blockTimestamp, ~contractInterfaceManager): Belt.Result.t<
  Types.event,
  _,
> => {
  let decodedEventResult = contractInterfaceManager->ContractInterfaceManager.parseLogViem(~log)
  switch decodedEventResult {
  | Error(e) =>
    switch e {
    | ParseError(parseError) => ParseError(parseError)
    | UndefinedInterface(contractAddress) => UnregisteredContract(contractAddress)
    }->Error

  | Ok(decodedEvent) =>
    switch contractInterfaceManager->ContractInterfaceManager.getContractNameFromAddress(
      ~contractAddress=log.address,
    ) {
    | None => Error(UnregisteredContract(log.address))
    | Some(contractName) =>
      let event = switch eventStringToEvent(decodedEvent.eventName, contractName) {
      | RewardFxdxVault_AddReward =>
        decodedEvent
        ->RewardFxdxVault.convertAddRewardViemDecodedEvent
        ->RewardFxdxVault.convertAddRewardLogViem(~log, ~blockTimestamp)
      | RewardFxdxVault_SendReward =>
        decodedEvent
        ->RewardFxdxVault.convertSendRewardViemDecodedEvent
        ->RewardFxdxVault.convertSendRewardLogViem(~log, ~blockTimestamp)
      | RewardFxdxVault_TotalReserves =>
        decodedEvent
        ->RewardFxdxVault.convertTotalReservesViemDecodedEvent
        ->RewardFxdxVault.convertTotalReservesLogViem(~log, ~blockTimestamp)
      | StakedFxdxVault_Stake =>
        decodedEvent
        ->StakedFxdxVault.convertStakeViemDecodedEvent
        ->StakedFxdxVault.convertStakeLogViem(~log, ~blockTimestamp)
      | StakedFxdxVault_TotalReserves =>
        decodedEvent
        ->StakedFxdxVault.convertTotalReservesViemDecodedEvent
        ->StakedFxdxVault.convertTotalReservesLogViem(~log, ~blockTimestamp)
      | StakedFxdxVault_Unstake =>
        decodedEvent
        ->StakedFxdxVault.convertUnstakeViemDecodedEvent
        ->StakedFxdxVault.convertUnstakeLogViem(~log, ~blockTimestamp)
      }

      Ok(event)
    }
  }
}

let decodeRawEventWith = (
  rawEvent: Types.rawEventsEntity,
  ~decoder: Spice.decoder<'a>,
  ~variantAccessor: Types.eventLog<'a> => Types.event,
): Spice.result<Types.eventBatchQueueItem> => {
  switch rawEvent.params->Js.Json.parseExn {
  | exception exn =>
    let message =
      exn
      ->Js.Exn.asJsExn
      ->Belt.Option.flatMap(jsexn => jsexn->Js.Exn.message)
      ->Belt.Option.getWithDefault("No message on exn")

    Spice.error(`Failed at JSON.parse. Error: ${message}`, rawEvent.params->Obj.magic)
  | v => Ok(v)
  }
  ->Belt.Result.flatMap(json => {
    json->decoder
  })
  ->Belt.Result.map(params => {
    let event = {
      blockNumber: rawEvent.blockNumber,
      blockTimestamp: rawEvent.blockTimestamp,
      blockHash: rawEvent.blockHash,
      srcAddress: rawEvent.srcAddress,
      transactionHash: rawEvent.transactionHash,
      transactionIndex: rawEvent.transactionIndex,
      logIndex: rawEvent.logIndex,
      params,
    }->variantAccessor

    let queueItem: Types.eventBatchQueueItem = {
      timestamp: rawEvent.blockTimestamp,
      chainId: rawEvent.chainId,
      blockNumber: rawEvent.blockNumber,
      logIndex: rawEvent.logIndex,
      event,
    }

    queueItem
  })
}

let parseRawEvent = (rawEvent: Types.rawEventsEntity): Spice.result<Types.eventBatchQueueItem> => {
  rawEvent.eventType
  ->Types.eventName_decode
  ->Belt.Result.flatMap(eventName => {
    switch eventName {
    | RewardFxdxVault_AddReward =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs_decode,
        ~variantAccessor=Types.rewardFxdxVaultContract_AddReward,
      )
    | RewardFxdxVault_SendReward =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs_decode,
        ~variantAccessor=Types.rewardFxdxVaultContract_SendReward,
      )
    | RewardFxdxVault_TotalReserves =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs_decode,
        ~variantAccessor=Types.rewardFxdxVaultContract_TotalReserves,
      )
    | StakedFxdxVault_Stake =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.StakedFxdxVaultContract.StakeEvent.eventArgs_decode,
        ~variantAccessor=Types.stakedFxdxVaultContract_Stake,
      )
    | StakedFxdxVault_TotalReserves =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs_decode,
        ~variantAccessor=Types.stakedFxdxVaultContract_TotalReserves,
      )
    | StakedFxdxVault_Unstake =>
      rawEvent->decodeRawEventWith(
        ~decoder=Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs_decode,
        ~variantAccessor=Types.stakedFxdxVaultContract_Unstake,
      )
    }
  })
}
