/* TypeScript file generated from Handlers.res by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
const Curry = require('rescript/lib/js/curry.js');

// @ts-ignore: Implicit any on import
const HandlersBS = require('./Handlers.bs');

import type {RewardFxdxVaultContract_AddRewardEvent_eventArgs as Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs} from './Types.gen';

import type {RewardFxdxVaultContract_AddRewardEvent_handlerContext as Types_RewardFxdxVaultContract_AddRewardEvent_handlerContext} from './Types.gen';

import type {RewardFxdxVaultContract_AddRewardEvent_loaderContext as Types_RewardFxdxVaultContract_AddRewardEvent_loaderContext} from './Types.gen';

import type {RewardFxdxVaultContract_SendRewardEvent_eventArgs as Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs} from './Types.gen';

import type {RewardFxdxVaultContract_SendRewardEvent_handlerContext as Types_RewardFxdxVaultContract_SendRewardEvent_handlerContext} from './Types.gen';

import type {RewardFxdxVaultContract_SendRewardEvent_loaderContext as Types_RewardFxdxVaultContract_SendRewardEvent_loaderContext} from './Types.gen';

import type {RewardFxdxVaultContract_TotalReservesEvent_eventArgs as Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs} from './Types.gen';

import type {RewardFxdxVaultContract_TotalReservesEvent_handlerContext as Types_RewardFxdxVaultContract_TotalReservesEvent_handlerContext} from './Types.gen';

import type {RewardFxdxVaultContract_TotalReservesEvent_loaderContext as Types_RewardFxdxVaultContract_TotalReservesEvent_loaderContext} from './Types.gen';

import type {StakedFxdxVaultContract_StakeEvent_eventArgs as Types_StakedFxdxVaultContract_StakeEvent_eventArgs} from './Types.gen';

import type {StakedFxdxVaultContract_StakeEvent_handlerContext as Types_StakedFxdxVaultContract_StakeEvent_handlerContext} from './Types.gen';

import type {StakedFxdxVaultContract_StakeEvent_loaderContext as Types_StakedFxdxVaultContract_StakeEvent_loaderContext} from './Types.gen';

import type {StakedFxdxVaultContract_TotalReservesEvent_eventArgs as Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs} from './Types.gen';

import type {StakedFxdxVaultContract_TotalReservesEvent_handlerContext as Types_StakedFxdxVaultContract_TotalReservesEvent_handlerContext} from './Types.gen';

import type {StakedFxdxVaultContract_TotalReservesEvent_loaderContext as Types_StakedFxdxVaultContract_TotalReservesEvent_loaderContext} from './Types.gen';

import type {StakedFxdxVaultContract_UnstakeEvent_eventArgs as Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs} from './Types.gen';

import type {StakedFxdxVaultContract_UnstakeEvent_handlerContext as Types_StakedFxdxVaultContract_UnstakeEvent_handlerContext} from './Types.gen';

import type {StakedFxdxVaultContract_UnstakeEvent_loaderContext as Types_StakedFxdxVaultContract_UnstakeEvent_loaderContext} from './Types.gen';

import type {eventLog as Types_eventLog} from './Types.gen';

export const RewardFxdxVaultContract_AddReward_loader: (userLoader:((_1:{ readonly event: Types_eventLog<Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs>; readonly context: Types_RewardFxdxVaultContract_AddRewardEvent_loaderContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.RewardFxdxVaultContract.AddReward.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary}});
      return result1
    });
  return result
};

export const RewardFxdxVaultContract_AddReward_handler: (userHandler:((_1:{ readonly event: Types_eventLog<Types_RewardFxdxVaultContract_AddRewardEvent_eventArgs>; readonly context: Types_RewardFxdxVaultContract_AddRewardEvent_handlerContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.RewardFxdxVaultContract.AddReward.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, RewardFxdxVault_AddReward:Argcontext.RewardFxdxVault_AddReward, RewardFxdxVault_SendReward:Argcontext.RewardFxdxVault_SendReward, RewardFxdxVault_TotalReserves:Argcontext.RewardFxdxVault_TotalReserves, StakedFxdxVault_Stake:Argcontext.StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves:Argcontext.StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake:Argcontext.StakedFxdxVault_Unstake}});
      return result1
    });
  return result
};

export const RewardFxdxVaultContract_SendReward_loader: (userLoader:((_1:{ readonly event: Types_eventLog<Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs>; readonly context: Types_RewardFxdxVaultContract_SendRewardEvent_loaderContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.RewardFxdxVaultContract.SendReward.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary}});
      return result1
    });
  return result
};

export const RewardFxdxVaultContract_SendReward_handler: (userHandler:((_1:{ readonly event: Types_eventLog<Types_RewardFxdxVaultContract_SendRewardEvent_eventArgs>; readonly context: Types_RewardFxdxVaultContract_SendRewardEvent_handlerContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.RewardFxdxVaultContract.SendReward.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, RewardFxdxVault_AddReward:Argcontext.RewardFxdxVault_AddReward, RewardFxdxVault_SendReward:Argcontext.RewardFxdxVault_SendReward, RewardFxdxVault_TotalReserves:Argcontext.RewardFxdxVault_TotalReserves, StakedFxdxVault_Stake:Argcontext.StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves:Argcontext.StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake:Argcontext.StakedFxdxVault_Unstake}});
      return result1
    });
  return result
};

export const RewardFxdxVaultContract_TotalReserves_loader: (userLoader:((_1:{ readonly event: Types_eventLog<Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs>; readonly context: Types_RewardFxdxVaultContract_TotalReservesEvent_loaderContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.RewardFxdxVaultContract.TotalReserves.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary}});
      return result1
    });
  return result
};

export const RewardFxdxVaultContract_TotalReserves_handler: (userHandler:((_1:{ readonly event: Types_eventLog<Types_RewardFxdxVaultContract_TotalReservesEvent_eventArgs>; readonly context: Types_RewardFxdxVaultContract_TotalReservesEvent_handlerContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.RewardFxdxVaultContract.TotalReserves.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, RewardFxdxVault_AddReward:Argcontext.RewardFxdxVault_AddReward, RewardFxdxVault_SendReward:Argcontext.RewardFxdxVault_SendReward, RewardFxdxVault_TotalReserves:Argcontext.RewardFxdxVault_TotalReserves, StakedFxdxVault_Stake:Argcontext.StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves:Argcontext.StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake:Argcontext.StakedFxdxVault_Unstake}});
      return result1
    });
  return result
};

export const StakedFxdxVaultContract_Stake_loader: (userLoader:((_1:{ readonly event: Types_eventLog<Types_StakedFxdxVaultContract_StakeEvent_eventArgs>; readonly context: Types_StakedFxdxVaultContract_StakeEvent_loaderContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.StakedFxdxVaultContract.Stake.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary}});
      return result1
    });
  return result
};

export const StakedFxdxVaultContract_Stake_handler: (userHandler:((_1:{ readonly event: Types_eventLog<Types_StakedFxdxVaultContract_StakeEvent_eventArgs>; readonly context: Types_StakedFxdxVaultContract_StakeEvent_handlerContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.StakedFxdxVaultContract.Stake.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, RewardFxdxVault_AddReward:Argcontext.RewardFxdxVault_AddReward, RewardFxdxVault_SendReward:Argcontext.RewardFxdxVault_SendReward, RewardFxdxVault_TotalReserves:Argcontext.RewardFxdxVault_TotalReserves, StakedFxdxVault_Stake:Argcontext.StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves:Argcontext.StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake:Argcontext.StakedFxdxVault_Unstake}});
      return result1
    });
  return result
};

export const StakedFxdxVaultContract_TotalReserves_loader: (userLoader:((_1:{ readonly event: Types_eventLog<Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs>; readonly context: Types_StakedFxdxVaultContract_TotalReservesEvent_loaderContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.StakedFxdxVaultContract.TotalReserves.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary}});
      return result1
    });
  return result
};

export const StakedFxdxVaultContract_TotalReserves_handler: (userHandler:((_1:{ readonly event: Types_eventLog<Types_StakedFxdxVaultContract_TotalReservesEvent_eventArgs>; readonly context: Types_StakedFxdxVaultContract_TotalReservesEvent_handlerContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.StakedFxdxVaultContract.TotalReserves.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, RewardFxdxVault_AddReward:Argcontext.RewardFxdxVault_AddReward, RewardFxdxVault_SendReward:Argcontext.RewardFxdxVault_SendReward, RewardFxdxVault_TotalReserves:Argcontext.RewardFxdxVault_TotalReserves, StakedFxdxVault_Stake:Argcontext.StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves:Argcontext.StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake:Argcontext.StakedFxdxVault_Unstake}});
      return result1
    });
  return result
};

export const StakedFxdxVaultContract_Unstake_loader: (userLoader:((_1:{ readonly event: Types_eventLog<Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs>; readonly context: Types_StakedFxdxVaultContract_UnstakeEvent_loaderContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.StakedFxdxVaultContract.Unstake.loader(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, contractRegistration:Argcontext.contractRegistration, EventsSummary:Argcontext.EventsSummary}});
      return result1
    });
  return result
};

export const StakedFxdxVaultContract_Unstake_handler: (userHandler:((_1:{ readonly event: Types_eventLog<Types_StakedFxdxVaultContract_UnstakeEvent_eventArgs>; readonly context: Types_StakedFxdxVaultContract_UnstakeEvent_handlerContext }) => void)) => void = function (Arg1: any) {
  const result = HandlersBS.StakedFxdxVaultContract.Unstake.handler(function (Argevent: any, Argcontext: any) {
      const result1 = Arg1({event:Argevent, context:{log:{debug:Argcontext.log.debug, info:Argcontext.log.info, warn:Argcontext.log.warn, error:Argcontext.log.error, errorWithExn:function (Arg11: any, Arg2: any) {
          const result2 = Curry._2(Argcontext.log.errorWithExn, Arg11, Arg2);
          return result2
        }}, EventsSummary:Argcontext.EventsSummary, RewardFxdxVault_AddReward:Argcontext.RewardFxdxVault_AddReward, RewardFxdxVault_SendReward:Argcontext.RewardFxdxVault_SendReward, RewardFxdxVault_TotalReserves:Argcontext.RewardFxdxVault_TotalReserves, StakedFxdxVault_Stake:Argcontext.StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves:Argcontext.StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake:Argcontext.StakedFxdxVault_Unstake}});
      return result1
    });
  return result
};
