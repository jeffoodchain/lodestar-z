const std = @import("std");
const Allocator = std.mem.Allocator;
const ForkSeq = @import("config").ForkSeq;
const CachedBeaconState = @import("../cache/state_cache.zig").CachedBeaconState;
const EffectiveBalanceIncrements = @import("../cache/effective_balance_increments.zig").EffectiveBalanceIncrements;
const BeaconState = @import("fork_types").BeaconState;
const ValidatorIndex = @import("consensus_types").primitive.ValidatorIndex.Type;

/// Increase the balance for a validator with the given ``index`` by ``delta``.
pub fn increaseBalance(comptime fork: ForkSeq, state: *BeaconState(fork), index: ValidatorIndex, delta: u64) !void {
    var balances = try state.balances();
    const current = try balances.get(index);
    const next = try std.math.add(u64, current, delta);
    try balances.set(index, next);
}

/// Decrease the balance for a validator with the given ``index`` by ``delta``.
/// Set to 0 when underflow.
pub fn decreaseBalance(comptime fork: ForkSeq, state: *BeaconState(fork), index: ValidatorIndex, delta: u64) !void {
    var balances = try state.balances();
    const current = try balances.get(index);
    const next = if (current > delta) current - delta else 0;
    try balances.set(index, next);
}
