/*
 *Please refer to https://docs.envio.dev for a thorough guide on all Envio indexer features*
 */

  let { RewardFxdxVaultContract } = require("../generated/src/Handlers.bs.js");
  let { StakedFxdxVaultContract } = require("../generated/src/Handlers.bs.js");

const GLOBAL_EVENTS_SUMMARY_KEY = "GlobalEventsSummary";

const INITIAL_EVENTS_SUMMARY = {
  id: GLOBAL_EVENTS_SUMMARY_KEY,
    rewardFxdxVault_AddRewardCount: BigInt(0),
    rewardFxdxVault_SendRewardCount: BigInt(0),
    rewardFxdxVault_TotalReservesCount: BigInt(0),
    stakedFxdxVault_StakeCount: BigInt(0),
    stakedFxdxVault_TotalReservesCount: BigInt(0),
    stakedFxdxVault_UnstakeCount: BigInt(0),
};

    RewardFxdxVaultContract.AddReward.loader((event, context) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    RewardFxdxVaultContract.AddReward.handler((event, context) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity = summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    rewardFxdxVault_AddRewardCount: currentSummaryEntity.rewardFxdxVault_AddRewardCount + BigInt(1),
  };

  const rewardFxdxVault_AddRewardEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      rewardId: event.params.rewardId      ,
      stakeId: event.params.stakeId      ,
      rewardAmount: event.params.rewardAmount      ,
      duration: event.params.duration      ,
      timestamp: event.params.timestamp      ,
      account: event.params.account      ,
      isClaimed: event.params.isClaimed      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.RewardFxdxVault_AddReward.set(rewardFxdxVault_AddRewardEntity);
});
    RewardFxdxVaultContract.SendReward.loader((event, context) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    RewardFxdxVaultContract.SendReward.handler((event, context) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity = summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    rewardFxdxVault_SendRewardCount: currentSummaryEntity.rewardFxdxVault_SendRewardCount + BigInt(1),
  };

  const rewardFxdxVault_SendRewardEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      rewardId: event.params.rewardId      ,
      stakeId: event.params.stakeId      ,
      rewardAmount: event.params.rewardAmount      ,
      duration: event.params.duration      ,
      timestamp: event.params.timestamp      ,
      account: event.params.account      ,
      isClaimed: event.params.isClaimed      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.RewardFxdxVault_SendReward.set(rewardFxdxVault_SendRewardEntity);
});
    RewardFxdxVaultContract.TotalReserves.loader((event, context) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    RewardFxdxVaultContract.TotalReserves.handler((event, context) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity = summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    rewardFxdxVault_TotalReservesCount: currentSummaryEntity.rewardFxdxVault_TotalReservesCount + BigInt(1),
  };

  const rewardFxdxVault_TotalReservesEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      vault: event.params.vault      ,
      rewardReserves: event.params.rewardReserves      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.RewardFxdxVault_TotalReserves.set(rewardFxdxVault_TotalReservesEntity);
});
    StakedFxdxVaultContract.Stake.loader((event, context) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    StakedFxdxVaultContract.Stake.handler((event, context) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity = summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    stakedFxdxVault_StakeCount: currentSummaryEntity.stakedFxdxVault_StakeCount + BigInt(1),
  };

  const stakedFxdxVault_StakeEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      stakeId: event.params.stakeId      ,
      amount: event.params.amount      ,
      duration: event.params.duration      ,
      rewardInterestRate: event.params.rewardInterestRate      ,
      timestamp: event.params.timestamp      ,
      account: event.params.account      ,
      unstaked: event.params.unstaked      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.StakedFxdxVault_Stake.set(stakedFxdxVault_StakeEntity);
});
    StakedFxdxVaultContract.TotalReserves.loader((event, context) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    StakedFxdxVaultContract.TotalReserves.handler((event, context) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity = summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    stakedFxdxVault_TotalReservesCount: currentSummaryEntity.stakedFxdxVault_TotalReservesCount + BigInt(1),
  };

  const stakedFxdxVault_TotalReservesEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      vault: event.params.vault      ,
      reserves: event.params.reserves      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.StakedFxdxVault_TotalReserves.set(stakedFxdxVault_TotalReservesEntity);
});
    StakedFxdxVaultContract.Unstake.loader((event, context) => {
  context.EventsSummary.load(GLOBAL_EVENTS_SUMMARY_KEY);
});

    StakedFxdxVaultContract.Unstake.handler((event, context) => {
  const summary = context.EventsSummary.get(GLOBAL_EVENTS_SUMMARY_KEY);

  const currentSummaryEntity = summary ?? INITIAL_EVENTS_SUMMARY;

  const nextSummaryEntity = {
    ...currentSummaryEntity,
    stakedFxdxVault_UnstakeCount: currentSummaryEntity.stakedFxdxVault_UnstakeCount + BigInt(1),
  };

  const stakedFxdxVault_UnstakeEntity = {
    id: event.transactionHash + event.logIndex.toString(),
      stakeId: event.params.stakeId      ,
      amount: event.params.amount      ,
      duration: event.params.duration      ,
      rewardInterestRate: event.params.rewardInterestRate      ,
      timestamp: event.params.timestamp      ,
      account: event.params.account      ,
      unstaked: event.params.unstaked      ,
    eventsSummary: GLOBAL_EVENTS_SUMMARY_KEY,
  };

  context.EventsSummary.set(nextSummaryEntity);
  context.StakedFxdxVault_Unstake.set(stakedFxdxVault_UnstakeEntity);
});
