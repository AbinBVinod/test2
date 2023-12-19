let sql = Postgres.makeSql(~config=Config.db->Obj.magic /* TODO: make this have the correct type */)

module EventSyncState = {
  let createEventSyncStateTable: unit => promise<unit> = async () => {
    let _ = await %raw("sql`
      CREATE TABLE IF NOT EXISTS public.event_sync_state (
        chain_id INTEGER NOT NULL,
        block_number INTEGER NOT NULL,
        log_index INTEGER NOT NULL,
        transaction_index INTEGER NOT NULL,
        block_timestamp INTEGER NOT NULL,
        PRIMARY KEY (chain_id)
      );
      `")
  }

  let dropEventSyncStateTable = async () => {
    let _ = await %raw("sql`
      DROP TABLE IF EXISTS public.event_sync_state;
    `")
  }
}

module ChainMetadata = {
  let createChainMetadataTable: unit => promise<unit> = async () => {
    let _ = await %raw("sql`
      CREATE TABLE IF NOT EXISTS public.chain_metadata (
        chain_id INTEGER NOT NULL,
        start_block INTEGER NOT NULL,
        block_height INTEGER NOT NULL,
        PRIMARY KEY (chain_id)
      );
      `")
  }

  let dropChainMetadataTable = async () => {
    let _ = await %raw("sql`
      DROP TABLE IF EXISTS public.chain_metadata;
    `")
  }
}

module PersistedState = {
  let createPersistedStateTable: unit => promise<unit> = async () => {
    let _ = await %raw("sql`
      CREATE TABLE IF NOT EXISTS public.persisted_state (
        id SERIAL PRIMARY KEY,
        envio_version TEXT NOT NULL, 
        config_hash TEXT NOT NULL,
        schema_hash TEXT NOT NULL,
        handler_files_hash TEXT NOT NULL,
        abi_files_hash TEXT NOT NULL
      );
      `")
  }

  let dropPersistedStateTable = async () => {
    let _ = await %raw("sql`
      DROP TABLE IF EXISTS public.persisted_state;
    `")
  }
}

module RawEventsTable = {
  let createEventTypeEnum: unit => promise<unit> = async () => {
    @warning("-21")
    let _ = await %raw("sql`
      DO $$ BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'event_type') THEN
          CREATE TYPE EVENT_TYPE AS ENUM(
          'RewardFxdxVault_AddReward',
          'RewardFxdxVault_SendReward',
          'RewardFxdxVault_TotalReserves',
          'StakedFxdxVault_Stake',
          'StakedFxdxVault_TotalReserves',
          'StakedFxdxVault_Unstake'
          );
        END IF;
      END $$;
      `")
  }

  let createRawEventsTable: unit => promise<unit> = async () => {
    let _ = await createEventTypeEnum()

    @warning("-21")
    let _ = await %raw("sql`
      CREATE TABLE IF NOT EXISTS public.raw_events (
        chain_id INTEGER NOT NULL,
        event_id NUMERIC NOT NULL,
        block_number INTEGER NOT NULL,
        log_index INTEGER NOT NULL,
        transaction_index INTEGER NOT NULL,
        transaction_hash TEXT NOT NULL,
        src_address TEXT NOT NULL,
        block_hash TEXT NOT NULL,
        block_timestamp INTEGER NOT NULL,
        event_type EVENT_TYPE NOT NULL,
        params JSON NOT NULL,
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (chain_id, event_id)
      );
      `")
  }

  @@warning("-21")
  let dropRawEventsTable = async () => {
    let _ = await %raw("sql`
      DROP TABLE IF EXISTS public.raw_events;
    `")
    let _ = await %raw("sql`
      DROP TYPE IF EXISTS EVENT_TYPE CASCADE;
    `")
  }
  @@warning("+21")
}

module DynamicContractRegistryTable = {
  let createDynamicContractRegistryTable: unit => promise<unit> = async () => {
    @warning("-21")
    let _ = await %raw("sql`
      DO $$ BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'contract_type') THEN
          CREATE TYPE CONTRACT_TYPE AS ENUM (
          'RewardFxdxVault',
          'StakedFxdxVault'
          );
        END IF;
      END $$;
      `")

    @warning("-21")
    let _ = await %raw("sql`
      CREATE TABLE IF NOT EXISTS public.dynamic_contract_registry (
        chain_id INTEGER NOT NULL,
        event_id NUMERIC NOT NULL,
        contract_address TEXT NOT NULL,
        contract_type CONTRACT_TYPE NOT NULL,
        PRIMARY KEY (chain_id, contract_address)
      );
      `")
  }

  @@warning("-21")
  let dropDynamicContractRegistryTable = async () => {
    let _ = await %raw("sql`
      DROP TABLE IF EXISTS public.dynamic_contract_registry;
    `")
    let _ = await %raw("sql`
      DROP TYPE IF EXISTS EVENT_TYPE CASCADE;
    `")
  }
  @@warning("+21")
}

module EventsSummary = {
  let createEventsSummaryTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"EventsSummary\" (\"id\" text NOT NULL,\"rewardFxdxVault_AddRewardCount\" numeric NOT NULL,\"rewardFxdxVault_SendRewardCount\" numeric NOT NULL,\"rewardFxdxVault_TotalReservesCount\" numeric NOT NULL,\"stakedFxdxVault_StakeCount\" numeric NOT NULL,\"stakedFxdxVault_TotalReservesCount\" numeric NOT NULL,\"stakedFxdxVault_UnstakeCount\" numeric NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteEventsSummaryTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"EventsSummary\";`")
  }
}

