open Belt
RegisterHandlers.registerAllHandlers()

/***** TAKE NOTE ******
This is a hack to get genType to work!

In order for genType to produce recursive types, it needs to be at the 
root module of a file. If it's defined in a nested module it does not 
work. So all the MockDb types and internal functions are defined in TestHelpers_MockDb
and only public functions are recreated and exported from this module.

the following module:
```rescript
module MyModule = {
  @genType
  type rec a = {fieldB: b}
  @genType and b = {fieldA: a}
}
```

produces the following in ts:
```ts
// tslint:disable-next-line:interface-over-type-literal
export type MyModule_a = { readonly fieldB: b };

// tslint:disable-next-line:interface-over-type-literal
export type MyModule_b = { readonly fieldA: MyModule_a };
```

fieldB references type b which doesn't exist because it's defined
as MyModule_b
*/

module MockDb = {
  @genType
  let createMockDb = TestHelpers_MockDb.createMockDb
}

module EventFunctions = {
  //Note these are made into a record to make operate in the same way
  //for Res, JS and TS.

  /**
  The arguements that get passed to a "processEvent" helper function
  */
  @genType
  type eventProcessorArgs<'eventArgs> = {
    event: Types.eventLog<'eventArgs>,
    mockDb: TestHelpers_MockDb.t,
    chainId?: int,
  }

  /**
  An event processor will process an event with a mockDb and return a new mockDb
  with the updated state
  */
  @genType
  type eventProcessor<'eventArgs> = eventProcessorArgs<'eventArgs> => TestHelpers_MockDb.t

  /**
  The default chain ID to use (ethereum mainnet) if a user does not specify int the 
  eventProcessor helper
  */
  let \"DEFAULT_CHAIN_ID" = 1

  /**
  A function composer to help create individual processEvent functions
  */
  let makeEventProcessor = (
    ~contextCreator: Context.contextCreator<'eventArgs, 'loaderContext, 'handlerContext>,
    ~getLoader,
    ~eventWithContextAccessor: (
      Types.eventLog<'eventArgs>,
      unit => 'handlerContext,
    ) => Types.eventAndContext,
    ~eventName: Types.eventName,
  ): eventProcessor<'eventArgs> => {
    ({event, mockDb, ?chainId}) => {
      //The user can specify a chainId of an event or leave it off
      //and it will default to "DEFAULT_CHAIN_ID"
      let chainId = chainId->Option.getWithDefault(\"DEFAULT_CHAIN_ID")

      //Create an individual logging context for traceability
      let logger = Logging.createChild(
        ~params={
          "Context": `Test Processor for ${eventName
            ->Types.eventName_encode
            ->Js.Json.stringify} Event`,
          "Chain ID": chainId,
          "event": event,
        },
      )

      //Deep copy the data in mockDb, mutate the clone and return the clone
      //So no side effects occur here and state can be compared between process
      //steps
      let mockDbClone = mockDb->TestHelpers_MockDb.cloneMockDb

      //Construct a new instance of an in memory store to run for the given event
      let inMemoryStore = IO.InMemoryStore.make()

      //Construct a context with the inMemory store for the given event to run
      //loaders and handlers
      let context = contextCreator(~event, ~inMemoryStore, ~chainId, ~logger)

      let loaderContext = context.getLoaderContext()

      let loader = getLoader()

      //Run the loader, to get all the read values/contract registrations
      //into the context
      loader(~event, ~context=loaderContext)

      //Get all the entities are requested to be loaded from the mockDB
      let entityBatch = context.getEntitiesToLoad()

      //Load requested entities from the cloned mockDb into the inMemoryStore
      mockDbClone->TestHelpers_MockDb.loadEntitiesToInMemStore(~entityBatch, ~inMemoryStore)

      //Run the event and handler context through the eventRouter
      //With inMemoryStore
      let handlerContextGetter = context.getHandlerContext
      let eventAndContext: Types.eventRouterEventAndContext = {
        chainId,
        event: eventWithContextAccessor(event, handlerContextGetter),
      }
      eventAndContext->EventProcessing.eventRouter(~inMemoryStore)

      //Now that the processing is finished. Simulate writing a batch
      //(Although in this case a batch of 1 event only) to the cloned mockDb
      mockDbClone->TestHelpers_MockDb.writeFromMemoryStore(~inMemoryStore)

      //Return the cloned mock db
      mockDbClone
    }
  }

  /**
  Optional params for all additional data related to an eventLog
  */
  @genType
  type mockEventData = {
    blockNumber?: int,
    blockTimestamp?: int,
    blockHash?: string,
    srcAddress?: Ethers.ethAddress,
    transactionHash?: string,
    transactionIndex?: int,
    logIndex?: int,
  }

  /**
  Applies optional paramters with defaults for all common eventLog field
  */
  let makeEventMocker = (
    ~params: 'eventParams,
    ~mockEventData: option<mockEventData>,
  ): Types.eventLog<'eventParams> => {
    let {
      ?blockNumber,
      ?blockTimestamp,
      ?blockHash,
      ?srcAddress,
      ?transactionHash,
      ?transactionIndex,
      ?logIndex,
    } =
      mockEventData->Belt.Option.getWithDefault({})

    {
      params,
      blockNumber: blockNumber->Belt.Option.getWithDefault(0),
      blockTimestamp: blockTimestamp->Belt.Option.getWithDefault(0),
      blockHash: blockHash->Belt.Option.getWithDefault(Ethers.Constants.zeroHash),
      srcAddress: srcAddress->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
      transactionHash: transactionHash->Belt.Option.getWithDefault(Ethers.Constants.zeroHash),
      transactionIndex: transactionIndex->Belt.Option.getWithDefault(0),
      logIndex: logIndex->Belt.Option.getWithDefault(0),
    }
  }
}

