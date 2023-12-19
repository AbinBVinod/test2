type genericContextCreatorFunctions<'loaderContext, 'handlerContext> = {
  getLoaderContext: unit => 'loaderContext,
  getHandlerContext: unit => 'handlerContext,
  getEntitiesToLoad: unit => array<Types.entityRead>,
  getAddedDynamicContractRegistrations: unit => array<Types.dynamicContractRegistryEntity>,
}

type contextCreator<'eventArgs, 'loaderContext, 'handlerContext> = (
  ~inMemoryStore: IO.InMemoryStore.t,
  ~chainId: int,
  ~event: Types.eventLog<'eventArgs>,
  ~logger: Pino.t,
) => genericContextCreatorFunctions<'loaderContext, 'handlerContext>

module RewardFxdxVaultContract = {
  module AddRewardEvent = {
    type handlerContext = Types.RewardFxdxVaultContract.AddRewardEvent.handlerContext
    type loaderContext = Types.RewardFxdxVaultContract.AddRewardEvent.loaderContext

    let contextCreator: contextCreator<
      Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs,
      loaderContext,
      handlerContext,
    > = (~inMemoryStore, ~chainId, ~event, ~logger) => {
      let logger =
        logger->Logging.createChildFrom(
          ~logger=_,
          ~params={"userLog": "RewardFxdxVault.AddReward.context"},
        )
      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addRewardFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "RewardFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
          //TODO only add contracts we've registered for the event in the config
          addStakedFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "StakedFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContext: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          rewardFxdxVault_AddReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_AddReward->IO.InMemoryStore.RewardFxdxVault_AddReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_AddReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_SendReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_SendReward->IO.InMemoryStore.RewardFxdxVault_SendReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_SendReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_TotalReserves->IO.InMemoryStore.RewardFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Stake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Stake->IO.InMemoryStore.StakedFxdxVault_Stake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Stake) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_TotalReserves->IO.InMemoryStore.StakedFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Unstake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Unstake->IO.InMemoryStore.StakedFxdxVault_Unstake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Unstake) with ID ${id}.`,
              ),
          },
        }
      }
      {
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContext,
      }
    }
  }

  module SendRewardEvent = {
    type handlerContext = Types.RewardFxdxVaultContract.SendRewardEvent.handlerContext
    type loaderContext = Types.RewardFxdxVaultContract.SendRewardEvent.loaderContext

    let contextCreator: contextCreator<
      Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs,
      loaderContext,
      handlerContext,
    > = (~inMemoryStore, ~chainId, ~event, ~logger) => {
      let logger =
        logger->Logging.createChildFrom(
          ~logger=_,
          ~params={"userLog": "RewardFxdxVault.SendReward.context"},
        )
      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addRewardFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "RewardFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
          //TODO only add contracts we've registered for the event in the config
          addStakedFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "StakedFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContext: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          rewardFxdxVault_AddReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_AddReward->IO.InMemoryStore.RewardFxdxVault_AddReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_AddReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_SendReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_SendReward->IO.InMemoryStore.RewardFxdxVault_SendReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_SendReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_TotalReserves->IO.InMemoryStore.RewardFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Stake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Stake->IO.InMemoryStore.StakedFxdxVault_Stake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Stake) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_TotalReserves->IO.InMemoryStore.StakedFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Unstake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Unstake->IO.InMemoryStore.StakedFxdxVault_Unstake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Unstake) with ID ${id}.`,
              ),
          },
        }
      }
      {
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContext,
      }
    }
  }

  module TotalReservesEvent = {
    type handlerContext = Types.RewardFxdxVaultContract.TotalReservesEvent.handlerContext
    type loaderContext = Types.RewardFxdxVaultContract.TotalReservesEvent.loaderContext

    let contextCreator: contextCreator<
      Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs,
      loaderContext,
      handlerContext,
    > = (~inMemoryStore, ~chainId, ~event, ~logger) => {
      let logger =
        logger->Logging.createChildFrom(
          ~logger=_,
          ~params={"userLog": "RewardFxdxVault.TotalReserves.context"},
        )
      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addRewardFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "RewardFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
          //TODO only add contracts we've registered for the event in the config
          addStakedFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "StakedFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContext: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          rewardFxdxVault_AddReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_AddReward->IO.InMemoryStore.RewardFxdxVault_AddReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_AddReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_SendReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_SendReward->IO.InMemoryStore.RewardFxdxVault_SendReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_SendReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_TotalReserves->IO.InMemoryStore.RewardFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Stake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Stake->IO.InMemoryStore.StakedFxdxVault_Stake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Stake) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_TotalReserves->IO.InMemoryStore.StakedFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Unstake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Unstake->IO.InMemoryStore.StakedFxdxVault_Unstake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Unstake) with ID ${id}.`,
              ),
          },
        }
      }
      {
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContext,
      }
    }
  }
}

