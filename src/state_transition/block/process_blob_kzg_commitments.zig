const BlockExternalData = @import("../state_transition.zig").BlockExternalData;
%%%%%%% Changes from base to side #1
-const CachedBeaconStateAllForks = @import("../cache/state_cache.zig").CachedBeaconStateAllForks;
+++++++ Contents of side #2
const CachedBeaconState = @import("../cache/state_cache.zig").CachedBeaconState;

pub fn processBlobKzgCommitments(external_data: BlockExternalData) !void {
    switch (external_data.execution_payload_status) {
        .pre_merge => return error.ExecutionPayloadStatusPreMerge,
        .invalid => return error.InvalidExecutionPayload,
        // ok
        else => {},
    }
}

test "process blob kzg commitments - sanity" {
    try processBlobKzgCommitments(.{
        .execution_payload_status = .valid,
        .data_availability_status = .available,
    });
}
