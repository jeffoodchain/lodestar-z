%%%%%%% Changes from base to side #1
-const std = @import("std");
-const Allocator = std.mem.Allocator;
-const CachedBeaconStateAllForks = @import("../cache/state_cache.zig").CachedBeaconStateAllForks;
+++++++ Contents of side #2
const std = @import("std");
const Allocator = std.mem.Allocator;
const CachedBeaconState = @import("../cache/state_cache.zig").CachedBeaconState;
const ForkSeq = @import("config").ForkSeq;
const BeaconState = @import("fork_types").BeaconState;

pub fn processParticipationRecordUpdates(
    comptime fork: ForkSeq,
    state: *BeaconState(fork),
) !void {
    if (comptime fork != .phase0) return;
    // rotate current/previous epoch attestations
    try state.rotateEpochPendingAttestations();
}
