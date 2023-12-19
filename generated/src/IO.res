module InMemoryStore = {
  let entityCurrentCrud = (currentCrud: option<Types.dbOp>, nextCrud: Types.dbOp): Types.dbOp => {
    switch (currentCrud, nextCrud) {
    | (Some(Set), Read)
    | (_, Set) =>
      Set
    | (Some(Read), Read) => Read
    | (Some(Delete), Read)
    | (_, Delete) =>
      Delete
    | (None, _) => nextCrud
    }
  }

  type stringHasher<'val> = 'val => string
  type storeState<'entity, 'entityKey> = {
    dict: Js.Dict.t<Types.inMemoryStoreRow<'entity>>,
    hasher: stringHasher<'entityKey>,
  }

  module type StoreItem = {
    type t
    type key
    let hasher: stringHasher<key>
  }

  //Binding used for deep cloning stores in tests
  @val external structuredClone: 'a => 'a = "structuredClone"

  module MakeStore = (StoreItem: StoreItem) => {
    type value = StoreItem.t
    type key = StoreItem.key
    type t = storeState<value, key>

    let make = (): t => {dict: Js.Dict.empty(), hasher: StoreItem.hasher}

    let set = (self: t, ~key: StoreItem.key, ~dbOp, ~entity: StoreItem.t) =>
      self.dict->Js.Dict.set(key->self.hasher, {entity, dbOp})

    let get = (self: t, key: StoreItem.key) =>
      self.dict->Js.Dict.get(key->self.hasher)->Belt.Option.map(row => row.entity)

    let values = (self: t) => self.dict->Js.Dict.values

    let clone = (self: t) => {
      ...self,
      dict: self.dict->structuredClone,
    }
  }

  module EventSyncState = MakeStore({
    type t = DbFunctions.EventSyncState.eventSyncState
    type key = int
    let hasher = Belt.Int.toString
  })

  @genType
  type rawEventsKey = {
    chainId: int,
    eventId: string,
  }

  module RawEvents = MakeStore({
    type t = Types.rawEventsEntity
    type key = rawEventsKey
    let hasher = (key: key) =>
      EventUtils.getEventIdKeyString(~chainId=key.chainId, ~eventId=key.eventId)
  })

  @genType
  type dynamicContractRegistryKey = {
    chainId: int,
    contractAddress: Ethers.ethAddress,
  }

  module DynamicContractRegistry = MakeStore({
    type t = Types.dynamicContractRegistryEntity
    type key = dynamicContractRegistryKey
    let hasher = ({chainId, contractAddress}) =>
      EventUtils.getContractAddressKeyString(~chainId, ~contractAddress)
  })

  module EventsSummary = MakeStore({
    type t = Types.eventsSummaryEntity
    type key = string
    let hasher = Obj.magic
  })

  module RewardFxdxVault_AddReward = MakeStore({
    type t = Types.rewardFxdxVault_AddRewardEntity
    type key = string
    let hasher = Obj.magic
  })

  module RewardFxdxVault_SendReward = MakeStore({
    type t = Types.rewardFxdxVault_SendRewardEntity
    type key = string
    let hasher = Obj.magic
  })

  module RewardFxdxVault_TotalReserves = MakeStore({
    type t = Types.rewardFxdxVault_TotalReservesEntity
    type key = string
    let hasher = Obj.magic
  })

  module StakedFxdxVault_Stake = MakeStore({
    type t = Types.stakedFxdxVault_StakeEntity
    type key = string
    let hasher = Obj.magic
  })

  module StakedFxdxVault_TotalReserves = MakeStore({
    type t = Types.stakedFxdxVault_TotalReservesEntity
    type key = string
    let hasher = Obj.magic
  })

  module StakedFxdxVault_Unstake = MakeStore({
    type t = Types.stakedFxdxVault_UnstakeEntity
    type key = string
    let hasher = Obj.magic
  })

  @genType
  type t = {
    eventSyncState: EventSyncState.t,
    rawEvents: RawEvents.t,
    dynamicContractRegistry: DynamicContractRegistry.t,
    eventsSummary: EventsSummary.t,
    rewardFxdxVault_AddReward: RewardFxdxVault_AddReward.t,
    rewardFxdxVault_SendReward: RewardFxdxVault_SendReward.t,
    rewardFxdxVault_TotalReserves: RewardFxdxVault_TotalReserves.t,
    stakedFxdxVault_Stake: StakedFxdxVault_Stake.t,
    stakedFxdxVault_TotalReserves: StakedFxdxVault_TotalReserves.t,
    stakedFxdxVault_Unstake: StakedFxdxVault_Unstake.t,
  }

  let make = (): t => {
    eventSyncState: EventSyncState.make(),
    rawEvents: RawEvents.make(),
    dynamicContractRegistry: DynamicContractRegistry.make(),
    eventsSummary: EventsSummary.make(),
    rewardFxdxVault_AddReward: RewardFxdxVault_AddReward.make(),
    rewardFxdxVault_SendReward: RewardFxdxVault_SendReward.make(),
    rewardFxdxVault_TotalReserves: RewardFxdxVault_TotalReserves.make(),
    stakedFxdxVault_Stake: StakedFxdxVault_Stake.make(),
    stakedFxdxVault_TotalReserves: StakedFxdxVault_TotalReserves.make(),
    stakedFxdxVault_Unstake: StakedFxdxVault_Unstake.make(),
  }

  let clone = (self: t) => {
    eventSyncState: self.eventSyncState->EventSyncState.clone,
    rawEvents: self.rawEvents->RawEvents.clone,
    dynamicContractRegistry: self.dynamicContractRegistry->DynamicContractRegistry.clone,
    eventsSummary: self.eventsSummary->EventsSummary.clone,
    rewardFxdxVault_AddReward: self.rewardFxdxVault_AddReward->RewardFxdxVault_AddReward.clone,
    rewardFxdxVault_SendReward: self.rewardFxdxVault_SendReward->RewardFxdxVault_SendReward.clone,
    rewardFxdxVault_TotalReserves: self.rewardFxdxVault_TotalReserves->RewardFxdxVault_TotalReserves.clone,
    stakedFxdxVault_Stake: self.stakedFxdxVault_Stake->StakedFxdxVault_Stake.clone,
    stakedFxdxVault_TotalReserves: self.stakedFxdxVault_TotalReserves->StakedFxdxVault_TotalReserves.clone,
    stakedFxdxVault_Unstake: self.stakedFxdxVault_Unstake->StakedFxdxVault_Unstake.clone,
  }
}

