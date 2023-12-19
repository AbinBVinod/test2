/* TypeScript file generated from TestHelpers_MockDb.res by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
const TestHelpers_MockDbBS = require('./TestHelpers_MockDb.bs');

import type {EventSyncState_eventSyncState as DbFunctions_EventSyncState_eventSyncState} from './DbFunctions.gen';

import type {InMemoryStore_dynamicContractRegistryKey as IO_InMemoryStore_dynamicContractRegistryKey} from './IO.gen';

import type {InMemoryStore_rawEventsKey as IO_InMemoryStore_rawEventsKey} from './IO.gen';

import type {InMemoryStore_t as IO_InMemoryStore_t} from './IO.gen';

import type {chainId as Types_chainId} from './Types.gen';

import type {dynamicContractRegistryEntity as Types_dynamicContractRegistryEntity} from './Types.gen';

import type {eventsSummaryEntity as Types_eventsSummaryEntity} from './Types.gen';

import type {rawEventsEntity as Types_rawEventsEntity} from './Types.gen';

import type {rewardFxdxVault_AddRewardEntity as Types_rewardFxdxVault_AddRewardEntity} from './Types.gen';

import type {rewardFxdxVault_SendRewardEntity as Types_rewardFxdxVault_SendRewardEntity} from './Types.gen';

import type {rewardFxdxVault_TotalReservesEntity as Types_rewardFxdxVault_TotalReservesEntity} from './Types.gen';

import type {stakedFxdxVault_StakeEntity as Types_stakedFxdxVault_StakeEntity} from './Types.gen';

import type {stakedFxdxVault_TotalReservesEntity as Types_stakedFxdxVault_TotalReservesEntity} from './Types.gen';

import type {stakedFxdxVault_UnstakeEntity as Types_stakedFxdxVault_UnstakeEntity} from './Types.gen';

// tslint:disable-next-line:interface-over-type-literal
export type t = {
  readonly __dbInternal__: IO_InMemoryStore_t; 
  readonly entities: entities; 
  readonly rawEvents: storeOperations<IO_InMemoryStore_rawEventsKey,Types_rawEventsEntity>; 
  readonly eventSyncState: storeOperations<Types_chainId,DbFunctions_EventSyncState_eventSyncState>; 
  readonly dynamicContractRegistry: storeOperations<IO_InMemoryStore_dynamicContractRegistryKey,Types_dynamicContractRegistryEntity>
};

// tslint:disable-next-line:interface-over-type-literal
export type entities = {
  readonly EventsSummary: entityStoreOperations<Types_eventsSummaryEntity>; 
  readonly RewardFxdxVault_AddReward: entityStoreOperations<Types_rewardFxdxVault_AddRewardEntity>; 
  readonly RewardFxdxVault_SendReward: entityStoreOperations<Types_rewardFxdxVault_SendRewardEntity>; 
  readonly RewardFxdxVault_TotalReserves: entityStoreOperations<Types_rewardFxdxVault_TotalReservesEntity>; 
  readonly StakedFxdxVault_Stake: entityStoreOperations<Types_stakedFxdxVault_StakeEntity>; 
  readonly StakedFxdxVault_TotalReserves: entityStoreOperations<Types_stakedFxdxVault_TotalReservesEntity>; 
  readonly StakedFxdxVault_Unstake: entityStoreOperations<Types_stakedFxdxVault_UnstakeEntity>
};

// tslint:disable-next-line:interface-over-type-literal
export type entityStoreOperations<entity> = storeOperations<string,entity>;

// tslint:disable-next-line:interface-over-type-literal
export type storeOperations<entityKey,entity> = {
  readonly getAll: () => entity[]; 
  readonly get: (_1:entityKey) => (undefined | entity); 
  readonly set: (_1:entity) => t; 
  readonly delete: (_1:entityKey) => t
};

export const createMockDb: () => t = TestHelpers_MockDbBS.createMockDb;
