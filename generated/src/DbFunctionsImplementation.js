// db operations for raw_events:
const MAX_ITEMS_PER_QUERY = 500;

module.exports.readLatestSyncedEventOnChainId = (sql, chainId) => sql`
  SELECT *
  FROM public.event_sync_state
  WHERE chain_id = ${chainId}`;

module.exports.batchSetEventSyncState = (sql, entityDataArray) => {
  return sql`
    INSERT INTO public.event_sync_state
  ${sql(
    entityDataArray,
    "chain_id",
    "block_number",
    "log_index",
    "transaction_index",
    "block_timestamp"
  )}
    ON CONFLICT(chain_id) DO UPDATE
    SET
    "chain_id" = EXCLUDED."chain_id",
    "block_number" = EXCLUDED."block_number",
    "log_index" = EXCLUDED."log_index",
    "transaction_index" = EXCLUDED."transaction_index",
    "block_timestamp" = EXCLUDED."block_timestamp";
    `;
};

module.exports.setChainMetadata = (sql, entityDataArray) => {
  return (sql`
    INSERT INTO public.chain_metadata
  ${sql(
    entityDataArray,
    "chain_id",
    "start_block", // this is left out of the on conflict below as it only needs to be set once
    "block_height"
  )}
  ON CONFLICT(chain_id) DO UPDATE
  SET
  "chain_id" = EXCLUDED."chain_id",
  "block_height" = EXCLUDED."block_height";`).then(res => {
    
  }).catch(err => {
    console.log("errored", err)
  });
};

module.exports.readLatestRawEventsBlockNumberProcessedOnChainId = (
  sql,
  chainId
) => sql`
  SELECT block_number
  FROM "public"."raw_events"
  WHERE chain_id = ${chainId}
  ORDER BY event_id DESC
  LIMIT 1;`;

module.exports.readRawEventsEntities = (sql, entityIdArray) => sql`
  SELECT *
  FROM "public"."raw_events"
  WHERE (chain_id, event_id) IN ${sql(entityIdArray)}`;

module.exports.getRawEventsPageGtOrEqEventId = (
  sql,
  chainId,
  eventId,
  limit,
  contractAddresses
) => sql`
  SELECT *
  FROM "public"."raw_events"
  WHERE "chain_id" = ${chainId}
  AND "event_id" >= ${eventId}
  AND "src_address" IN ${sql(contractAddresses)}
  ORDER BY "event_id" ASC
  LIMIT ${limit}
`;

module.exports.getRawEventsPageWithinEventIdRangeInclusive = (
  sql,
  chainId,
  fromEventIdInclusive,
  toEventIdInclusive,
  limit,
  contractAddresses
) => sql`
  SELECT *
  FROM public.raw_events
  WHERE "chain_id" = ${chainId}
  AND "event_id" >= ${fromEventIdInclusive}
  AND "event_id" <= ${toEventIdInclusive}
  AND "src_address" IN ${sql(contractAddresses)}
  ORDER BY "event_id" ASC
  LIMIT ${limit}
`;

const batchSetRawEventsCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."raw_events"
  ${sql(
    entityDataArray,
    "chain_id",
    "event_id",
    "block_number",
    "log_index",
    "transaction_index",
    "transaction_hash",
    "src_address",
    "block_hash",
    "block_timestamp",
    "event_type",
    "params"
  )}
    ON CONFLICT(chain_id, event_id) DO UPDATE
    SET
    "chain_id" = EXCLUDED."chain_id",
    "event_id" = EXCLUDED."event_id",
    "block_number" = EXCLUDED."block_number",
    "log_index" = EXCLUDED."log_index",
    "transaction_index" = EXCLUDED."transaction_index",
    "transaction_hash" = EXCLUDED."transaction_hash",
    "src_address" = EXCLUDED."src_address",
    "block_hash" = EXCLUDED."block_hash",
    "block_timestamp" = EXCLUDED."block_timestamp",
    "event_type" = EXCLUDED."event_type",
    "params" = EXCLUDED."params";`;
};

const chunkBatchQuery = (
  sql,
  entityDataArray,
  queryToExecute
) => {
  const promises = [];

  // Split entityDataArray into chunks of MAX_ITEMS_PER_QUERY
  for (let i = 0; i < entityDataArray.length; i += MAX_ITEMS_PER_QUERY) {
    const chunk = entityDataArray.slice(i, i + MAX_ITEMS_PER_QUERY);

    promises.push(queryToExecute(sql, chunk));
  }

  // Execute all promises
  return Promise.all(promises).catch(e => {
    console.error("Sql query failed", e);
    throw e;
    });
};

module.exports.batchSetRawEvents = (sql, entityDataArray) => {
  return chunkBatchQuery(
    sql,
    entityDataArray,
    batchSetRawEventsCore
  );
};

module.exports.batchDeleteRawEvents = (sql, entityIdArray) => sql`
  DELETE
  FROM "public"."raw_events"
  WHERE (chain_id, event_id) IN ${sql(entityIdArray)};`;
// end db operations for raw_events

module.exports.readDynamicContractsOnChainIdAtOrBeforeBlock = (
  sql,
  chainId,
  block_number
) => sql`
  SELECT c.contract_address, c.contract_type, c.event_id
  FROM "public"."dynamic_contract_registry" as c
  JOIN raw_events e ON c.chain_id = e.chain_id
  AND c.event_id = e.event_id
  WHERE e.block_number <= ${block_number} AND e.chain_id = ${chainId};`;

//Start db operations dynamic_contract_registry
module.exports.readDynamicContractRegistryEntities = (
  sql,
  entityIdArray
) => sql`
  SELECT *
  FROM "public"."dynamic_contract_registry"
  WHERE (chain_id, contract_address) IN ${sql(entityIdArray)}`;

const batchSetDynamicContractRegistryCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."dynamic_contract_registry"
  ${sql(
    entityDataArray,
    "chain_id",
    "event_id",
    "contract_address",
    "contract_type"
  )}
    ON CONFLICT(chain_id, contract_address) DO UPDATE
    SET
    "chain_id" = EXCLUDED."chain_id",
    "event_id" = EXCLUDED."event_id",
    "contract_address" = EXCLUDED."contract_address",
    "contract_type" = EXCLUDED."contract_type";`;
};

module.exports.batchSetDynamicContractRegistry = (sql, entityDataArray) => {
  return chunkBatchQuery(
    sql,
    entityDataArray,
    batchSetDynamicContractRegistryCore
  );
};

module.exports.batchDeleteDynamicContractRegistry = (sql, entityIdArray) => sql`
  DELETE
  FROM "public"."dynamic_contract_registry"
  WHERE (chain_id, contract_address) IN ${sql(entityIdArray)};`;
// end db operations for dynamic_contract_registry

//////////////////////////////////////////////
// DB operations for EventsSummary:
//////////////////////////////////////////////

