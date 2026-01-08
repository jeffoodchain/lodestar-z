const std = @import("std");
const Allocator = std.mem.Allocator;
const preset = @import("preset").preset;
%%%%%%% Changes from base to side #1
-const BeaconStateAllForks = @import("../types/beacon_state.zig").BeaconStateAllForks;
+const AnyBeaconState = @import("fork_types").AnyBeaconState;
+++++++ Contents of side #2
const BeaconState = @import("../types/beacon_state.zig").BeaconState;
const ReferenceCount = @import("../utils/reference_count.zig").ReferenceCount;

pub const EffectiveBalanceIncrements = std.ArrayList(u16);
pub const EffectiveBalanceIncrementsRc = ReferenceCount(EffectiveBalanceIncrements);

/// Allocates `EffectiveBalanceIncrements` with capacity slightly larger than `validator_count`.
///
/// This allows some slack for later usage of `effective_balance_increments` to not have to reallocate
/// for a while.
pub fn effectiveBalanceIncrementsInit(allocator: Allocator, validator_count: usize) !EffectiveBalanceIncrements {
    const capacity = 1024 * @divFloor(validator_count + 1024, 1024);
    var increments = try EffectiveBalanceIncrements.initCapacity(allocator, capacity);
    try increments.resize(validator_count);
    @memset(increments.items[0..validator_count], 0);
    return increments;
}

%%%%%%% Changes from base to side #1
-pub fn getEffectiveBalanceIncrementsWithLen(allocator: Allocator, validator_count: usize) !EffectiveBalanceIncrements {
-    const len = 1024 * @divFloor(validator_count + 1024, 1024);
-    return getEffectiveBalanceIncrementsZeroed(allocator, len);
-}
-
-pub fn getEffectiveBalanceIncrements(allocator: Allocator, state: BeaconStateAllForks) !EffectiveBalanceIncrements {
-    const validator_count = state.validators().items.len;
-    var increments = try EffectiveBalanceIncrements.initCapacity(allocator, validator_count);
-    try increments.resize(validator_count);
-
-    for (0..validator_count) |i| {
-        const validator = state.validators()[i];
-        increments.items[i] = @divFloor(validator.effective_balance, preset.EFFECTIVE_BALANCE_INCREMENT);
-    }
-}
-
+++++++ Contents of side #2
pub fn getEffectiveBalanceIncrementsWithLen(allocator: Allocator, validator_count: usize) !EffectiveBalanceIncrements {
    const len = 1024 * @divFloor(validator_count + 1024, 1024);
    return getEffectiveBalanceIncrementsZeroed(allocator, len);
}

pub fn getEffectiveBalanceIncrements(allocator: Allocator, state: BeaconState) !EffectiveBalanceIncrements {
    const validators = try (try state.validators()).getAll(allocator);
    defer allocator.free(validators);

    var increments = try EffectiveBalanceIncrements.initCapacity(allocator, validators.len);
    try increments.resize(validators.len);

    for (validators, 0..) |validator, i| {
        increments.items[i] = @divFloor(validator.effective_balance, preset.EFFECTIVE_BALANCE_INCREMENT);
    }
}

// TODO: unit tests
