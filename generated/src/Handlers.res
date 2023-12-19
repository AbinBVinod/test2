type functionRegister = Loader | Handler

let mapFunctionRegisterName = (functionRegister: functionRegister) => {
  switch functionRegister {
  | Loader => "Loader"
  | Handler => "Handler"
  }
}

// This set makes sure that the warning doesn't print for every event of a type, but rather only prints the first time.
let hasPrintedWarning = Set.make()

let getDefaultLoaderHandler: (
  ~functionRegister: functionRegister,
  ~eventName: string,
  ~event: 'a,
  ~context: 'b,
) => unit = (~functionRegister, ~eventName, ~event as _, ~context as _) => {
  let functionName = mapFunctionRegisterName(functionRegister)

  // Here we use this key to prevent flooding the users terminal with
  let repeatKey = `${eventName}-${functionName}`
  if !(hasPrintedWarning->Set.has(repeatKey)) {
    Logging.warn(
      // TODO: link to our docs.
      `Ignored ${eventName} event, as there is no ${functionName} registered. You need to implement a ${eventName}${functionName} method in your handler file. This will apply to all future ${eventName} events.`,
    )
    let _ = hasPrintedWarning->Set.add(repeatKey)
  }
}

module RewardFxdxVaultContract = {
  module AddReward = {
    %%private(
      let addRewardLoader = ref(None)
      let addRewardHandler = ref(None)
    )

    @genType
    let loader = (
      userLoader: (
        ~event: Types.eventLog<Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs>,
        ~context: Types.RewardFxdxVaultContract.AddRewardEvent.loaderContext,
      ) => unit,
    ) => {
      addRewardLoader := Some(userLoader)
    }

    @genType
    let handler = (
      userHandler: (
        ~event: Types.eventLog<Types.RewardFxdxVaultContract.AddRewardEvent.eventArgs>,
        ~context: Types.RewardFxdxVaultContract.AddRewardEvent.handlerContext,
      ) => unit,
    ) => {
      addRewardHandler := Some(userHandler)
    }

    let getLoader = () =>
      addRewardLoader.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="AddReward", ~functionRegister=Loader),
      )

    let getHandler = () =>
      addRewardHandler.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="AddReward", ~functionRegister=Handler),
      )
  }

  module SendReward = {
    %%private(
      let sendRewardLoader = ref(None)
      let sendRewardHandler = ref(None)
    )

    @genType
    let loader = (
      userLoader: (
        ~event: Types.eventLog<Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs>,
        ~context: Types.RewardFxdxVaultContract.SendRewardEvent.loaderContext,
      ) => unit,
    ) => {
      sendRewardLoader := Some(userLoader)
    }

    @genType
    let handler = (
      userHandler: (
        ~event: Types.eventLog<Types.RewardFxdxVaultContract.SendRewardEvent.eventArgs>,
        ~context: Types.RewardFxdxVaultContract.SendRewardEvent.handlerContext,
      ) => unit,
    ) => {
      sendRewardHandler := Some(userHandler)
    }

    let getLoader = () =>
      sendRewardLoader.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="SendReward", ~functionRegister=Loader),
      )

    let getHandler = () =>
      sendRewardHandler.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="SendReward", ~functionRegister=Handler),
      )
  }

  module TotalReserves = {
    %%private(
      let totalReservesLoader = ref(None)
      let totalReservesHandler = ref(None)
    )

    @genType
    let loader = (
      userLoader: (
        ~event: Types.eventLog<Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs>,
        ~context: Types.RewardFxdxVaultContract.TotalReservesEvent.loaderContext,
      ) => unit,
    ) => {
      totalReservesLoader := Some(userLoader)
    }

    @genType
    let handler = (
      userHandler: (
        ~event: Types.eventLog<Types.RewardFxdxVaultContract.TotalReservesEvent.eventArgs>,
        ~context: Types.RewardFxdxVaultContract.TotalReservesEvent.handlerContext,
      ) => unit,
    ) => {
      totalReservesHandler := Some(userHandler)
    }

    let getLoader = () =>
      totalReservesLoader.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="TotalReserves", ~functionRegister=Loader),
      )

    let getHandler = () =>
      totalReservesHandler.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="TotalReserves", ~functionRegister=Handler),
      )
  }
}

module StakedFxdxVaultContract = {
  module Stake = {
    %%private(
      let stakeLoader = ref(None)
      let stakeHandler = ref(None)
    )

    @genType
    let loader = (
      userLoader: (
        ~event: Types.eventLog<Types.StakedFxdxVaultContract.StakeEvent.eventArgs>,
        ~context: Types.StakedFxdxVaultContract.StakeEvent.loaderContext,
      ) => unit,
    ) => {
      stakeLoader := Some(userLoader)
    }

    @genType
    let handler = (
      userHandler: (
        ~event: Types.eventLog<Types.StakedFxdxVaultContract.StakeEvent.eventArgs>,
        ~context: Types.StakedFxdxVaultContract.StakeEvent.handlerContext,
      ) => unit,
    ) => {
      stakeHandler := Some(userHandler)
    }

    let getLoader = () =>
      stakeLoader.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="Stake", ~functionRegister=Loader),
      )

    let getHandler = () =>
      stakeHandler.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="Stake", ~functionRegister=Handler),
      )
  }

  module TotalReserves = {
    %%private(
      let totalReservesLoader = ref(None)
      let totalReservesHandler = ref(None)
    )

    @genType
    let loader = (
      userLoader: (
        ~event: Types.eventLog<Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs>,
        ~context: Types.StakedFxdxVaultContract.TotalReservesEvent.loaderContext,
      ) => unit,
    ) => {
      totalReservesLoader := Some(userLoader)
    }

    @genType
    let handler = (
      userHandler: (
        ~event: Types.eventLog<Types.StakedFxdxVaultContract.TotalReservesEvent.eventArgs>,
        ~context: Types.StakedFxdxVaultContract.TotalReservesEvent.handlerContext,
      ) => unit,
    ) => {
      totalReservesHandler := Some(userHandler)
    }

    let getLoader = () =>
      totalReservesLoader.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="TotalReserves", ~functionRegister=Loader),
      )

    let getHandler = () =>
      totalReservesHandler.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="TotalReserves", ~functionRegister=Handler),
      )
  }

  module Unstake = {
    %%private(
      let unstakeLoader = ref(None)
      let unstakeHandler = ref(None)
    )

    @genType
    let loader = (
      userLoader: (
        ~event: Types.eventLog<Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs>,
        ~context: Types.StakedFxdxVaultContract.UnstakeEvent.loaderContext,
      ) => unit,
    ) => {
      unstakeLoader := Some(userLoader)
    }

    @genType
    let handler = (
      userHandler: (
        ~event: Types.eventLog<Types.StakedFxdxVaultContract.UnstakeEvent.eventArgs>,
        ~context: Types.StakedFxdxVaultContract.UnstakeEvent.handlerContext,
      ) => unit,
    ) => {
      unstakeHandler := Some(userHandler)
    }

    let getLoader = () =>
      unstakeLoader.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="Unstake", ~functionRegister=Loader),
      )

    let getHandler = () =>
      unstakeHandler.contents->Belt.Option.getWithDefault(
        getDefaultLoaderHandler(~eventName="Unstake", ~functionRegister=Handler),
      )
  }
}
