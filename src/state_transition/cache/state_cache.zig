const std = @import("std");
const types = @import("consensus_types");
const Allocator = std.mem.Allocator;
const BeaconConfig = @import("config").BeaconConfig;
const TestCachedBeaconStateAllForks = @import("../test_utils/root.zig").TestCachedBeaconStateAllForks;
const EpochCacheRc = @import("./epoch_cache.zig").EpochCacheRc;
const EpochCache = @import("./epoch_cache.zig").EpochCache;
const EpochCacheImmutableData = @import("./epoch_cache.zig").EpochCacheImmutableData;
const EpochCacheOpts = @import("./epoch_cache.zig").EpochCacheOpts;
const ValidatorIndex = types.primitive.ValidatorIndex.Type;
const CloneOpts = @import("ssz").BaseTreeView.CloneOpts;
const SlashingsCache = @import("./slashings_cache.zig").SlashingsCache;
const Node = @import("persistent_merkle_tree").Node;
%%%%%%% Changes from base #1 to side #2
-const Node = @import("persistent_merkle_tree").Node;
%%%%%%% Changes from base #2 to side #3
-
-pub const ProposerRewards = struct {
-    attestations: u64 = 0,
-    sync_aggregate: u64 = 0,
-    slashing: u64 = 0,
-};
+const Node = @import("persistent_merkle_tree").Node;

pub const ProposerRewards = struct {
    attestations: u64 = 0,
    sync_aggregate: u64 = 0,
    slashing: u64 = 0,
};