module RewardFxdxVault = {
  module AddReward = {
    @genType
    let processEvent = EventFunctions.makeEventProcessor(
      ~contextCreator=Context.RewardFxdxVaultContract.AddRewardEvent.contextCreator,
      ~getLoader=Handlers.RewardFxdxVaultContract.AddReward.getLoader,
      ~eventWithContextAccessor=Types.rewardFxdxVaultContract_AddRewardWithContext,
      ~eventName=Types.RewardFxdxVault_AddReward,
    )

    @genType
    type createMockArgs = {
      rewardId?: Ethers.BigInt.t,
      stakeId?: Ethers.BigInt.t,
      rewardAmount?: Ethers.BigInt.t,
      duration?: Ethers.BigInt.t,
      timestamp?: Ethers.BigInt.t,
      account?: Ethers.ethAddress,
      isClaimed?: bool,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?rewardId,
        ?stakeId,
        ?rewardAmount,
        ?duration,
        ?timestamp,
        ?account,
        ?isClaimed,
        ?mockEventData,
      } = args

      let params: Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs = {
        rewardId: rewardId->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        stakeId: stakeId->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        rewardAmount: rewardAmount->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        duration: duration->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        timestamp: timestamp->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        account: account->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
        isClaimed: isClaimed->Belt.Option.getWithDefault(false),
      }

      EventFunctions.makeEventMocker(~params, ~mockEventData)
    }
  }

  module SendReward = {
    @genType
    let processEvent = EventFunctions.makeEventProcessor(
      ~contextCreator=Context.RewardFxdxVaultContract.SendRewardEvent.contextCreator,
      ~getLoader=Handlers.RewardFxdxVaultContract.SendReward.getLoader,
      ~eventWithContextAccessor=Types.rewardFxdxVaultContract_SendRewardWithContext,
      ~eventName=Types.RewardFxdxVault_SendReward,
    )

    @genType
    type createMockArgs = {
      rewardId?: Ethers.BigInt.t,
      stakeId?: Ethers.BigInt.t,
      rewardAmount?: Ethers.BigInt.t,
      duration?: Ethers.BigInt.t,
      timestamp?: Ethers.BigInt.t,
      account?: Ethers.ethAddress,
      isClaimed?: bool,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?rewardId,
        ?stakeId,
        ?rewardAmount,
        ?duration,
        ?timestamp,
        ?account,
        ?isClaimed,
        ?mockEventData,
      } = args

      let params: Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs = {
        rewardId: rewardId->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        stakeId: stakeId->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        rewardAmount: rewardAmount->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        duration: duration->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        timestamp: timestamp->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        account: account->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
        isClaimed: isClaimed->Belt.Option.getWithDefault(false),
      }

      EventFunctions.makeEventMocker(~params, ~mockEventData)
    }
  }

  module TotalReserves = {
    @genType
    let processEvent = EventFunctions.makeEventProcessor(
      ~contextCreator=Context.RewardFxdxVaultContract.TotalReservesEvent.contextCreator,
      ~getLoader=Handlers.RewardFxdxVaultContract.TotalReserves.getLoader,
      ~eventWithContextAccessor=Types.rewardFxdxVaultContract_TotalReservesWithContext,
      ~eventName=Types.RewardFxdxVault_TotalReserves,
    )

    @genType
    type createMockArgs = {
      vault?: Ethers.ethAddress,
      rewardReserves?: Ethers.BigInt.t,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {?vault, ?rewardReserves, ?mockEventData} = args

      let params: Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs = {
        vault: vault->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
        rewardReserves: rewardReserves->Belt.Option.getWithDefault(Ethers.BigInt.zero),
      }

      EventFunctions.makeEventMocker(~params, ~mockEventData)
    }
  }
}