module StakedFxdxVaultContract = {
  module StakeEvent = {
    type handlerContext = Types.StakedFxdxVaultContract.StakeEvent.handlerContext
    type loaderContext = Types.StakedFxdxVaultContract.StakeEvent.loaderContext

    let contextCreator: contextCreator<
      Types.StakedFxdxVaultContract.StakeEvent.eventArgs,
      loaderContext,
      handlerContext,
    > = (~inMemoryStore, ~chainId, ~event, ~logger) => {
      let logger =
        logger->Logging.createChildFrom(
          ~logger=_,
          ~params={"userLog": "StakedFxdxVault.Stake.context"},
        )
      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addRewardFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "RewardFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
          //TODO only add contracts we've registered for the event in the config
          addStakedFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "StakedFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContext: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          rewardFxdxVault_AddReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_AddReward->IO.InMemoryStore.RewardFxdxVault_AddReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_AddReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_SendReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_SendReward->IO.InMemoryStore.RewardFxdxVault_SendReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_SendReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_TotalReserves->IO.InMemoryStore.RewardFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Stake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Stake->IO.InMemoryStore.StakedFxdxVault_Stake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Stake) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_TotalReserves->IO.InMemoryStore.StakedFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Unstake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Unstake->IO.InMemoryStore.StakedFxdxVault_Unstake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Unstake) with ID ${id}.`,
              ),
          },
        }
      }
      {
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContext,
      }
    }
  }

  module TotalReservesEvent = {
    type handlerContext = Types.StakedFxdxVaultContract.TotalReservesEvent.handlerContext
    type loaderContext = Types.StakedFxdxVaultContract.TotalReservesEvent.loaderContext

    let contextCreator: contextCreator<
      Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs,
      loaderContext,
      handlerContext,
    > = (~inMemoryStore, ~chainId, ~event, ~logger) => {
      let logger =
        logger->Logging.createChildFrom(
          ~logger=_,
          ~params={"userLog": "StakedFxdxVault.TotalReserves.context"},
        )
      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addRewardFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "RewardFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
          //TODO only add contracts we've registered for the event in the config
          addStakedFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "StakedFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContext: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          rewardFxdxVault_AddReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_AddReward->IO.InMemoryStore.RewardFxdxVault_AddReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_AddReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_SendReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_SendReward->IO.InMemoryStore.RewardFxdxVault_SendReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_SendReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_TotalReserves->IO.InMemoryStore.RewardFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Stake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Stake->IO.InMemoryStore.StakedFxdxVault_Stake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Stake) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_TotalReserves->IO.InMemoryStore.StakedFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Unstake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Unstake->IO.InMemoryStore.StakedFxdxVault_Unstake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Unstake) with ID ${id}.`,
              ),
          },
        }
      }
      {
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContext,
      }
    }
  }

  module UnstakeEvent = {
    type handlerContext = Types.StakedFxdxVaultContract.UnstakeEvent.handlerContext
    type loaderContext = Types.StakedFxdxVaultContract.UnstakeEvent.loaderContext

    let contextCreator: contextCreator<
      Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs,
      loaderContext,
      handlerContext,
    > = (~inMemoryStore, ~chainId, ~event, ~logger) => {
      let logger =
        logger->Logging.createChildFrom(
          ~logger=_,
          ~params={"userLog": "StakedFxdxVault.Unstake.context"},
        )
      let contextLogger: Logs.userLogger = {
        info: (message: string) => logger->Logging.uinfo(message),
        debug: (message: string) => logger->Logging.udebug(message),
        warn: (message: string) => logger->Logging.uwarn(message),
        error: (message: string) => logger->Logging.uerror(message),
        errorWithExn: (exn: option<Js.Exn.t>, message: string) =>
          logger->Logging.uerrorWithExn(exn, message),
      }

      let optSetOfIds_eventsSummary: Set.t<Types.id> = Set.make()

      let entitiesToLoad: array<Types.entityRead> = []

      let addedDynamicContractRegistrations: array<Types.dynamicContractRegistryEntity> = []

      //Loader context can be defined as a value and the getter can return that value

      @warning("-16")
      let loaderContext: loaderContext = {
        log: contextLogger,
        contractRegistration: {
          //TODO only add contracts we've registered for the event in the config
          addRewardFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "RewardFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
          //TODO only add contracts we've registered for the event in the config
          addStakedFxdxVault: (contractAddress: Ethers.ethAddress) => {
            let eventId = EventUtils.packEventIndex(
              ~blockNumber=event.blockNumber,
              ~logIndex=event.logIndex,
            )
            let dynamicContractRegistration: Types.dynamicContractRegistryEntity = {
              chainId,
              eventId,
              contractAddress,
              contractType: "StakedFxdxVault",
            }

            addedDynamicContractRegistrations->Js.Array2.push(dynamicContractRegistration)->ignore

            inMemoryStore.dynamicContractRegistry->IO.InMemoryStore.DynamicContractRegistry.set(
              ~key={chainId, contractAddress},
              ~entity=dynamicContractRegistration,
              ~dbOp=Set,
            )
          },
        },
        eventsSummary: {
          load: (id: Types.id) => {
            let _ = optSetOfIds_eventsSummary->Set.add(id)
            let _ = Js.Array2.push(entitiesToLoad, Types.EventsSummaryRead(id))
          },
        },
      }

      //handler context must be defined as a getter functoin so that it can construct the context
      //without stale values whenever it is used
      let getHandlerContext: unit => handlerContext = () => {
        {
          log: contextLogger,
          eventsSummary: {
            set: entity => {
              inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(eventsSummary) with ID ${id}.`,
              ),
            get: (id: Types.id) => {
              if optSetOfIds_eventsSummary->Set.has(id) {
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)
              } else {
                Logging.warn(
                  `The loader for a "EventsSummary" of entity with id "${id}" was not used please add it to your default loader function (ie. place 'context.eventsSummary.load("${id}")' inside your loader) to avoid unexpected behaviour. This is a runtime validation check.`,
                )

                // NOTE: this will still retern the value if it exists in the in-memory store (despite the loader not being run).
                inMemoryStore.eventsSummary->IO.InMemoryStore.EventsSummary.get(id)

                // TODO: add a further step to syncronously try fetch this from the DB if it isn't in the in-memory store - similar to this PR: https://github.com/Float-Capital/indexer/pull/759
              }
            },
          },
          rewardFxdxVault_AddReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_AddReward->IO.InMemoryStore.RewardFxdxVault_AddReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_AddReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_SendReward: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_SendReward->IO.InMemoryStore.RewardFxdxVault_SendReward.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_SendReward) with ID ${id}.`,
              ),
          },
          rewardFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.rewardFxdxVault_TotalReserves->IO.InMemoryStore.RewardFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(rewardFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Stake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Stake->IO.InMemoryStore.StakedFxdxVault_Stake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Stake) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_TotalReserves: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_TotalReserves->IO.InMemoryStore.StakedFxdxVault_TotalReserves.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_TotalReserves) with ID ${id}.`,
              ),
          },
          stakedFxdxVault_Unstake: {
            set: entity => {
              inMemoryStore.stakedFxdxVault_Unstake->IO.InMemoryStore.StakedFxdxVault_Unstake.set(
                ~key=entity.id,
                ~entity,
                ~dbOp=Types.Set,
              )
            },
            delete: id =>
              Logging.warn(
                `[unimplemented delete] can't delete entity(stakedFxdxVault_Unstake) with ID ${id}.`,
              ),
          },
        }
      }
      {
        getEntitiesToLoad: () => entitiesToLoad,
        getAddedDynamicContractRegistrations: () => addedDynamicContractRegistrations,
        getLoaderContext: () => loaderContext,
        getHandlerContext,
      }
    }
  }
}
