let registerRewardFxdxVaultHandlers = () => {
  try {
    let _ = %raw(`require("../../src/EventHandlers.js")`)
  } catch {
  | err => {
      Logging.error(
        "EE500: There was an issue importing the handler file for RewardFxdxVault. Expected file at ../../src/EventHandlers.js",
      )
      Js.log(err)
    }
  }
}
let registerStakedFxdxVaultHandlers = () => {
  try {
    let _ = %raw(`require("../../src/EventHandlers.js")`)
  } catch {
  | err => {
      Logging.error(
        "EE500: There was an issue importing the handler file for StakedFxdxVault. Expected file at ../../src/EventHandlers.js",
      )
      Js.log(err)
    }
  }
}

let registerAllHandlers = () => {
  registerRewardFxdxVaultHandlers()
  registerStakedFxdxVaultHandlers()
}