module LoadLayer = {
  /**The ids to load for a particular entity*/
  type idsToLoad = Belt.Set.String.t

  /**
  A round of entities to load from the DB. Depending on what entities come back
  and the dataLoaded "actions" that get run after the entities are loaded up. It
  could mean another load layer is created based of values that are returned
  */
  type rec t = {
    //A an array of getters to run after the entities with idsToLoad have been loaded
    dataLoadedActionsGetters: dataLoadedActionsGetters,
    //A unique list of ids that need to be loaded for entity eventsSummary
    eventsSummaryIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity rewardFxdxVault_AddReward
    rewardFxdxVault_AddRewardIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity rewardFxdxVault_SendReward
    rewardFxdxVault_SendRewardIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity rewardFxdxVault_TotalReserves
    rewardFxdxVault_TotalReservesIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity stakedFxdxVault_Stake
    stakedFxdxVault_StakeIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity stakedFxdxVault_TotalReserves
    stakedFxdxVault_TotalReservesIdsToLoad: idsToLoad,
    //A unique list of ids that need to be loaded for entity stakedFxdxVault_Unstake
    stakedFxdxVault_UnstakeIdsToLoad: idsToLoad,
  }
  //An action that gets run after the data is loaded in from the db to the in memory store
  //the action will derive values from the loaded data and update the next load layer
  and dataLoadedAction = t => t
  //A getter function that returns an array of actions that need to be run
  //Actions will fetch values from the in memory store and update a load layer
  and dataLoadedActionsGetter = unit => array<dataLoadedAction>
  //An array of getter functions for dataLoadedActions
  and dataLoadedActionsGetters = array<dataLoadedActionsGetter>

  /**Instantiates a load layer*/
  let emptyLoadLayer = () => {
    eventsSummaryIdsToLoad: Belt.Set.String.empty,
    rewardFxdxVault_AddRewardIdsToLoad: Belt.Set.String.empty,
    rewardFxdxVault_SendRewardIdsToLoad: Belt.Set.String.empty,
    rewardFxdxVault_TotalReservesIdsToLoad: Belt.Set.String.empty,
    stakedFxdxVault_StakeIdsToLoad: Belt.Set.String.empty,
    stakedFxdxVault_TotalReservesIdsToLoad: Belt.Set.String.empty,
    stakedFxdxVault_UnstakeIdsToLoad: Belt.Set.String.empty,
    dataLoadedActionsGetters: [],
  }

