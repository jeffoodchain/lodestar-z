const std = @import("std");
const Allocator = std.mem.Allocator;
const BeaconConfig = @import("config").BeaconConfig;
const EpochCache = @import("../cache/epoch_cache.zig").EpochCache;
const BeaconState = @import("fork_types").BeaconState;
const ct = @import("consensus_types");

pub fn upgradeStateToDeneb(
    allocator: Allocator,
    config: *const BeaconConfig,
    epoch_cache: *const EpochCache,
    capella_state: *BeaconState(.capella),
) !BeaconState(.deneb) {
    var state = try capella_state.upgradeUnsafe();
    errdefer state.deinit();

    const new_fork: ct.phase0.Fork.Type = .{
        .previous_version = try capella_state.forkCurrentVersion(),
        .current_version = config.chain.DENEB_FORK_VERSION,
        .epoch = epoch_cache.epoch,
%%%%%%% Changes from base #1 to side #2
 const CachedBeaconState = @import("../cache/state_cache.zig").CachedBeaconState;
 const ssz = @import("consensus_types");
-const toExecutionPayloadHeader = @import("../types/execution_payload.zig").toExecutionPayloadHeader;
 const ExecutionPayloadHeader = @import("../types/execution_payload.zig").ExecutionPayloadHeader;
 
 pub fn upgradeStateToDeneb(allocator: Allocator, cached_state: *CachedBeaconState) !void {
     var capella_state = cached_state.state;
     if (capella_state.forkSeq() != .capella) {
         return error.StateIsNotCapella;
     }
 
     var state = try capella_state.upgradeUnsafe();
     errdefer state.deinit();
 
     const new_fork: ssz.phase0.Fork.Type = .{
         .previous_version = try capella_state.forkCurrentVersion(),
         .current_version = cached_state.config.chain.DENEB_FORK_VERSION,
         .epoch = cached_state.getEpochCache().epoch,
%%%%%%% Changes from base #2 to side #3
 const CachedBeaconStateAllForks = @import("../cache/state_cache.zig").CachedBeaconStateAllForks;
 const ssz = @import("consensus_types");
 
 pub fn upgradeStateToDeneb(allocator: Allocator, cached_state: *CachedBeaconStateAllForks) !void {
     var state = cached_state.state;
     if (!state.isCapella()) {
         return error.StateIsNotCapella;
     }
 
     const capella_state = state.capella;
     defer {
         ssz.capella.BeaconState.deinit(allocator, capella_state);
         allocator.destroy(capella_state);
     }
     _ = try state.upgradeUnsafe(allocator);
     state.forkPtr().* = .{
         .previous_version = capella_state.fork.current_version,
         .current_version = cached_state.config.chain.DENEB_FORK_VERSION,
         .epoch = cached_state.getEpochCache().epoch,
    };
    try state.setFork(&new_fork);

    // ownership is transferred to BeaconState
    var new_latest_execution_payload_header = ct.deneb.ExecutionPayloadHeader.default_value;
    var capella_latest_execution_payload_header = ct.capella.ExecutionPayloadHeader.default_value;
    try capella_state.latestExecutionPayloadHeader(allocator, &capella_latest_execution_payload_header);
    defer ct.capella.ExecutionPayloadHeader.deinit(allocator, &capella_latest_execution_payload_header);

    try ct.capella.ExecutionPayloadHeader.clone(
        allocator,
        &capella_latest_execution_payload_header,
        &new_latest_execution_payload_header,
    );

    // new in deneb
    new_latest_execution_payload_header.excess_blob_gas = 0;
    new_latest_execution_payload_header.blob_gas_used = 0;

    try state.setLatestExecutionPayloadHeader(&new_latest_execution_payload_header);

    capella_state.deinit();
    return state;
%%%%%%% Changes from base #1 to side #2
-    // add excessBlobGas and blobGasUsed to latestExecutionPayloadHeader
     // ownership is transferred to BeaconState
     var new_latest_execution_payload_header: ExecutionPayloadHeader = .{ .deneb = ssz.deneb.ExecutionPayloadHeader.default_value };
     var capella_latest_execution_payload_header = try capella_state.latestExecutionPayloadHeader(allocator);
     defer capella_latest_execution_payload_header.deinit(allocator);
     if (capella_latest_execution_payload_header != .capella) {
         return error.UnexpectedLatestExecutionPayloadHeaderType;
     }
 
-    try toExecutionPayloadHeader(
+    try ssz.capella.ExecutionPayloadHeader.clone(
         allocator,
-        ssz.deneb.ExecutionPayloadHeader.Type,
         &capella_latest_execution_payload_header.capella,
         &new_latest_execution_payload_header.deneb,
     );
 
     // new in deneb
     new_latest_execution_payload_header.deneb.excess_blob_gas = 0;
     new_latest_execution_payload_header.deneb.blob_gas_used = 0;
 
     try state.setLatestExecutionPayloadHeader(&new_latest_execution_payload_header);
 
     capella_state.deinit();
     cached_state.state.* = state;
%%%%%%% Changes from base #2 to side #3
+    // add excessBlobGas and blobGasUsed to latestExecutionPayloadHeader
     // ownership is transferred to BeaconState
     var deneb_latest_execution_payload_header = ssz.deneb.ExecutionPayloadHeader.default_value;
     const capella_latest_execution_payload_header = capella_state.latest_execution_payload_header;
-    try ssz.capella.ExecutionPayloadHeader.clone(allocator, &capella_latest_execution_payload_header, &deneb_latest_execution_payload_header);
-    // add excessBlobGas and blobGasUsed to latestExecutionPayloadHeader
+
+    deneb_latest_execution_payload_header.parent_hash = capella_latest_execution_payload_header.parent_hash;
+    deneb_latest_execution_payload_header.fee_recipient = capella_latest_execution_payload_header.fee_recipient;
+    deneb_latest_execution_payload_header.state_root = capella_latest_execution_payload_header.state_root;
+    deneb_latest_execution_payload_header.receipts_root = capella_latest_execution_payload_header.receipts_root;
+    deneb_latest_execution_payload_header.logs_bloom = capella_latest_execution_payload_header.logs_bloom;
+    deneb_latest_execution_payload_header.prev_randao = capella_latest_execution_payload_header.prev_randao;
+    deneb_latest_execution_payload_header.block_number = capella_latest_execution_payload_header.block_number;
+    deneb_latest_execution_payload_header.gas_limit = capella_latest_execution_payload_header.gas_limit;
+    deneb_latest_execution_payload_header.gas_used = capella_latest_execution_payload_header.gas_used;
+    deneb_latest_execution_payload_header.timestamp = capella_latest_execution_payload_header.timestamp;
+    // Clone extra_data because capella_state will be deinit after upgrade,
+    // and deneb state needs its own copy of the dynamically allocated data
+    deneb_latest_execution_payload_header.extra_data = try capella_latest_execution_payload_header.extra_data.clone(allocator);
+    deneb_latest_execution_payload_header.base_fee_per_gas = capella_latest_execution_payload_header.base_fee_per_gas;
+    deneb_latest_execution_payload_header.block_hash = capella_latest_execution_payload_header.block_hash;
+    deneb_latest_execution_payload_header.transactions_root = capella_latest_execution_payload_header.transactions_root;
+    deneb_latest_execution_payload_header.withdrawals_root = capella_latest_execution_payload_header.withdrawals_root;
     deneb_latest_execution_payload_header.excess_blob_gas = 0;
     deneb_latest_execution_payload_header.blob_gas_used = 0;
 
     state.setLatestExecutionPayloadHeader(allocator, .{
         .deneb = &deneb_latest_execution_payload_header,
     });
}
