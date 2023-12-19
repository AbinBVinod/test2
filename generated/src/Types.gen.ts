/* TypeScript file generated from Types.res by genType. */
/* eslint-disable import/first */


import type {BigInt_t as Ethers_BigInt_t} from '../src/bindings/Ethers.gen';

import type {Json_t as Js_Json_t} from '../src/Js.shim';

import type {Nullable as $$nullable} from './bindings/OpaqueTypes';

import type {ethAddress as Ethers_ethAddress} from '../src/bindings/Ethers.gen';

import type {userLogger as Logs_userLogger} from './Logs.gen';

// tslint:disable-next-line:interface-over-type-literal
export type id = string;
export type Id = id;

// tslint:disable-next-line:interface-over-type-literal
export type nullable<a> = $$nullable<a>;

// tslint:disable-next-line:interface-over-type-literal
export type eventsSummaryLoaderConfig = boolean;

// tslint:disable-next-line:interface-over-type-literal
export type rawEventsEntity = {
  readonly chain_id: number; 
  readonly event_id: string; 
  readonly block_number: number; 
  readonly log_index: number; 
  readonly transaction_index: number; 
  readonly transaction_hash: string; 
  readonly src_address: Ethers_ethAddress; 
  readonly block_hash: string; 
  readonly block_timestamp: number; 
  readonly event_type: Js_Json_t; 
  readonly params: string
};

// tslint:disable-next-line:interface-over-type-literal
export type dynamicContractRegistryEntity = {
  readonly chain_id: number; 
  readonly event_id: Ethers_BigInt_t; 
  readonly contract_address: Ethers_ethAddress; 
  readonly contract_type: string
};

// tslint:disable-next-line:interface-over-type-literal
export type eventsSummaryEntity = {
  readonly id: id; 
  readonly rewardFxdxVault_AddRewardCount: Ethers_BigInt_t; 
  readonly rewardFxdxVault_SendRewardCount: Ethers_BigInt_t; 
  readonly rewardFxdxVault_TotalReservesCount: Ethers_BigInt_t; 
  readonly stakedFxdxVault_StakeCount: Ethers_BigInt_t; 
  readonly stakedFxdxVault_TotalReservesCount: Ethers_BigInt_t; 
  readonly stakedFxdxVault_UnstakeCount: Ethers_BigInt_t
};
export type EventsSummaryEntity = eventsSummaryEntity;

// tslint:disable-next-line:interface-over-type-literal
export type rewardFxdxVault_AddRewardEntity = {
  readonly id: id; 
  readonly rewardId: Ethers_BigInt_t; 
  readonly stakeId: Ethers_BigInt_t; 
  readonly rewardAmount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: string; 
  readonly isClaimed: boolean; 
  readonly eventsSummary: string
};
export type RewardFxdxVault_AddRewardEntity = rewardFxdxVault_AddRewardEntity;

// tslint:disable-next-line:interface-over-type-literal
export type rewardFxdxVault_SendRewardEntity = {
  readonly id: id; 
  readonly rewardId: Ethers_BigInt_t; 
  readonly stakeId: Ethers_BigInt_t; 
  readonly rewardAmount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: string; 
  readonly isClaimed: boolean; 
  readonly eventsSummary: string
};
export type RewardFxdxVault_SendRewardEntity = rewardFxdxVault_SendRewardEntity;