  /* Helper to append an ID to load for a given entity to the loadLayer */
  let extendIdsToLoad = (idsToLoad: idsToLoad, entityId: Types.id): idsToLoad =>
    idsToLoad->Belt.Set.String.add(entityId)

  /* Helper to append a getter for DataLoadedActions to load for a given entity to the loadLayer */
  let extendDataLoadedActionsGetters = (
    dataLoadedActionsGetters: dataLoadedActionsGetters,
    newDataLoadedActionsGetters: dataLoadedActionsGetters,
  ): dataLoadedActionsGetters =>
    dataLoadedActionsGetters->Belt.Array.concat(newDataLoadedActionsGetters)
}

//remove warning 39 for unused "rec" flag in case of no other related loaders
/**
Loader functions for each entity. The loader function extends a load layer with the given id and config.
*/
@warning("-39")
let rec eventsSummaryLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~eventsSummaryLoaderConfig: Types.eventsSummaryLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "eventsSummaryLoaderConfig" type is a boolean.
  if !eventsSummaryLoaderConfig {
    //If eventsSummaryLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If eventsSummaryLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      eventsSummaryIdsToLoad: loadLayer.eventsSummaryIdsToLoad->LoadLayer.extendIdsToLoad(entityId),
    }
  }
}
@warning("-27")
and rewardFxdxVault_AddRewardLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~rewardFxdxVault_AddRewardLoaderConfig: Types.rewardFxdxVault_AddRewardLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "rewardFxdxVault_AddRewardLoaderConfig" type is a boolean.
  if !rewardFxdxVault_AddRewardLoaderConfig {
    //If rewardFxdxVault_AddRewardLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If rewardFxdxVault_AddRewardLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      rewardFxdxVault_AddRewardIdsToLoad: loadLayer.rewardFxdxVault_AddRewardIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and rewardFxdxVault_SendRewardLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~rewardFxdxVault_SendRewardLoaderConfig: Types.rewardFxdxVault_SendRewardLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "rewardFxdxVault_SendRewardLoaderConfig" type is a boolean.
  if !rewardFxdxVault_SendRewardLoaderConfig {
    //If rewardFxdxVault_SendRewardLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If rewardFxdxVault_SendRewardLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      rewardFxdxVault_SendRewardIdsToLoad: loadLayer.rewardFxdxVault_SendRewardIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and rewardFxdxVault_TotalReservesLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~rewardFxdxVault_TotalReservesLoaderConfig: Types.rewardFxdxVault_TotalReservesLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "rewardFxdxVault_TotalReservesLoaderConfig" type is a boolean.
  if !rewardFxdxVault_TotalReservesLoaderConfig {
    //If rewardFxdxVault_TotalReservesLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If rewardFxdxVault_TotalReservesLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      rewardFxdxVault_TotalReservesIdsToLoad: loadLayer.rewardFxdxVault_TotalReservesIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and stakedFxdxVault_StakeLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~stakedFxdxVault_StakeLoaderConfig: Types.stakedFxdxVault_StakeLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "stakedFxdxVault_StakeLoaderConfig" type is a boolean.
  if !stakedFxdxVault_StakeLoaderConfig {
    //If stakedFxdxVault_StakeLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If stakedFxdxVault_StakeLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      stakedFxdxVault_StakeIdsToLoad: loadLayer.stakedFxdxVault_StakeIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and stakedFxdxVault_TotalReservesLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~stakedFxdxVault_TotalReservesLoaderConfig: Types.stakedFxdxVault_TotalReservesLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "stakedFxdxVault_TotalReservesLoaderConfig" type is a boolean.
  if !stakedFxdxVault_TotalReservesLoaderConfig {
    //If stakedFxdxVault_TotalReservesLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If stakedFxdxVault_TotalReservesLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      stakedFxdxVault_TotalReservesIdsToLoad: loadLayer.stakedFxdxVault_TotalReservesIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}
@warning("-27")
and stakedFxdxVault_UnstakeLinkedEntityLoader = (
  loadLayer: LoadLayer.t,
  ~entityId: string,
  ~inMemoryStore: InMemoryStore.t,
  ~stakedFxdxVault_UnstakeLoaderConfig: Types.stakedFxdxVault_UnstakeLoaderConfig,
): LoadLayer.t => {
  //No dataLoaded actions need to happen on the in memory
  //since there are no relational non-derivedfrom params
  let _ = inMemoryStore //ignore inMemoryStore and stop warning

  //In this case the "stakedFxdxVault_UnstakeLoaderConfig" type is a boolean.
  if !stakedFxdxVault_UnstakeLoaderConfig {
    //If stakedFxdxVault_UnstakeLoaderConfig is false, don't load the entity
    //simply return the current load layer
    loadLayer
  } else {
    //If stakedFxdxVault_UnstakeLoaderConfig is true,
    //extend the entity ids to load field
    //There can be no dataLoadedActionsGetters to add since this type does not contain
    //any non derived from relational params
    {
      ...loadLayer,
      stakedFxdxVault_UnstakeIdsToLoad: loadLayer.stakedFxdxVault_UnstakeIdsToLoad->LoadLayer.extendIdsToLoad(
        entityId,
      ),
    }
  }
}

/**
Creates and populates a load layer with the current in memory store and an array of entityRead variants
*/
let getLoadLayer = (~entityBatch: array<Types.entityRead>, ~inMemoryStore) => {
  entityBatch->Belt.Array.reduce(LoadLayer.emptyLoadLayer(), (loadLayer, readEntity) => {
    switch readEntity {
    | EventsSummaryRead(entityId) =>
      loadLayer->eventsSummaryLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~eventsSummaryLoaderConfig=true,
      )
    | RewardFxdxVault_AddRewardRead(entityId) =>
      loadLayer->rewardFxdxVault_AddRewardLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~rewardFxdxVault_AddRewardLoaderConfig=true,
      )
    | RewardFxdxVault_SendRewardRead(entityId) =>
      loadLayer->rewardFxdxVault_SendRewardLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~rewardFxdxVault_SendRewardLoaderConfig=true,
      )
    | RewardFxdxVault_TotalReservesRead(entityId) =>
      loadLayer->rewardFxdxVault_TotalReservesLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~rewardFxdxVault_TotalReservesLoaderConfig=true,
      )
    | StakedFxdxVault_StakeRead(entityId) =>
      loadLayer->stakedFxdxVault_StakeLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~stakedFxdxVault_StakeLoaderConfig=true,
      )
    | StakedFxdxVault_TotalReservesRead(entityId) =>
      loadLayer->stakedFxdxVault_TotalReservesLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~stakedFxdxVault_TotalReservesLoaderConfig=true,
      )
    | StakedFxdxVault_UnstakeRead(entityId) =>
      loadLayer->stakedFxdxVault_UnstakeLinkedEntityLoader(
        ~entityId,
        ~inMemoryStore,
        ~stakedFxdxVault_UnstakeLoaderConfig=true,
      )
    }
  })
}