pub const CachedBeaconStateAllForks = struct {
%%%%%%% Changes from base #1 to side #2
 pub const CachedBeaconState = struct {
%%%%%%% Changes from base #2 to side #3
+pub const ProposerRewards = struct {
+    attestations: u64 = 0,
+    sync_aggregate: u64 = 0,
+    slashing: u64 = 0,
+};
+
 pub const CachedBeaconState = struct {
%%%%%%%%%%% Changes from base #1 to side #2
 const Node = @import("persistent_merkle_tree").Node;
 
-pub const ProposerRewards = struct {
-    attestations: u64 = 0,
-    sync_aggregate: u64 = 0,
-    slashing: u64 = 0,
-};
-
 pub const CachedBeaconState = struct {
%%%%%%%%%%% Changes from base #2 to side #3
 
 pub const CachedBeaconState = struct {
    allocator: Allocator,
    /// only a reference to the singleton BeaconConfig
    config: *const BeaconConfig,
    /// only a reference to the shared EpochCache instance
    /// TODO: before an epoch transition, need to release() epoch_cache before using a new one
    epoch_cache_ref: *EpochCacheRc,
    slashings_cache: SlashingsCache,
    /// this takes ownership of the state, it is expected to be deinitialized by this struct
    state: *AnyBeaconState,
    /// Proposer rewards accumulated during block processing
    proposer_rewards: ProposerRewards,
%%%%%%% Changes from base #1 to side #2
-    state: *AnyBeaconState,
+    state: *BeaconState,
%%%%%%% Changes from base #2 to side #3
-    state: *BeaconState,
+    state: *AnyBeaconState,
     /// Proposer rewards accumulated during block processing
     proposer_rewards: ProposerRewards,

    cloned_count: u32 = 0,
    cloned_count_with_transfer_cache: u32 = 0,
    created_with_transfer_cache: bool = false,
%%%%%%%%%%% Changes from base #1 to side #2
     state: *AnyBeaconState,
-    /// Proposer rewards accumulated during block processing
-    proposer_rewards: ProposerRewards,
 
     // TODO: cloned_count properties, implement this once we switch to TreeView
+    // TODO: proposer_rewards, looks like this is not a great place to put in, it's a result of a block state transition instead
%%%%%%%%%%% Changes from base #2 to side #3
     state: *BeaconState,
 
-    cloned_count: u32 = 0,
-    cloned_count_with_transfer_cache: u32 = 0,
-    created_with_transfer_cache: bool = false,
-
+    // TODO: cloned_count properties, implement this once we switch to TreeView
     // TODO: proposer_rewards, looks like this is not a great place to put in, it's a result of a block state transition instead

    /// This class takes ownership of state after this function and has responsibility to deinit it
    pub fn createCachedBeaconState(allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
        const cached_state = try allocator.create(CachedBeaconState);
        errdefer allocator.destroy(cached_state);

        try cached_state.init(allocator, state, immutable_data, option);

        return cached_state;
    }

    pub fn init(self: *CachedBeaconState, allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !void {
%%%%%%% Changes from base #1 to side #2
-    pub fn createCachedBeaconState(allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
+    pub fn createCachedBeaconState(allocator: Allocator, state: *BeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
%%%%%%% Changes from base #2 to side #3
-    pub fn createCachedBeaconState(allocator: Allocator, state: *BeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
+    pub fn createCachedBeaconState(allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
         const cached_state = try allocator.create(CachedBeaconState);
         errdefer allocator.destroy(cached_state);
 
         try cached_state.init(allocator, state, immutable_data, option);
 
         return cached_state;
     }
 
-    pub fn init(self: *CachedBeaconState, allocator: Allocator, state: *BeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !void {
+    pub fn init(self: *CachedBeaconState, allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !void {
%%%%%%%%%%% Changes from base #1 to side #2
     pub fn createCachedBeaconState(allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
-        const cached_state = try allocator.create(CachedBeaconState);
-        errdefer allocator.destroy(cached_state);
-
-        try cached_state.init(allocator, state, immutable_data, option);
-
-        return cached_state;
-    }
-
-    pub fn init(self: *CachedBeaconState, allocator: Allocator, state: *AnyBeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !void {
%%%%%%%%%%% Changes from base #2 to side #3
     pub fn createCachedBeaconState(allocator: Allocator, state: *BeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !*CachedBeaconState {
         const cached_state = try allocator.create(CachedBeaconState);
         errdefer allocator.destroy(cached_state);
 
         try cached_state.init(allocator, state, immutable_data, option);
 
         return cached_state;
     }
 
     pub fn init(self: *CachedBeaconState, allocator: Allocator, state: *BeaconState, immutable_data: EpochCacheImmutableData, option: ?EpochCacheOpts) !void {
        const epoch_cache = try EpochCache.createFromState(allocator, state, immutable_data, option);
        errdefer epoch_cache.deinit();
        const epoch_cache_ref = try EpochCacheRc.init(allocator, epoch_cache);
        errdefer epoch_cache_ref.release();
        const cached_state = try allocator.create(CachedBeaconState);
        errdefer allocator.destroy(cached_state);

        cached_state.* = .{
            .allocator = allocator,
            .config = immutable_data.config,
            .epoch_cache_ref = epoch_cache_ref,
            .slashings_cache = try SlashingsCache.initEmpty(allocator),
            .state = state,
        };

        return cached_state;
    }

    // TODO: do we need another getConst()?
    pub fn getEpochCache(self: *const CachedBeaconStateAllForks) *EpochCache {
        return self.epoch_cache_ref.get();
    }

    pub fn clone(self: *CachedBeaconState, allocator: Allocator, opts: CloneOpts) !*CachedBeaconState {
        const cached_state = try allocator.create(CachedBeaconState);
        errdefer allocator.destroy(cached_state);
        const epoch_cache_ref = self.epoch_cache_ref.acquire();
        errdefer epoch_cache_ref.release();

        var slashings_cache = try self.slashings_cache.clone(allocator);
        errdefer slashings_cache.deinit();

        const state = try allocator.create(AnyBeaconState);
        errdefer allocator.destroy(state);
        state.* = try self.state.clone(opts);

        cached_state.* = .{
            .allocator = allocator,
            .config = self.config,
            .epoch_cache_ref = epoch_cache_ref,
            .slashings_cache = slashings_cache,
            .state = state,
            .proposer_rewards = self.proposer_rewards,
            .created_with_transfer_cache = opts.transfer_cache,
%%%%%%%%%%% Changes from base #1 to side #2
-            .proposer_rewards = self.proposer_rewards,
%%%%%%%%%%% Changes from base #2 to side #3
-            .created_with_transfer_cache = opts.transfer_cache,
        };
        return cached_state;
    }

    pub fn deinit(self: *CachedBeaconStateAllForks) void {
        // should not deinit config since we don't take ownership of it, it's singleton across applications
        self.epoch_cache_ref.release();
        self.allocator.destroy(self.state);
    }

    pub fn isSlashed(self: *const CachedBeaconState, index: ValidatorIndex) bool {
        return self.slashings_cache.isSlashed(index);
    }

    pub fn recordValidatorSlashing(self: *CachedBeaconState, block_slot: types.primitive.Slot.Type, index: ValidatorIndex) !void {
        try self.slashings_cache.recordValidatorSlashing(block_slot, index);
    }

    pub fn updateSlashingsCacheLatestBlockSlot(self: *CachedBeaconState) !void {
        var latest_block_header = try self.state.latestBlockHeader();
        const latest_block_slot = try latest_block_header.get("slot");
        self.slashings_cache.updateLatestBlockSlot(latest_block_slot);
    }

    // TODO: implement loadCachedBeaconState
    // this is used when we load a state from disc, given a seed state
    // need to do this once we switch to TreeView

    // TODO: implement getCachedBeaconState
    // this is used to create a CachedBeaconStateAllForks based on a tree and an exising CachedBeaconStateAllForks at fork transition
    // implement this once we switch to TreeView

    /// Gets the beacon proposer index for a given slot.
    /// For the Fulu fork, this uses `proposer_lookahead` from the state.
    /// For earlier forks, this uses `EpochCache.getBeaconProposer()`.
    pub fn getBeaconProposer(self: *const CachedBeaconStateAllForks, slot: types.primitive.Slot.Type) !ValidatorIndex {
        const preset_import = @import("preset").preset;
        const computeEpochAtSlot = @import("../utils/epoch.zig").computeEpochAtSlot;

        // For Fulu, use proposer_lookahead from state
        if (self.state.isFulu()) {
            const current_epoch = computeEpochAtSlot(self.state.slot());
            const slot_epoch = computeEpochAtSlot(slot);

            // proposer_lookahead covers current_epoch through current_epoch + MIN_SEED_LOOKAHEAD
            const lookahead_start_epoch = current_epoch;
            const lookahead_end_epoch = current_epoch + preset_import.MIN_SEED_LOOKAHEAD;

            if (slot_epoch < lookahead_start_epoch or slot_epoch > lookahead_end_epoch) {
                return error.SlotOutsideProposerLookahead;
            }

            const epoch_offset = slot_epoch - lookahead_start_epoch;
            const slot_in_epoch = slot % preset_import.SLOTS_PER_EPOCH;
            const index = epoch_offset * preset_import.SLOTS_PER_EPOCH + slot_in_epoch;

            return proposer_lookahead[index];
        }
        return self.getEpochCache().getBeaconProposer(slot);
    }
};

test "CachedBeaconStateAllForks.clone()" {
    const allocator = std.testing.allocator;
    const pool_size = 256 * 5;
    var pool = try Node.Pool.init(allocator, pool_size);
    defer pool.deinit();

    var test_state = try TestCachedBeaconState.init(allocator, &pool, 256);
    defer test_state.deinit();
    // test clone() api works fine with no memory leak
    const cloned_cached_state = try test_state.cached_state.clone(allocator);
    defer {
        cloned_cached_state.deinit();
        allocator.destroy(cloned_cached_state);
    }
}
