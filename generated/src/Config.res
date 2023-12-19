type contract = {
  name: string,
  abi: Ethers.abi,
  addresses: array<Ethers.ethAddress>,
  events: array<Types.eventName>,
}

type syncConfig = {
  initialBlockInterval: int,
  backoffMultiplicative: float,
  accelerationAdditive: int,
  intervalCeiling: int,
  backoffMillis: int,
  queryTimeoutMillis: int,
}

type serverUrl = string

type rpcConfig = {
  provider: Ethers.JsonRpcProvider.t,
  syncConfig: syncConfig,
}

type syncSource = Rpc(rpcConfig) | Skar(serverUrl) | EthArchive(serverUrl)

type chainConfig = {
  syncSource: syncSource,
  startBlock: int,
  chainId: int,
  contracts: array<contract>,
}

type chainConfigs = Js.Dict.t<chainConfig>

// Logging:
%%private(let envSafe = EnvSafe.make())

let getLogLevelConfig = (~name, ~default): Pino.logLevel =>
  envSafe->EnvSafe.get(
    ~name,
    ~struct=S.union([
      S.literalVariant(String("trace"), #trace),
      S.literalVariant(String("debug"), #debug),
      S.literalVariant(String("info"), #info),
      S.literalVariant(String("warn"), #warn),
      S.literalVariant(String("error"), #error),
      S.literalVariant(String("fatal"), #fatal),
      S.literalVariant(String("udebug"), #udebug),
      S.literalVariant(String("uinfo"), #uinfo),
      S.literalVariant(String("uwarn"), #uwarn),
      S.literalVariant(String("uerror"), #uerror),
      S.literalVariant(String(""), default),
      S.literalVariant(EmptyOption, default),
    ]),
    (),
  )

let isUnorderedHeadMode =
  envSafe->EnvSafe.get(
    ~name="UNSTABLE__TEMP_UNORDERED_HEAD_MODE",
    ~struct=S.bool(),
    ~devFallback=false,
    (),
  )

let logFilePath =
  envSafe->EnvSafe.get(~name="LOG_FILE", ~struct=S.string(), ~devFallback="logs/envio.log", ())
let userLogLevel = getLogLevelConfig(~name="LOG_LEVEL", ~default=#info)
let defaultFileLogLevel = getLogLevelConfig(~name="FILE_LOG_LEVEL", ~default=#trace)

type logStrategyType = EcsFile | EcsConsole | FileOnly | ConsoleRaw | ConsolePretty | Both
let logStrategy = envSafe->EnvSafe.get(
  ~name="LOG_STRATEGY",
  ~struct=S.union([
    S.literalVariant(String("ecs-file"), EcsFile),
    S.literalVariant(String("ecs-console"), EcsConsole),
    S.literalVariant(String("file-only"), FileOnly),
    S.literalVariant(String("console-raw"), ConsoleRaw),
    S.literalVariant(String("console-pretty"), ConsolePretty),
    S.literalVariant(String("both-prettyconsole"), Both),
    // Two default values are pretty print to the console only.
    S.literalVariant(String(""), ConsolePretty),
    S.literalVariant(EmptyOption, ConsolePretty),
  ]),
  (),
)

let db: Postgres.poolConfig = {
  host: envSafe->EnvSafe.get(
    ~name="ENVIO_PG_HOST",
    ~struct=S.string(),
    ~devFallback="localhost",
    (),
  ),
  port: envSafe->EnvSafe.get(
    ~name="ENVIO_PG_PORT",
    ~struct=S.int()->S.Int.port(),
    ~devFallback=5433,
    (),
  ),
  user: envSafe->EnvSafe.get(
    ~name="ENVIO_PG_USER",
    ~struct=S.string(),
    ~devFallback="postgres",
    (),
  ),
  password: envSafe->EnvSafe.get(
    ~name="ENVIO_POSTGRES_PASSWORD",
    ~struct=S.string(),
    ~devFallback="testing",
    (),
  ),
  database: envSafe->EnvSafe.get(
    ~name="ENVIO_PG_DATABASE",
    ~struct=S.string(),
    ~devFallback="envio-dev",
    (),
  ),
  ssl: envSafe->EnvSafe.get(
    ~name="ENVIO_PG_SSL_MODE",
    ~struct=S.string(),
    //this is a dev fallback option for local deployments, shouldn't run in the prod env
    //the SSL modes should be provided as string otherwise as 'require' | 'allow' | 'prefer' | 'verify-full'
    ~devFallback=false->Obj.magic,
    (),
  ),
  // TODO: think how we want to pipe these logs to pino.
  onnotice: userLogLevel == #warn || userLogLevel == #error ? None : Some(() => ()),
}

let config: chainConfigs = [
  (
    "8453",
    {
      syncSource: Skar("https://base.hypersync.xyz"),
      startBlock: 7578558,
      chainId: 8453,
      contracts: [
        {
          name: "StakedFxdxVault",
          abi: Abis.stakedFxdxVaultAbi->Ethers.makeAbi,
          addresses: [
            "0x7221B51F28C150e4D90aEAb2393B0Ea04B7F710F"->Ethers.getAddressFromStringUnsafe,
          ],
          events: [StakedFxdxVault_Stake, StakedFxdxVault_TotalReserves, StakedFxdxVault_Unstake],
        },
        {
          name: "RewardFxdxVault",
          abi: Abis.rewardFxdxVaultAbi->Ethers.makeAbi,
          addresses: [
            "0xb9451677AAD516ce435b55d8989743881B5A0444"->Ethers.getAddressFromStringUnsafe,
          ],
          events: [
            RewardFxdxVault_AddReward,
            RewardFxdxVault_SendReward,
            RewardFxdxVault_TotalReserves,
          ],
        },
      ],
    },
  ),
]->Js.Dict.fromArray

let metricsPort =
  envSafe->EnvSafe.get(~name="METRICS_PORT", ~struct=S.int()->S.Int.port(), ~devFallback=9898, ())

// You need to close the envSafe after you're done with it so that it immediately tells you about your  misconfigured environment on startup.
envSafe->EnvSafe.close()