/**
Represents whether a deeper layer needs to be executed or whether the last layer
has been executed
*/
type nextLayer = NextLayer(LoadLayer.t) | LastLayer

let getNextLayer = (~loadLayer: LoadLayer.t) =>
  switch loadLayer.dataLoadedActionsGetters {
  | [] => LastLayer
  | dataLoadedActionsGetters =>
    dataLoadedActionsGetters
    ->Belt.Array.reduce(LoadLayer.emptyLoadLayer(), (loadLayer, getLoadedActions) => {
      //call getLoadedActions returns array of of actions to run against the load layer
      getLoadedActions()->Belt.Array.reduce(loadLayer, (loadLayer, action) => {
        action(loadLayer)
      })
    })
    ->NextLayer
  }

/**
Used for composing a loadlayer executor
*/
type entityExecutor<'executorRes> = {
  idsToLoad: LoadLayer.idsToLoad,
  executor: LoadLayer.idsToLoad => 'executorRes,
}

/**
Compose an execute load layer function. Used to compose an executor
for a postgres db or a mock db in the testing framework.
*/
let executeLoadLayerComposer = (
  ~entityExecutors: array<entityExecutor<'exectuorRes>>,
  ~handleResponses: array<'exectuorRes> => 'nextLoadlayer,
) => {
  entityExecutors
  ->Belt.Array.map(({idsToLoad, executor}) => {
    idsToLoad->executor
  })
  ->handleResponses
}