// tslint:disable-next-line:interface-over-type-literal
export type rewardFxdxVault_TotalReservesEntity = {
  readonly id: id; 
  readonly vault: string; 
  readonly rewardReserves: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type RewardFxdxVault_TotalReservesEntity = rewardFxdxVault_TotalReservesEntity;

// tslint:disable-next-line:interface-over-type-literal
export type stakedFxdxVault_StakeEntity = {
  readonly id: id; 
  readonly stakeId: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly rewardInterestRate: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: string; 
  readonly unstaked: boolean; 
  readonly eventsSummary: string
};
export type StakedFxdxVault_StakeEntity = stakedFxdxVault_StakeEntity;

// tslint:disable-next-line:interface-over-type-literal
export type stakedFxdxVault_TotalReservesEntity = {
  readonly id: id; 
  readonly vault: string; 
  readonly reserves: Ethers_BigInt_t; 
  readonly eventsSummary: string
};
export type StakedFxdxVault_TotalReservesEntity = stakedFxdxVault_TotalReservesEntity;

// tslint:disable-next-line:interface-over-type-literal
export type stakedFxdxVault_UnstakeEntity = {
  readonly id: id; 
  readonly stakeId: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly rewardInterestRate: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: string; 
  readonly unstaked: boolean; 
  readonly eventsSummary: string
};
export type StakedFxdxVault_UnstakeEntity = stakedFxdxVault_UnstakeEntity;

// tslint:disable-next-line:interface-over-type-literal
export type eventLog<a> = {
  readonly params: a; 
  readonly blockNumber: number; 
  readonly blockTimestamp: number; 
  readonly blockHash: string; 
  readonly srcAddress: Ethers_ethAddress; 
  readonly transactionHash: string; 
  readonly transactionIndex: number; 
  readonly logIndex: number
};
export type EventLog<a> = eventLog<a>;

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_eventArgs = {
  readonly rewardId: Ethers_BigInt_t; 
  readonly stakeId: Ethers_BigInt_t; 
  readonly rewardAmount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: Ethers_ethAddress; 
  readonly isClaimed: boolean
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_log = eventLog<RewardFxdxVaultContract_AddRewardEvent_eventArgs>;
export type RewardFxdxVaultContract_AddReward_EventLog = RewardFxdxVaultContract_AddRewardEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_rewardFxdxVault_AddRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_AddRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_rewardFxdxVault_SendRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_SendRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_rewardFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_stakedFxdxVault_StakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_StakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_stakedFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_stakedFxdxVault_UnstakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_UnstakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: RewardFxdxVaultContract_AddRewardEvent_eventsSummaryEntityHandlerContext; 
  readonly RewardFxdxVault_AddReward: RewardFxdxVaultContract_AddRewardEvent_rewardFxdxVault_AddRewardEntityHandlerContext; 
  readonly RewardFxdxVault_SendReward: RewardFxdxVaultContract_AddRewardEvent_rewardFxdxVault_SendRewardEntityHandlerContext; 
  readonly RewardFxdxVault_TotalReserves: RewardFxdxVaultContract_AddRewardEvent_rewardFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Stake: RewardFxdxVaultContract_AddRewardEvent_stakedFxdxVault_StakeEntityHandlerContext; 
  readonly StakedFxdxVault_TotalReserves: RewardFxdxVaultContract_AddRewardEvent_stakedFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Unstake: RewardFxdxVaultContract_AddRewardEvent_stakedFxdxVault_UnstakeEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_contractRegistrations = { readonly addRewardFxdxVault: (_1:Ethers_ethAddress) => void; readonly addStakedFxdxVault: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_AddRewardEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: RewardFxdxVaultContract_AddRewardEvent_contractRegistrations; 
  readonly EventsSummary: RewardFxdxVaultContract_AddRewardEvent_eventsSummaryEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_eventArgs = {
  readonly rewardId: Ethers_BigInt_t; 
  readonly stakeId: Ethers_BigInt_t; 
  readonly rewardAmount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: Ethers_ethAddress; 
  readonly isClaimed: boolean
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_log = eventLog<RewardFxdxVaultContract_SendRewardEvent_eventArgs>;
export type RewardFxdxVaultContract_SendReward_EventLog = RewardFxdxVaultContract_SendRewardEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_rewardFxdxVault_AddRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_AddRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_rewardFxdxVault_SendRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_SendRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_rewardFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_stakedFxdxVault_StakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_StakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_stakedFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_stakedFxdxVault_UnstakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_UnstakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: RewardFxdxVaultContract_SendRewardEvent_eventsSummaryEntityHandlerContext; 
  readonly RewardFxdxVault_AddReward: RewardFxdxVaultContract_SendRewardEvent_rewardFxdxVault_AddRewardEntityHandlerContext; 
  readonly RewardFxdxVault_SendReward: RewardFxdxVaultContract_SendRewardEvent_rewardFxdxVault_SendRewardEntityHandlerContext; 
  readonly RewardFxdxVault_TotalReserves: RewardFxdxVaultContract_SendRewardEvent_rewardFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Stake: RewardFxdxVaultContract_SendRewardEvent_stakedFxdxVault_StakeEntityHandlerContext; 
  readonly StakedFxdxVault_TotalReserves: RewardFxdxVaultContract_SendRewardEvent_stakedFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Unstake: RewardFxdxVaultContract_SendRewardEvent_stakedFxdxVault_UnstakeEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_contractRegistrations = { readonly addRewardFxdxVault: (_1:Ethers_ethAddress) => void; readonly addStakedFxdxVault: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_SendRewardEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: RewardFxdxVaultContract_SendRewardEvent_contractRegistrations; 
  readonly EventsSummary: RewardFxdxVaultContract_SendRewardEvent_eventsSummaryEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_eventArgs = { readonly vault: Ethers_ethAddress; readonly rewardReserves: Ethers_BigInt_t };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_log = eventLog<RewardFxdxVaultContract_TotalReservesEvent_eventArgs>;
export type RewardFxdxVaultContract_TotalReserves_EventLog = RewardFxdxVaultContract_TotalReservesEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_AddRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_AddRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_SendRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_SendRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_StakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_StakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_UnstakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_UnstakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: RewardFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityHandlerContext; 
  readonly RewardFxdxVault_AddReward: RewardFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_AddRewardEntityHandlerContext; 
  readonly RewardFxdxVault_SendReward: RewardFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_SendRewardEntityHandlerContext; 
  readonly RewardFxdxVault_TotalReserves: RewardFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Stake: RewardFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_StakeEntityHandlerContext; 
  readonly StakedFxdxVault_TotalReserves: RewardFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Unstake: RewardFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_UnstakeEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_contractRegistrations = { readonly addRewardFxdxVault: (_1:Ethers_ethAddress) => void; readonly addStakedFxdxVault: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVaultContract_TotalReservesEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: RewardFxdxVaultContract_TotalReservesEvent_contractRegistrations; 
  readonly EventsSummary: RewardFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_eventArgs = {
  readonly stakeId: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly rewardInterestRate: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: Ethers_ethAddress; 
  readonly unstaked: boolean
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_log = eventLog<StakedFxdxVaultContract_StakeEvent_eventArgs>;
export type StakedFxdxVaultContract_Stake_EventLog = StakedFxdxVaultContract_StakeEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_rewardFxdxVault_AddRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_AddRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_rewardFxdxVault_SendRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_SendRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_rewardFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_stakedFxdxVault_StakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_StakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_stakedFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_stakedFxdxVault_UnstakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_UnstakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: StakedFxdxVaultContract_StakeEvent_eventsSummaryEntityHandlerContext; 
  readonly RewardFxdxVault_AddReward: StakedFxdxVaultContract_StakeEvent_rewardFxdxVault_AddRewardEntityHandlerContext; 
  readonly RewardFxdxVault_SendReward: StakedFxdxVaultContract_StakeEvent_rewardFxdxVault_SendRewardEntityHandlerContext; 
  readonly RewardFxdxVault_TotalReserves: StakedFxdxVaultContract_StakeEvent_rewardFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Stake: StakedFxdxVaultContract_StakeEvent_stakedFxdxVault_StakeEntityHandlerContext; 
  readonly StakedFxdxVault_TotalReserves: StakedFxdxVaultContract_StakeEvent_stakedFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Unstake: StakedFxdxVaultContract_StakeEvent_stakedFxdxVault_UnstakeEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_contractRegistrations = { readonly addRewardFxdxVault: (_1:Ethers_ethAddress) => void; readonly addStakedFxdxVault: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_StakeEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: StakedFxdxVaultContract_StakeEvent_contractRegistrations; 
  readonly EventsSummary: StakedFxdxVaultContract_StakeEvent_eventsSummaryEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_eventArgs = { readonly vault: Ethers_ethAddress; readonly reserves: Ethers_BigInt_t };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_log = eventLog<StakedFxdxVaultContract_TotalReservesEvent_eventArgs>;
export type StakedFxdxVaultContract_TotalReserves_EventLog = StakedFxdxVaultContract_TotalReservesEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_AddRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_AddRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_SendRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_SendRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_StakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_StakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_UnstakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_UnstakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: StakedFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityHandlerContext; 
  readonly RewardFxdxVault_AddReward: StakedFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_AddRewardEntityHandlerContext; 
  readonly RewardFxdxVault_SendReward: StakedFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_SendRewardEntityHandlerContext; 
  readonly RewardFxdxVault_TotalReserves: StakedFxdxVaultContract_TotalReservesEvent_rewardFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Stake: StakedFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_StakeEntityHandlerContext; 
  readonly StakedFxdxVault_TotalReserves: StakedFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Unstake: StakedFxdxVaultContract_TotalReservesEvent_stakedFxdxVault_UnstakeEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_contractRegistrations = { readonly addRewardFxdxVault: (_1:Ethers_ethAddress) => void; readonly addStakedFxdxVault: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_TotalReservesEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: StakedFxdxVaultContract_TotalReservesEvent_contractRegistrations; 
  readonly EventsSummary: StakedFxdxVaultContract_TotalReservesEvent_eventsSummaryEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_eventArgs = {
  readonly stakeId: Ethers_BigInt_t; 
  readonly amount: Ethers_BigInt_t; 
  readonly duration: Ethers_BigInt_t; 
  readonly rewardInterestRate: Ethers_BigInt_t; 
  readonly timestamp: Ethers_BigInt_t; 
  readonly account: Ethers_ethAddress; 
  readonly unstaked: boolean
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_log = eventLog<StakedFxdxVaultContract_UnstakeEvent_eventArgs>;
export type StakedFxdxVaultContract_Unstake_EventLog = StakedFxdxVaultContract_UnstakeEvent_log;

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_eventsSummaryEntityHandlerContext = {
  readonly get: (_1:id) => (undefined | eventsSummaryEntity); 
  readonly set: (_1:eventsSummaryEntity) => void; 
  readonly delete: (_1:id) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_rewardFxdxVault_AddRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_AddRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_rewardFxdxVault_SendRewardEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_SendRewardEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_rewardFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:rewardFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_stakedFxdxVault_StakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_StakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_stakedFxdxVault_TotalReservesEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_TotalReservesEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_stakedFxdxVault_UnstakeEntityHandlerContext = { readonly set: (_1:stakedFxdxVault_UnstakeEntity) => void; readonly delete: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_handlerContext = {
  readonly log: Logs_userLogger; 
  readonly EventsSummary: StakedFxdxVaultContract_UnstakeEvent_eventsSummaryEntityHandlerContext; 
  readonly RewardFxdxVault_AddReward: StakedFxdxVaultContract_UnstakeEvent_rewardFxdxVault_AddRewardEntityHandlerContext; 
  readonly RewardFxdxVault_SendReward: StakedFxdxVaultContract_UnstakeEvent_rewardFxdxVault_SendRewardEntityHandlerContext; 
  readonly RewardFxdxVault_TotalReserves: StakedFxdxVaultContract_UnstakeEvent_rewardFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Stake: StakedFxdxVaultContract_UnstakeEvent_stakedFxdxVault_StakeEntityHandlerContext; 
  readonly StakedFxdxVault_TotalReserves: StakedFxdxVaultContract_UnstakeEvent_stakedFxdxVault_TotalReservesEntityHandlerContext; 
  readonly StakedFxdxVault_Unstake: StakedFxdxVaultContract_UnstakeEvent_stakedFxdxVault_UnstakeEntityHandlerContext
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_eventsSummaryEntityLoaderContext = { readonly load: (_1:id) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_contractRegistrations = { readonly addRewardFxdxVault: (_1:Ethers_ethAddress) => void; readonly addStakedFxdxVault: (_1:Ethers_ethAddress) => void };

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVaultContract_UnstakeEvent_loaderContext = {
  readonly log: Logs_userLogger; 
  readonly contractRegistration: StakedFxdxVaultContract_UnstakeEvent_contractRegistrations; 
  readonly EventsSummary: StakedFxdxVaultContract_UnstakeEvent_eventsSummaryEntityLoaderContext
};

// tslint:disable-next-line:interface-over-type-literal
export type chainId = number;