module RewardFxdxVault_AddReward = {
  let createRewardFxdxVault_AddRewardTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"RewardFxdxVault_AddReward\" (\"id\" text NOT NULL,\"rewardId\" numeric NOT NULL,\"stakeId\" numeric NOT NULL,\"rewardAmount\" numeric NOT NULL,\"duration\" numeric NOT NULL,\"timestamp\" numeric NOT NULL,\"account\" text NOT NULL,\"isClaimed\" boolean NOT NULL,\"eventsSummary\" text NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteRewardFxdxVault_AddRewardTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"RewardFxdxVault_AddReward\";`")
  }
}

module RewardFxdxVault_SendReward = {
  let createRewardFxdxVault_SendRewardTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"RewardFxdxVault_SendReward\" (\"id\" text NOT NULL,\"rewardId\" numeric NOT NULL,\"stakeId\" numeric NOT NULL,\"rewardAmount\" numeric NOT NULL,\"duration\" numeric NOT NULL,\"timestamp\" numeric NOT NULL,\"account\" text NOT NULL,\"isClaimed\" boolean NOT NULL,\"eventsSummary\" text NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteRewardFxdxVault_SendRewardTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"RewardFxdxVault_SendReward\";`")
  }
}

module RewardFxdxVault_TotalReserves = {
  let createRewardFxdxVault_TotalReservesTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"RewardFxdxVault_TotalReserves\" (\"id\" text NOT NULL,\"vault\" text NOT NULL,\"rewardReserves\" numeric NOT NULL,\"eventsSummary\" text NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteRewardFxdxVault_TotalReservesTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"RewardFxdxVault_TotalReserves\";`")
  }
}

module StakedFxdxVault_Stake = {
  let createStakedFxdxVault_StakeTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"StakedFxdxVault_Stake\" (\"id\" text NOT NULL,\"stakeId\" numeric NOT NULL,\"amount\" numeric NOT NULL,\"duration\" numeric NOT NULL,\"rewardInterestRate\" numeric NOT NULL,\"timestamp\" numeric NOT NULL,\"account\" text NOT NULL,\"unstaked\" boolean NOT NULL,\"eventsSummary\" text NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteStakedFxdxVault_StakeTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"StakedFxdxVault_Stake\";`")
  }
}