/**Recursively load layers with execute fn composer. Can be used with async or sync functions*/
let rec executeNestedLoadLayersComposer = (
  ~loadLayer,
  ~inMemoryStore,
  //Could be an execution function that is async or sync
  ~executeLoadLayerFn,
  //A call back function, for async or sync
  ~then,
  //Unit value, either wrapped in a promise or not
  ~unit,
) => {
  executeLoadLayerFn(~loadLayer, ~inMemoryStore)->then(res =>
    switch res {
    | LastLayer => unit
    | NextLayer(loadLayer) =>
      executeNestedLoadLayersComposer(~loadLayer, ~inMemoryStore, ~executeLoadLayerFn, ~then, ~unit)
    }
  )
}

/**Load all entities in the entity batch from the db to the inMemoryStore */
let loadEntitiesToInMemStoreComposer = (
  ~entityBatch,
  ~inMemoryStore,
  ~executeLoadLayerFn,
  ~then,
  ~unit,
) => {
  executeNestedLoadLayersComposer(
    ~inMemoryStore,
    ~loadLayer=getLoadLayer(~inMemoryStore, ~entityBatch),
    ~executeLoadLayerFn,
    ~then,
    ~unit,
  )
}

let makeEntityExecuterComposer = (
  ~idsToLoad,
  ~dbReadFn,
  ~inMemStoreSetFn,
  ~store,
  ~getEntiyId,
  ~unit,
  ~then,
) => {
  idsToLoad,
  executor: idsToLoad => {
    switch idsToLoad->Belt.Set.String.toArray {
    | [] => unit //Check if there are values so we don't create an unnecessary empty query
    | idsToLoad =>
      idsToLoad
      ->dbReadFn
      ->then(entities =>
        entities->Belt.Array.forEach(entity => {
          store->inMemStoreSetFn(~key=entity->getEntiyId, ~dbOp=Types.Read, ~entity)
        })
      )
    }
  },
}

/**
Specifically create an sql executor with async functionality
*/
let makeSqlEntityExecuter = (~idsToLoad, ~dbReadFn, ~inMemStoreSetFn, ~store, ~getEntiyId) => {
  makeEntityExecuterComposer(
    ~dbReadFn=DbFunctions.sql->dbReadFn,
    ~idsToLoad,
    ~getEntiyId,
    ~store,
    ~inMemStoreSetFn,
    ~then=Promise.thenResolve,
    ~unit=Promise.resolve(),
  )
}

/**
Executes a single load layer using the async sql functions
*/
let executeSqlLoadLayer = (~loadLayer: LoadLayer.t, ~inMemoryStore: InMemoryStore.t) => {
  let entityExecutors = [
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.eventsSummaryIdsToLoad,
      ~dbReadFn=DbFunctions.EventsSummary.readEntities,
      ~inMemStoreSetFn=InMemoryStore.EventsSummary.set,
      ~store=inMemoryStore.eventsSummary,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.rewardFxdxVault_AddRewardIdsToLoad,
      ~dbReadFn=DbFunctions.RewardFxdxVault_AddReward.readEntities,
      ~inMemStoreSetFn=InMemoryStore.RewardFxdxVault_AddReward.set,
      ~store=inMemoryStore.rewardFxdxVault_AddReward,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.rewardFxdxVault_SendRewardIdsToLoad,
      ~dbReadFn=DbFunctions.RewardFxdxVault_SendReward.readEntities,
      ~inMemStoreSetFn=InMemoryStore.RewardFxdxVault_SendReward.set,
      ~store=inMemoryStore.rewardFxdxVault_SendReward,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.rewardFxdxVault_TotalReservesIdsToLoad,
      ~dbReadFn=DbFunctions.RewardFxdxVault_TotalReserves.readEntities,
      ~inMemStoreSetFn=InMemoryStore.RewardFxdxVault_TotalReserves.set,
      ~store=inMemoryStore.rewardFxdxVault_TotalReserves,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.stakedFxdxVault_StakeIdsToLoad,
      ~dbReadFn=DbFunctions.StakedFxdxVault_Stake.readEntities,
      ~inMemStoreSetFn=InMemoryStore.StakedFxdxVault_Stake.set,
      ~store=inMemoryStore.stakedFxdxVault_Stake,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.stakedFxdxVault_TotalReservesIdsToLoad,
      ~dbReadFn=DbFunctions.StakedFxdxVault_TotalReserves.readEntities,
      ~inMemStoreSetFn=InMemoryStore.StakedFxdxVault_TotalReserves.set,
      ~store=inMemoryStore.stakedFxdxVault_TotalReserves,
      ~getEntiyId=entity => entity.id,
    ),
    makeSqlEntityExecuter(
      ~idsToLoad=loadLayer.stakedFxdxVault_UnstakeIdsToLoad,
      ~dbReadFn=DbFunctions.StakedFxdxVault_Unstake.readEntities,
      ~inMemStoreSetFn=InMemoryStore.StakedFxdxVault_Unstake.set,
      ~store=inMemoryStore.stakedFxdxVault_Unstake,
      ~getEntiyId=entity => entity.id,
    ),
  ]
  let handleResponses = responses => {
    responses
    ->Promise.all
    ->Promise.thenResolve(_ => {
      getNextLayer(~loadLayer)
    })
  }

  executeLoadLayerComposer(~entityExecutors, ~handleResponses)
}

