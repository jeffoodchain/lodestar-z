const std = @import("std");
const Allocator = std.mem.Allocator;
%%%%%%% Changes from base to side #1
-const CachedBeaconStateAllForks = @import("../cache/state_cache.zig").CachedBeaconStateAllForks;
-const ssz = @import("consensus_types");
+const BeaconConfig = @import("config").BeaconConfig;
+const EpochCache = @import("../cache/epoch_cache.zig").EpochCache;
+const BeaconState = @import("fork_types").BeaconState;
+const ct = @import("consensus_types");
+++++++ Contents of side #2
const CachedBeaconState = @import("../cache/state_cache.zig").CachedBeaconState;
const ct = @import("consensus_types");
const toExecutionPayloadHeader = @import("../types/execution_payload.zig").toExecutionPayloadHeader;
const ExecutionPayloadHeader = @import("../types/execution_payload.zig").ExecutionPayloadHeader;

pub fn upgradeStateToCapella(
    allocator: Allocator,
    config: *const BeaconConfig,
    epoch_cache: *const EpochCache,
    bellatrix_state: *BeaconState(.bellatrix),
) !BeaconState(.capella) {
    // Get underlying node and cast bellatrix tree to capella tree
    //
    // An bellatrix BeaconState tree can be safely casted to a capella BeaconState tree because:
    // - Deprecated fields are replaced by new fields at the exact same indexes
    // - All new fields are appended at the end
    //
    // bellatrix                        | op    | capella
    // -------------------------------- | ----  | ------------
    // genesis_time                     | -     | genesis_time
    // genesis_validators_root          | -     | genesis_validators_root
    // slot                             | -     | slot
    // fork                             | -     | fork
    // latest_block_header              | -     | latest_block_header
    // block_roots                      | -     | block_roots
    // state_roots                      | -     | state_roots
    // historical_roots                 | frozen| historical_roots
    // eth1_data                        | -     | eth1_data
    // eth1_data_votes                  | -     | eth1_data_votes
    // eth1_deposit_index               | -     | eth1_deposit_index
    // validators                       | -     | validators
    // balances                         | -     | balances
    // randao_mixes                     | -     | randao_mixes
    // slashings                        | -     | slashings
    // previous_epoch_participation     | -     | previous_epoch_participation
    // current_epoch_participation      | -     | current_epoch_participation
    // justification_bits               | -     | justification_bits
    // previous_justified_checkpoint    | -     | previous_justified_checkpoint
    // current_justified_checkpoint     | -     | current_justified_checkpoint
    // finalized_checkpoint             | -     | finalized_checkpoint
    // inactivity_scores                | -     | inactivity_scores
    // current_sync_committee           | -     | current_sync_committee
    // next_sync_committee              | -     | next_sync_committee
    // latest_execution_payload_header  | diff  | latest_execution_payload_header
    // -                                | new   | next_withdrawal_index
    // -                                | new   | next_withdrawal_validator_index
    // -                                | new   | historical_summaries

    var state = try bellatrix_state.upgradeUnsafe();
    errdefer state.deinit();

    const new_fork: ct.phase0.Fork.Type = .{
        .previous_version = try bellatrix_state.forkCurrentVersion(),
        .current_version = config.chain.CAPELLA_FORK_VERSION,
        .epoch = epoch_cache.epoch,
    };
    try state.setFork(&new_fork);

    defer bellatrix_latest_execution_payload_header.deinit(allocator);
    if (bellatrix_latest_execution_payload_header != .bellatrix) {
        return error.UnexpectedLatestExecutionPayloadHeaderType;
    }

        allocator,
        ct.capella.ExecutionPayloadHeader.Type,
        &bellatrix_latest_execution_payload_header.bellatrix,
        &new_latest_execution_payload_header.capella,
    );
    // new in capella
    new_latest_execution_payload_header.withdrawals_root = [_]u8{0} ** 32;

    try state.setLatestExecutionPayloadHeader(&new_latest_execution_payload_header);

    bellatrix_state.deinit();
    return state;
}