module StakedFxdxVault_TotalReserves = {
  let createStakedFxdxVault_TotalReservesTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"StakedFxdxVault_TotalReserves\" (\"id\" text NOT NULL,\"vault\" text NOT NULL,\"reserves\" numeric NOT NULL,\"eventsSummary\" text NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteStakedFxdxVault_TotalReservesTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"StakedFxdxVault_TotalReserves\";`")
  }
}

module StakedFxdxVault_Unstake = {
  let createStakedFxdxVault_UnstakeTable: unit => promise<unit> = async () => {
    await %raw("sql`
      CREATE TABLE \"public\".\"StakedFxdxVault_Unstake\" (\"id\" text NOT NULL,\"stakeId\" numeric NOT NULL,\"amount\" numeric NOT NULL,\"duration\" numeric NOT NULL,\"rewardInterestRate\" numeric NOT NULL,\"timestamp\" numeric NOT NULL,\"account\" text NOT NULL,\"unstaked\" boolean NOT NULL,\"eventsSummary\" text NOT NULL, 
        db_write_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
        PRIMARY KEY (\"id\"));`")
  }

  let deleteStakedFxdxVault_UnstakeTable: unit => promise<unit> = async () => {
    // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).
    await %raw("sql`DROP TABLE IF EXISTS \"public\".\"StakedFxdxVault_Unstake\";`")
  }
}

let deleteAllTables: unit => promise<unit> = async () => {
  Logging.trace("Dropping all tables")
  // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).

  @warning("-21")
  await (
    %raw(
      "sql.unsafe`DROP SCHEMA public CASCADE;CREATE SCHEMA public;GRANT ALL ON SCHEMA public TO postgres;GRANT ALL ON SCHEMA public TO public;`"
    )
  )
}

let deleteAllTablesExceptRawEventsAndDynamicContractRegistry: unit => promise<unit> = async () => {
  // NOTE: we can refine the `IF EXISTS` part because this now prints to the terminal if the table doesn't exist (which isn't nice for the developer).

  @warning("-21")
  await (
    %raw("sql.unsafe`
    DO $$ 
    DECLARE
        table_name_var text;
    BEGIN
        FOR table_name_var IN (SELECT table_name
                           FROM information_schema.tables
                           WHERE table_schema = 'public'
                           AND table_name != 'raw_events'
                           AND table_name != 'dynamic_contract_registry') 
        LOOP
            EXECUTE 'DROP TABLE IF EXISTS ' || table_name_var || ' CASCADE';
        END LOOP;
    END $$;
  `")
  )
}

type t
@module external process: t = "process"

type exitCode = Success | Failure
@send external exit: (t, exitCode) => unit = "exit"

// TODO: all the migration steps should run as a single transaction
let runUpMigrations = async (~shouldExit) => {
  let exitCode = ref(Success)
  await PersistedState.createPersistedStateTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE800: Error creating persisted_state table`)->Promise.resolve
  })

