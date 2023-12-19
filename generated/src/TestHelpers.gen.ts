/* TypeScript file generated from TestHelpers.res by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
const TestHelpersBS = require('./TestHelpers.bs');

import type {BigInt_t as Ethers_BigInt_t} from '../src/bindings/Ethers.gen';

import type {RewardFxdxVaultContract_AddRewardEvent_eventArgs as Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs} from './Types.gen';

import type {RewardFxdxVaultContract_SendRewardEvent_eventArgs as Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs} from './Types.gen';

import type {RewardFxdxVaultContract_TotalReservesEvent_eventArgs as Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs} from './Types.gen';

import type {StakedFxdxVaultContract_StakeEvent_eventArgs as Types_StakedFxdxVaultContract_StakeEvent_eventArgs} from './Types.gen';

import type {StakedFxdxVaultContract_TotalReservesEvent_eventArgs as Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs} from './Types.gen';

import type {StakedFxdxVaultContract_UnstakeEvent_eventArgs as Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs} from './Types.gen';

import type {ethAddress as Ethers_ethAddress} from '../src/bindings/Ethers.gen';

import type {eventLog as Types_eventLog} from './Types.gen';

import type {t as TestHelpers_MockDb_t} from './TestHelpers_MockDb.gen';

// tslint:disable-next-line:interface-over-type-literal
export type EventFunctions_eventProcessorArgs<eventArgs> = {
  readonly event: Types_eventLog<eventArgs>; 
  readonly mockDb: TestHelpers_MockDb_t; 
  readonly chainId?: number
};

// tslint:disable-next-line:interface-over-type-literal
export type EventFunctions_eventProcessor<eventArgs> = (_1:EventFunctions_eventProcessorArgs<eventArgs>) => TestHelpers_MockDb_t;

// tslint:disable-next-line:interface-over-type-literal
export type EventFunctions_mockEventData = {
  readonly blockNumber?: number; 
  readonly blockTimestamp?: number; 
  readonly blockHash?: string; 
  readonly srcAddress?: Ethers_ethAddress; 
  readonly transactionHash?: string; 
  readonly transactionIndex?: number; 
  readonly logIndex?: number
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVault_AddReward_createMockArgs = {
  readonly rewardId?: Ethers_BigInt_t; 
  readonly stakeId?: Ethers_BigInt_t; 
  readonly rewardAmount?: Ethers_BigInt_t; 
  readonly duration?: Ethers_BigInt_t; 
  readonly timestamp?: Ethers_BigInt_t; 
  readonly account?: Ethers_ethAddress; 
  readonly isClaimed?: boolean; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVault_SendReward_createMockArgs = {
  readonly rewardId?: Ethers_BigInt_t; 
  readonly stakeId?: Ethers_BigInt_t; 
  readonly rewardAmount?: Ethers_BigInt_t; 
  readonly duration?: Ethers_BigInt_t; 
  readonly timestamp?: Ethers_BigInt_t; 
  readonly account?: Ethers_ethAddress; 
  readonly isClaimed?: boolean; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type RewardFxdxVault_TotalReserves_createMockArgs = {
  readonly vault?: Ethers_ethAddress; 
  readonly rewardReserves?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVault_Stake_createMockArgs = {
  readonly stakeId?: Ethers_BigInt_t; 
  readonly amount?: Ethers_BigInt_t; 
  readonly duration?: Ethers_BigInt_t; 
  readonly rewardInterestRate?: Ethers_BigInt_t; 
  readonly timestamp?: Ethers_BigInt_t; 
  readonly account?: Ethers_ethAddress; 
  readonly unstaked?: boolean; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVault_TotalReserves_createMockArgs = {
  readonly vault?: Ethers_ethAddress; 
  readonly reserves?: Ethers_BigInt_t; 
  readonly mockEventData?: EventFunctions_mockEventData
};

// tslint:disable-next-line:interface-over-type-literal
export type StakedFxdxVault_Unstake_createMockArgs = {
  readonly stakeId?: Ethers_BigInt_t; 
  readonly amount?: Ethers_BigInt_t; 
  readonly duration?: Ethers_BigInt_t; 
  readonly rewardInterestRate?: Ethers_BigInt_t; 
  readonly timestamp?: Ethers_BigInt_t; 
  readonly account?: Ethers_ethAddress; 
  readonly unstaked?: boolean; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export const MockDb_createMockDb: () => TestHelpers_MockDb_t = TestHelpersBS.MockDb.createMockDb;

export const RewardFxdxVault_AddReward_processEvent: EventFunctions_eventProcessor<Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs> = TestHelpersBS.RewardFxdxVault.AddReward.processEvent;

export const RewardFxdxVault_AddReward_createMockEvent: (args:RewardFxdxVault_AddReward_createMockArgs) => Types_eventLog<Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs> = TestHelpersBS.RewardFxdxVault.AddReward.createMockEvent;

export const RewardFxdxVault_SendReward_processEvent: EventFunctions_eventProcessor<Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs> = TestHelpersBS.RewardFxdxVault.SendReward.processEvent;

export const RewardFxdxVault_SendReward_createMockEvent: (args:RewardFxdxVault_SendReward_createMockArgs) => Types_eventLog<Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs> = TestHelpersBS.RewardFxdxVault.SendReward.createMockEvent;

export const RewardFxdxVault_TotalReserves_processEvent: EventFunctions_eventProcessor<Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs> = TestHelpersBS.RewardFxdxVault.TotalReserves.processEvent;

export const RewardFxdxVault_TotalReserves_createMockEvent: (args:RewardFxdxVault_TotalReserves_createMockArgs) => Types_eventLog<Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs> = TestHelpersBS.RewardFxdxVault.TotalReserves.createMockEvent;

export const StakedFxdxVault_Stake_processEvent: EventFunctions_eventProcessor<Types_StakedFxdxVaultContract_StakeEvent_eventArgs> = TestHelpersBS.StakedFxdxVault.Stake.processEvent;

export const StakedFxdxVault_Stake_createMockEvent: (args:StakedFxdxVault_Stake_createMockArgs) => Types_eventLog<Types_StakedFxdxVaultContract_StakeEvent_eventArgs> = TestHelpersBS.StakedFxdxVault.Stake.createMockEvent;

export const StakedFxdxVault_TotalReserves_processEvent: EventFunctions_eventProcessor<Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs> = TestHelpersBS.StakedFxdxVault.TotalReserves.processEvent;

export const StakedFxdxVault_TotalReserves_createMockEvent: (args:StakedFxdxVault_TotalReserves_createMockArgs) => Types_eventLog<Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs> = TestHelpersBS.StakedFxdxVault.TotalReserves.createMockEvent;

export const StakedFxdxVault_Unstake_processEvent: EventFunctions_eventProcessor<Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs> = TestHelpersBS.StakedFxdxVault.Unstake.processEvent;

export const StakedFxdxVault_Unstake_createMockEvent: (args:StakedFxdxVault_Unstake_createMockArgs) => Types_eventLog<Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs> = TestHelpersBS.StakedFxdxVault.Unstake.createMockEvent;

export const RewardFxdxVault: {
  AddReward: {
    processEvent: EventFunctions_eventProcessor<Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs>; 
    createMockEvent: (args:RewardFxdxVault_AddReward_createMockArgs) => Types_eventLog<Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs>
  }; 
  TotalReserves: {
    processEvent: EventFunctions_eventProcessor<Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs>; 
    createMockEvent: (args:RewardFxdxVault_TotalReserves_createMockArgs) => Types_eventLog<Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs>
  }; 
  SendReward: {
    processEvent: EventFunctions_eventProcessor<Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs>; 
    createMockEvent: (args:RewardFxdxVault_SendReward_createMockArgs) => Types_eventLog<Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs>
  }
} = TestHelpersBS.RewardFxdxVault

export const MockDb: { createMockDb: () => TestHelpers_MockDb_t } = TestHelpersBS.MockDb

export const StakedFxdxVault: {
  Stake: {
    processEvent: EventFunctions_eventProcessor<Types_StakedFxdxVaultContract_StakeEvent_eventArgs>; 
    createMockEvent: (args:StakedFxdxVault_Stake_createMockArgs) => Types_eventLog<Types_StakedFxdxVaultContract_StakeEvent_eventArgs>
  }; 
  TotalReserves: {
    processEvent: EventFunctions_eventProcessor<Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs>; 
    createMockEvent: (args:StakedFxdxVault_TotalReserves_createMockArgs) => Types_eventLog<Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs>
  }; 
  Unstake: {
    processEvent: EventFunctions_eventProcessor<Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs>; 
    createMockEvent: (args:StakedFxdxVault_Unstake_createMockArgs) => Types_eventLog<Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs>
  }
} = TestHelpersBS.StakedFxdxVault