module StakedFxdxVault = {
  module Stake = {
    @genType
    let processEvent = EventFunctions.makeEventProcessor(
      ~contextCreator=Context.StakedFxdxVaultContract.StakeEvent.contextCreator,
      ~getLoader=Handlers.StakedFxdxVaultContract.Stake.getLoader,
      ~eventWithContextAccessor=Types.stakedFxdxVaultContract_StakeWithContext,
      ~eventName=Types.StakedFxdxVault_Stake,
    )

    @genType
    type createMockArgs = {
      stakeId?: Ethers.BigInt.t,
      amount?: Ethers.BigInt.t,
      duration?: Ethers.BigInt.t,
      rewardInterestRate?: Ethers.BigInt.t,
      timestamp?: Ethers.BigInt.t,
      account?: Ethers.ethAddress,
      unstaked?: bool,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?stakeId,
        ?amount,
        ?duration,
        ?rewardInterestRate,
        ?timestamp,
        ?account,
        ?unstaked,
        ?mockEventData,
      } = args

      let params: Types.StakedFxdxVaultContract.StakeEvent.eventArgs = {
        stakeId: stakeId->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        amount: amount->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        duration: duration->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        rewardInterestRate: rewardInterestRate->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        timestamp: timestamp->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        account: account->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
        unstaked: unstaked->Belt.Option.getWithDefault(false),
      }

      EventFunctions.makeEventMocker(~params, ~mockEventData)
    }
  }

  module TotalReserves = {
    @genType
    let processEvent = EventFunctions.makeEventProcessor(
      ~contextCreator=Context.StakedFxdxVaultContract.TotalReservesEvent.contextCreator,
      ~getLoader=Handlers.StakedFxdxVaultContract.TotalReserves.getLoader,
      ~eventWithContextAccessor=Types.stakedFxdxVaultContract_TotalReservesWithContext,
      ~eventName=Types.StakedFxdxVault_TotalReserves,
    )

    @genType
    type createMockArgs = {
      vault?: Ethers.ethAddress,
      reserves?: Ethers.BigInt.t,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {?vault, ?reserves, ?mockEventData} = args

      let params: Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs = {
        vault: vault->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
        reserves: reserves->Belt.Option.getWithDefault(Ethers.BigInt.zero),
      }

      EventFunctions.makeEventMocker(~params, ~mockEventData)
    }
  }

  module Unstake = {
    @genType
    let processEvent = EventFunctions.makeEventProcessor(
      ~contextCreator=Context.StakedFxdxVaultContract.UnstakeEvent.contextCreator,
      ~getLoader=Handlers.StakedFxdxVaultContract.Unstake.getLoader,
      ~eventWithContextAccessor=Types.stakedFxdxVaultContract_UnstakeWithContext,
      ~eventName=Types.StakedFxdxVault_Unstake,
    )

    @genType
    type createMockArgs = {
      stakeId?: Ethers.BigInt.t,
      amount?: Ethers.BigInt.t,
      duration?: Ethers.BigInt.t,
      rewardInterestRate?: Ethers.BigInt.t,
      timestamp?: Ethers.BigInt.t,
      account?: Ethers.ethAddress,
      unstaked?: bool,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?stakeId,
        ?amount,
        ?duration,
        ?rewardInterestRate,
        ?timestamp,
        ?account,
        ?unstaked,
        ?mockEventData,
      } = args

      let params: Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs = {
        stakeId: stakeId->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        amount: amount->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        duration: duration->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        rewardInterestRate: rewardInterestRate->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        timestamp: timestamp->Belt.Option.getWithDefault(Ethers.BigInt.zero),
        account: account->Belt.Option.getWithDefault(Ethers.Addresses.defaultAddress),
        unstaked: unstaked->Belt.Option.getWithDefault(false),
      }

      EventFunctions.makeEventMocker(~params, ~mockEventData)
    }
  }
}