/**Execute loading of entities using sql*/
let loadEntitiesToInMemStore = (~entityBatch, ~inMemoryStore) => {
  loadEntitiesToInMemStoreComposer(
    ~inMemoryStore,
    ~entityBatch,
    ~executeLoadLayerFn=executeSqlLoadLayer,
    ~then=Promise.then,
    ~unit=Promise.resolve(),
  )
}

let executeEntityFunction = (
  sql: Postgres.sql,
  ~rows: array<Types.inMemoryStoreRow<'a>>,
  ~dbOp: Types.dbOp,
  ~dbFunction: (Postgres.sql, array<'b>) => promise<unit>,
  ~getInputValFromRow: Types.inMemoryStoreRow<'a> => 'b,
) => {
  let entityIds =
    rows->Belt.Array.keepMap(row => row.dbOp == dbOp ? Some(row->getInputValFromRow) : None)

  if entityIds->Array.length > 0 {
    sql->dbFunction(entityIds)
  } else {
    Promise.resolve()
  }
}

let executeSet = executeEntityFunction(~dbOp=Set)
let executeDelete = executeEntityFunction(~dbOp=Delete)

let executeSetSchemaEntity = (~entityEncoder) =>
  executeSet(~getInputValFromRow=row => {
    row.entity->entityEncoder
  })

let executeBatch = async (sql, ~inMemoryStore: InMemoryStore.t) => {
  let setEventSyncState = executeSet(
    ~dbFunction=DbFunctions.EventSyncState.batchSet,
    ~getInputValFromRow=row => row.entity,
    ~rows=inMemoryStore.eventSyncState->InMemoryStore.EventSyncState.values,
  )

  let setRawEvents = executeSet(
    ~dbFunction=DbFunctions.RawEvents.batchSet,
    ~getInputValFromRow=row => row.entity,
    ~rows=inMemoryStore.rawEvents->InMemoryStore.RawEvents.values,
  )

  let setDynamicContracts = executeSet(
    ~dbFunction=DbFunctions.DynamicContractRegistry.batchSet,
    ~rows=inMemoryStore.dynamicContractRegistry->InMemoryStore.DynamicContractRegistry.values,
    ~getInputValFromRow={row => row.entity},
  )

  let deleteEventsSummarys = executeDelete(
    ~dbFunction=DbFunctions.EventsSummary.batchDelete,
    ~rows=inMemoryStore.eventsSummary->InMemoryStore.EventsSummary.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setEventsSummarys = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.EventsSummary.batchSet,
    ~rows=inMemoryStore.eventsSummary->InMemoryStore.EventsSummary.values,
    ~entityEncoder=Types.eventsSummaryEntity_encode,
  )

  let deleteRewardFxdxVault_AddRewards = executeDelete(
    ~dbFunction=DbFunctions.RewardFxdxVault_AddReward.batchDelete,
    ~rows=inMemoryStore.rewardFxdxVault_AddReward->InMemoryStore.RewardFxdxVault_AddReward.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setRewardFxdxVault_AddRewards = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.RewardFxdxVault_AddReward.batchSet,
    ~rows=inMemoryStore.rewardFxdxVault_AddReward->InMemoryStore.RewardFxdxVault_AddReward.values,
    ~entityEncoder=Types.rewardFxdxVault_AddRewardEntity_encode,
  )

  let deleteRewardFxdxVault_SendRewards = executeDelete(
    ~dbFunction=DbFunctions.RewardFxdxVault_SendReward.batchDelete,
    ~rows=inMemoryStore.rewardFxdxVault_SendReward->InMemoryStore.RewardFxdxVault_SendReward.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setRewardFxdxVault_SendRewards = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.RewardFxdxVault_SendReward.batchSet,
    ~rows=inMemoryStore.rewardFxdxVault_SendReward->InMemoryStore.RewardFxdxVault_SendReward.values,
    ~entityEncoder=Types.rewardFxdxVault_SendRewardEntity_encode,
  )

  let deleteRewardFxdxVault_TotalReservess = executeDelete(
    ~dbFunction=DbFunctions.RewardFxdxVault_TotalReserves.batchDelete,
    ~rows=inMemoryStore.rewardFxdxVault_TotalReserves->InMemoryStore.RewardFxdxVault_TotalReserves.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setRewardFxdxVault_TotalReservess = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.RewardFxdxVault_TotalReserves.batchSet,
    ~rows=inMemoryStore.rewardFxdxVault_TotalReserves->InMemoryStore.RewardFxdxVault_TotalReserves.values,
    ~entityEncoder=Types.rewardFxdxVault_TotalReservesEntity_encode,
  )

  let deleteStakedFxdxVault_Stakes = executeDelete(
    ~dbFunction=DbFunctions.StakedFxdxVault_Stake.batchDelete,
    ~rows=inMemoryStore.stakedFxdxVault_Stake->InMemoryStore.StakedFxdxVault_Stake.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setStakedFxdxVault_Stakes = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.StakedFxdxVault_Stake.batchSet,
    ~rows=inMemoryStore.stakedFxdxVault_Stake->InMemoryStore.StakedFxdxVault_Stake.values,
    ~entityEncoder=Types.stakedFxdxVault_StakeEntity_encode,
  )

  let deleteStakedFxdxVault_TotalReservess = executeDelete(
    ~dbFunction=DbFunctions.StakedFxdxVault_TotalReserves.batchDelete,
    ~rows=inMemoryStore.stakedFxdxVault_TotalReserves->InMemoryStore.StakedFxdxVault_TotalReserves.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setStakedFxdxVault_TotalReservess = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.StakedFxdxVault_TotalReserves.batchSet,
    ~rows=inMemoryStore.stakedFxdxVault_TotalReserves->InMemoryStore.StakedFxdxVault_TotalReserves.values,
    ~entityEncoder=Types.stakedFxdxVault_TotalReservesEntity_encode,
  )

  let deleteStakedFxdxVault_Unstakes = executeDelete(
    ~dbFunction=DbFunctions.StakedFxdxVault_Unstake.batchDelete,
    ~rows=inMemoryStore.stakedFxdxVault_Unstake->InMemoryStore.StakedFxdxVault_Unstake.values,
    ~getInputValFromRow={row => row.entity.id},
  )

  let setStakedFxdxVault_Unstakes = executeSetSchemaEntity(
    ~dbFunction=DbFunctions.StakedFxdxVault_Unstake.batchSet,
    ~rows=inMemoryStore.stakedFxdxVault_Unstake->InMemoryStore.StakedFxdxVault_Unstake.values,
    ~entityEncoder=Types.stakedFxdxVault_UnstakeEntity_encode,
  )

  let res = await sql->Postgres.beginSql(sql => {
    [
      setEventSyncState,
      setRawEvents,
      setDynamicContracts,
      deleteEventsSummarys,
      setEventsSummarys,
      deleteRewardFxdxVault_AddRewards,
      setRewardFxdxVault_AddRewards,
      deleteRewardFxdxVault_SendRewards,
      setRewardFxdxVault_SendRewards,
      deleteRewardFxdxVault_TotalReservess,
      setRewardFxdxVault_TotalReservess,
      deleteStakedFxdxVault_Stakes,
      setStakedFxdxVault_Stakes,
      deleteStakedFxdxVault_TotalReservess,
      setStakedFxdxVault_TotalReservess,
      deleteStakedFxdxVault_Unstakes,
      setStakedFxdxVault_Unstakes,
    ]->Belt.Array.map(dbFunc => sql->dbFunc)
  })

  res
}