  await EventSyncState.createEventSyncStateTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE800: Error creating event_sync_state table`)->Promise.resolve
  })
  await ChainMetadata.createChainMetadataTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE800: Error creating chain_metadata table`)->Promise.resolve
  })
  await RawEventsTable.createRawEventsTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE800: Error creating raw_events table`)->Promise.resolve
  })
  await DynamicContractRegistryTable.createDynamicContractRegistryTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE801: Error creating dynamic_contracts table`)->Promise.resolve
  })
  // TODO: catch and handle query errors
  await EventsSummary.createEventsSummaryTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE802: Error creating EventsSummary table`)->Promise.resolve
  })
  await RewardFxdxVault_AddReward.createRewardFxdxVault_AddRewardTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(
      err,
      `EE802: Error creating RewardFxdxVault_AddReward table`,
    )->Promise.resolve
  })
  await RewardFxdxVault_SendReward.createRewardFxdxVault_SendRewardTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(
      err,
      `EE802: Error creating RewardFxdxVault_SendReward table`,
    )->Promise.resolve
  })
  await RewardFxdxVault_TotalReserves.createRewardFxdxVault_TotalReservesTable()->Promise.catch(
    err => {
      exitCode := Failure
      Logging.errorWithExn(
        err,
        `EE802: Error creating RewardFxdxVault_TotalReserves table`,
      )->Promise.resolve
    },
  )
  await StakedFxdxVault_Stake.createStakedFxdxVault_StakeTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(err, `EE802: Error creating StakedFxdxVault_Stake table`)->Promise.resolve
  })
  await StakedFxdxVault_TotalReserves.createStakedFxdxVault_TotalReservesTable()->Promise.catch(
    err => {
      exitCode := Failure
      Logging.errorWithExn(
        err,
        `EE802: Error creating StakedFxdxVault_TotalReserves table`,
      )->Promise.resolve
    },
  )
  await StakedFxdxVault_Unstake.createStakedFxdxVault_UnstakeTable()->Promise.catch(err => {
    exitCode := Failure
    Logging.errorWithExn(
      err,
      `EE802: Error creating StakedFxdxVault_Unstake table`,
    )->Promise.resolve
  })
  await TrackTables.trackAllTables()->Promise.catch(err => {
    Logging.errorWithExn(err, `EE803: Error tracking tables`)->Promise.resolve
  })
  if shouldExit {
    process->exit(exitCode.contents)
  }
  exitCode.contents
}

let runDownMigrations = async (~shouldExit, ~shouldDropRawEvents) => {
  let exitCode = ref(Success)

  //
  // await EventsSummary.deleteEventsSummaryTable()
  //
  // await RewardFxdxVault_AddReward.deleteRewardFxdxVault_AddRewardTable()
  //
  // await RewardFxdxVault_SendReward.deleteRewardFxdxVault_SendRewardTable()
  //
  // await RewardFxdxVault_TotalReserves.deleteRewardFxdxVault_TotalReservesTable()
  //
  // await StakedFxdxVault_Stake.deleteStakedFxdxVault_StakeTable()
  //
  // await StakedFxdxVault_TotalReserves.deleteStakedFxdxVault_TotalReservesTable()
  //
  // await StakedFxdxVault_Unstake.deleteStakedFxdxVault_UnstakeTable()
  //

  // NOTE: For now delete any remaining tables.
  if shouldDropRawEvents {
    await deleteAllTables()->Promise.catch(err => {
      exitCode := Failure
      Logging.errorWithExn(err, "EE804: Error dropping entity tables")->Promise.resolve
    })
  } else {
    await deleteAllTablesExceptRawEventsAndDynamicContractRegistry()->Promise.catch(err => {
      exitCode := Failure
      Logging.errorWithExn(
        err,
        "EE805: Error dropping entity tables except for raw events",
      )->Promise.resolve
    })
  }
  if shouldExit {
    process->exit(exitCode.contents)
  }
  exitCode.contents
}

let setupDb = async (~shouldDropRawEvents) => {
  Logging.info("Provisioning Database")
  // TODO: we should make a hash of the schema file (that gets stored in the DB) and either drop the tables and create new ones or keep this migration.
  //       for now we always run the down migration.
  // if (process.env.MIGRATE === "force" || hash_of_schema_file !== hash_of_current_schema)
  let exitCodeDown = await runDownMigrations(~shouldExit=false, ~shouldDropRawEvents)
  // else
  //   await clearDb()

  let exitCodeUp = await runUpMigrations(~shouldExit=false)

  let exitCode = switch (exitCodeDown, exitCodeUp) {
  | (Success, Success) => Success
  | _ => Failure
  }

  process->exit(exitCode)
}