module.exports.readEventsSummaryEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"rewardFxdxVault_AddRewardCount",
"rewardFxdxVault_SendRewardCount",
"rewardFxdxVault_TotalReservesCount",
"stakedFxdxVault_StakeCount",
"stakedFxdxVault_TotalReservesCount",
"stakedFxdxVault_UnstakeCount"
FROM "public"."EventsSummary"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetEventsSummaryCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."EventsSummary"
${sql(entityDataArray,
    "id",
    "rewardFxdxVault_AddRewardCount",
    "rewardFxdxVault_SendRewardCount",
    "rewardFxdxVault_TotalReservesCount",
    "stakedFxdxVault_StakeCount",
    "stakedFxdxVault_TotalReservesCount",
    "stakedFxdxVault_UnstakeCount"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "rewardFxdxVault_AddRewardCount" = EXCLUDED."rewardFxdxVault_AddRewardCount",
  "rewardFxdxVault_SendRewardCount" = EXCLUDED."rewardFxdxVault_SendRewardCount",
  "rewardFxdxVault_TotalReservesCount" = EXCLUDED."rewardFxdxVault_TotalReservesCount",
  "stakedFxdxVault_StakeCount" = EXCLUDED."stakedFxdxVault_StakeCount",
  "stakedFxdxVault_TotalReservesCount" = EXCLUDED."stakedFxdxVault_TotalReservesCount",
  "stakedFxdxVault_UnstakeCount" = EXCLUDED."stakedFxdxVault_UnstakeCount"
  `;
}

module.exports.batchSetEventsSummary = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetEventsSummaryCore
  );
}

module.exports.batchDeleteEventsSummary = (sql, entityIdArray) => sql`
DELETE
FROM "public"."EventsSummary"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for EventsSummary

//////////////////////////////////////////////
// DB operations for RewardFxdxVault_AddReward:
//////////////////////////////////////////////

module.exports.readRewardFxdxVault_AddRewardEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"rewardId",
"stakeId",
"rewardAmount",
"duration",
"timestamp",
"account",
"isClaimed",
"eventsSummary"
FROM "public"."RewardFxdxVault_AddReward"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetRewardFxdxVault_AddRewardCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."RewardFxdxVault_AddReward"
${sql(entityDataArray,
    "id",
    "rewardId",
    "stakeId",
    "rewardAmount",
    "duration",
    "timestamp",
    "account",
    "isClaimed",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "rewardId" = EXCLUDED."rewardId",
  "stakeId" = EXCLUDED."stakeId",
  "rewardAmount" = EXCLUDED."rewardAmount",
  "duration" = EXCLUDED."duration",
  "timestamp" = EXCLUDED."timestamp",
  "account" = EXCLUDED."account",
  "isClaimed" = EXCLUDED."isClaimed",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetRewardFxdxVault_AddReward = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetRewardFxdxVault_AddRewardCore
  );
}

module.exports.batchDeleteRewardFxdxVault_AddReward = (sql, entityIdArray) => sql`
DELETE
FROM "public"."RewardFxdxVault_AddReward"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for RewardFxdxVault_AddReward

//////////////////////////////////////////////
// DB operations for RewardFxdxVault_SendReward:
//////////////////////////////////////////////

module.exports.readRewardFxdxVault_SendRewardEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"rewardId",
"stakeId",
"rewardAmount",
"duration",
"timestamp",
"account",
"isClaimed",
"eventsSummary"
FROM "public"."RewardFxdxVault_SendReward"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetRewardFxdxVault_SendRewardCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."RewardFxdxVault_SendReward"
${sql(entityDataArray,
    "id",
    "rewardId",
    "stakeId",
    "rewardAmount",
    "duration",
    "timestamp",
    "account",
    "isClaimed",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "rewardId" = EXCLUDED."rewardId",
  "stakeId" = EXCLUDED."stakeId",
  "rewardAmount" = EXCLUDED."rewardAmount",
  "duration" = EXCLUDED."duration",
  "timestamp" = EXCLUDED."timestamp",
  "account" = EXCLUDED."account",
  "isClaimed" = EXCLUDED."isClaimed",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetRewardFxdxVault_SendReward = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetRewardFxdxVault_SendRewardCore
  );
}

module.exports.batchDeleteRewardFxdxVault_SendReward = (sql, entityIdArray) => sql`
DELETE
FROM "public"."RewardFxdxVault_SendReward"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for RewardFxdxVault_SendReward

//////////////////////////////////////////////
// DB operations for RewardFxdxVault_TotalReserves:
//////////////////////////////////////////////

module.exports.readRewardFxdxVault_TotalReservesEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"vault",
"rewardReserves",
"eventsSummary"
FROM "public"."RewardFxdxVault_TotalReserves"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetRewardFxdxVault_TotalReservesCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."RewardFxdxVault_TotalReserves"
${sql(entityDataArray,
    "id",
    "vault",
    "rewardReserves",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "vault" = EXCLUDED."vault",
  "rewardReserves" = EXCLUDED."rewardReserves",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetRewardFxdxVault_TotalReserves = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetRewardFxdxVault_TotalReservesCore
  );
}

module.exports.batchDeleteRewardFxdxVault_TotalReserves = (sql, entityIdArray) => sql`
DELETE
FROM "public"."RewardFxdxVault_TotalReserves"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for RewardFxdxVault_TotalReserves

//////////////////////////////////////////////
// DB operations for StakedFxdxVault_Stake:
//////////////////////////////////////////////

module.exports.readStakedFxdxVault_StakeEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"stakeId",
"amount",
"duration",
"rewardInterestRate",
"timestamp",
"account",
"unstaked",
"eventsSummary"
FROM "public"."StakedFxdxVault_Stake"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetStakedFxdxVault_StakeCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."StakedFxdxVault_Stake"
${sql(entityDataArray,
    "id",
    "stakeId",
    "amount",
    "duration",
    "rewardInterestRate",
    "timestamp",
    "account",
    "unstaked",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "stakeId" = EXCLUDED."stakeId",
  "amount" = EXCLUDED."amount",
  "duration" = EXCLUDED."duration",
  "rewardInterestRate" = EXCLUDED."rewardInterestRate",
  "timestamp" = EXCLUDED."timestamp",
  "account" = EXCLUDED."account",
  "unstaked" = EXCLUDED."unstaked",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetStakedFxdxVault_Stake = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetStakedFxdxVault_StakeCore
  );
}

module.exports.batchDeleteStakedFxdxVault_Stake = (sql, entityIdArray) => sql`
DELETE
FROM "public"."StakedFxdxVault_Stake"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for StakedFxdxVault_Stake

//////////////////////////////////////////////
// DB operations for StakedFxdxVault_TotalReserves:
//////////////////////////////////////////////

module.exports.readStakedFxdxVault_TotalReservesEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"vault",
"reserves",
"eventsSummary"
FROM "public"."StakedFxdxVault_TotalReserves"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetStakedFxdxVault_TotalReservesCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."StakedFxdxVault_TotalReserves"
${sql(entityDataArray,
    "id",
    "vault",
    "reserves",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "vault" = EXCLUDED."vault",
  "reserves" = EXCLUDED."reserves",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetStakedFxdxVault_TotalReserves = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetStakedFxdxVault_TotalReservesCore
  );
}

module.exports.batchDeleteStakedFxdxVault_TotalReserves = (sql, entityIdArray) => sql`
DELETE
FROM "public"."StakedFxdxVault_TotalReserves"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for StakedFxdxVault_TotalReserves

//////////////////////////////////////////////
// DB operations for StakedFxdxVault_Unstake:
//////////////////////////////////////////////

module.exports.readStakedFxdxVault_UnstakeEntities = (sql, entityIdArray) => sql`
SELECT 
"id",
"stakeId",
"amount",
"duration",
"rewardInterestRate",
"timestamp",
"account",
"unstaked",
"eventsSummary"
FROM "public"."StakedFxdxVault_Unstake"
WHERE id IN ${sql(entityIdArray)};`;

const batchSetStakedFxdxVault_UnstakeCore = (sql, entityDataArray) => {
  return sql`
    INSERT INTO "public"."StakedFxdxVault_Unstake"
${sql(entityDataArray,
    "id",
    "stakeId",
    "amount",
    "duration",
    "rewardInterestRate",
    "timestamp",
    "account",
    "unstaked",
    "eventsSummary"
  )}
  ON CONFLICT(id) DO UPDATE
  SET
  "id" = EXCLUDED."id",
  "stakeId" = EXCLUDED."stakeId",
  "amount" = EXCLUDED."amount",
  "duration" = EXCLUDED."duration",
  "rewardInterestRate" = EXCLUDED."rewardInterestRate",
  "timestamp" = EXCLUDED."timestamp",
  "account" = EXCLUDED."account",
  "unstaked" = EXCLUDED."unstaked",
  "eventsSummary" = EXCLUDED."eventsSummary"
  `;
}

module.exports.batchSetStakedFxdxVault_Unstake = (sql, entityDataArray) => {

  return chunkBatchQuery(
    sql, 
    entityDataArray, 
    batchSetStakedFxdxVault_UnstakeCore
  );
}

module.exports.batchDeleteStakedFxdxVault_Unstake = (sql, entityIdArray) => sql`
DELETE
FROM "public"."StakedFxdxVault_Unstake"
WHERE id IN ${sql(entityIdArray)};`
// end db operations for StakedFxdxVault_Unstake

