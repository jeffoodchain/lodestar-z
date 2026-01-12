%%%%%%% Changes from base to side #1
-const std = @import("std");
-const panic = std.debug.panic;
-const Allocator = std.mem.Allocator;
-const expect = std.testing.expect;
-const types = @import("consensus_types");
-const preset = @import("preset").preset;
-const BeaconStatePhase0 = types.phase0.BeaconState.Type;
-const BeaconStateAltair = types.altair.BeaconState.Type;
-const BeaconStateBellatrix = types.bellatrix.BeaconState.Type;
-const BeaconStateCapella = types.capella.BeaconState.Type;
-const BeaconStateDeneb = types.deneb.BeaconState.Type;
-const BeaconStateElectra = types.electra.BeaconState.Type;
-const BeaconStateFulu = types.fulu.BeaconState.Type;
-const ExecutionPayloadHeader = @import("./execution_payload.zig").ExecutionPayloadHeader;
-const Root = types.primitive.Root.Type;
-const Fork = types.phase0.Fork.Type;
-const BeaconBlockHeader = types.phase0.BeaconBlockHeader.Type;
-const Eth1Data = types.phase0.Eth1Data.Type;
-const Eth1DataVotes = types.phase0.Eth1DataVotes.Type;
-const Validator = types.phase0.Validator.Type;
-const Validators = types.phase0.Validators.Type;
-const PendingAttestation = types.phase0.PendingAttestation.Type;
-const JustificationBits = types.phase0.JustificationBits.Type;
-const Checkpoint = types.phase0.Checkpoint.Type;
-const SyncCommittee = types.altair.SyncCommittee.Type;
-const HistoricalSummary = types.capella.HistoricalSummary.Type;
-const PendingDeposit = types.electra.PendingDeposit.Type;
-const PendingPartialWithdrawal = types.electra.PendingPartialWithdrawal.Type;
-const PendingConsolidation = types.electra.PendingConsolidation.Type;
-const Bytes32 = types.primitive.Bytes32.Type;
-const Gwei = types.primitive.Gwei.Type;
-const Epoch = types.primitive.Epoch.Type;
-const ValidatorIndex = types.primitive.ValidatorIndex.Type;
-const ForkSeq = @import("config").ForkSeq;
-const isFixedType = @import("ssz").isFixedType;
-
-/// wrapper for all BeaconState types across forks so that we don't have to do switch/case for all methods
-/// right now this works with regular types
-/// TODO: migrate this to TreeView and implement the same set of methods here because TreeView objects does not have a great Devex APIs
-pub const BeaconStateAllForks = union(enum) {
-    phase0: *BeaconStatePhase0,
-    altair: *BeaconStateAltair,
-    bellatrix: *BeaconStateBellatrix,
-    capella: *BeaconStateCapella,
-    deneb: *BeaconStateDeneb,
-    electra: *BeaconStateElectra,
-    fulu: *BeaconStateFulu,
-
-    pub fn init(f: ForkSeq, state_any: anytype) !@This() {
-        var state: @This() = undefined;
-
-        switch (f) {
-            .phase0 => {
-                const T = types.phase0.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .phase0 = src };
-            },
-            .altair => {
-                const T = types.altair.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .altair = src };
-            },
-            .bellatrix => {
-                const T = types.bellatrix.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .bellatrix = src };
-            },
-            .capella => {
-                const T = types.capella.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .capella = src };
-            },
-            .deneb => {
-                const T = types.deneb.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .deneb = src };
-            },
-            .electra => {
-                const T = types.electra.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .electra = src };
-            },
-            .fulu => {
-                const T = types.fulu.BeaconState;
-                const src: *T.Type = @ptrCast(@alignCast(state_any));
-                state = .{ .fulu = src };
-            },
-        }
-
-        return state;
-    }
-
-    pub fn deserialize(allocator: Allocator, fork_seq: ForkSeq, bytes: []const u8) !BeaconStateAllForks {
-        switch (fork_seq) {
-            .phase0 => {
-                const state = try allocator.create(BeaconStatePhase0);
-                errdefer allocator.destroy(state);
-                state.* = types.phase0.BeaconState.default_value;
-                try types.phase0.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .phase0 = state };
-            },
-            .altair => {
-                const state = try allocator.create(BeaconStateAltair);
-                errdefer allocator.destroy(state);
-                state.* = types.altair.BeaconState.default_value;
-                try types.altair.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .altair = state };
-            },
-            .bellatrix => {
-                const state = try allocator.create(BeaconStateBellatrix);
-                errdefer allocator.destroy(state);
-                state.* = types.bellatrix.BeaconState.default_value;
-                try types.bellatrix.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .bellatrix = state };
-            },
-            .capella => {
-                const state = try allocator.create(BeaconStateCapella);
-                errdefer allocator.destroy(state);
-                state.* = types.capella.BeaconState.default_value;
-                try types.capella.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .capella = state };
-            },
-            .deneb => {
-                const state = try allocator.create(BeaconStateDeneb);
-                errdefer allocator.destroy(state);
-                state.* = types.deneb.BeaconState.default_value;
-                try types.deneb.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .deneb = state };
-            },
-            .electra => {
-                const state = try allocator.create(BeaconStateElectra);
-                errdefer allocator.destroy(state);
-                state.* = types.electra.BeaconState.default_value;
-                try types.electra.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .electra = state };
-            },
-            .fulu => {
-                const state = try allocator.create(BeaconStateFulu);
-                errdefer allocator.destroy(state);
-                state.* = types.fulu.BeaconState.default_value;
-                try types.fulu.BeaconState.deserializeFromBytes(allocator, bytes, state);
-                return .{ .fulu = state };
-            },
-        }
-    }
-
-    pub fn serialize(self: BeaconStateAllForks, allocator: Allocator) ![]u8 {
-        switch (self) {
-            .phase0 => |state| {
-                const out = try allocator.alloc(u8, types.phase0.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.phase0.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-            .altair => |state| {
-                const out = try allocator.alloc(u8, types.altair.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.altair.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-            .bellatrix => |state| {
-                const out = try allocator.alloc(u8, types.bellatrix.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.bellatrix.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-            .capella => |state| {
-                const out = try allocator.alloc(u8, types.capella.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.capella.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-            .deneb => |state| {
-                const out = try allocator.alloc(u8, types.deneb.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.deneb.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-            .electra => |state| {
-                const out = try allocator.alloc(u8, types.electra.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.electra.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-            .fulu => |state| {
-                const out = try allocator.alloc(u8, types.fulu.BeaconState.serializedSize(state));
-                errdefer allocator.free(out);
-                _ = types.fulu.BeaconState.serializeIntoBytes(state, out);
-                return out;
-            },
-        }
-    }
-
-    pub fn format(
-        self: BeaconStateAllForks,
-        comptime fmt: []const u8,
-        options: std.fmt.FormatOptions,
-        writer: anytype,
-    ) !void {
-        _ = fmt;
-        _ = options;
-        return switch (self) {
-            inline else => {
-                try writer.print("{s} (at slot {})", .{ @tagName(self), self.slot() });
-            },
-        };
-    }
-
-    pub fn clone(self: *const BeaconStateAllForks, allocator: std.mem.Allocator) !*BeaconStateAllForks {
-        const out = try allocator.create(BeaconStateAllForks);
-        errdefer allocator.destroy(out);
-        switch (self.*) {
-            .phase0 => |state| {
-                const cloned_state = try allocator.create(BeaconStatePhase0);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .phase0 = cloned_state };
-                try types.phase0.BeaconState.clone(allocator, state, cloned_state);
-            },
-            .altair => |state| {
-                const cloned_state = try allocator.create(BeaconStateAltair);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .altair = cloned_state };
-                try types.altair.BeaconState.clone(allocator, state, cloned_state);
-            },
-            .bellatrix => |state| {
-                const cloned_state = try allocator.create(BeaconStateBellatrix);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .bellatrix = cloned_state };
-                try types.bellatrix.BeaconState.clone(allocator, state, cloned_state);
-            },
-            .capella => |state| {
-                const cloned_state = try allocator.create(BeaconStateCapella);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .capella = cloned_state };
-                try types.capella.BeaconState.clone(allocator, state, cloned_state);
-            },
-            .deneb => |state| {
-                const cloned_state = try allocator.create(BeaconStateDeneb);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .deneb = cloned_state };
-                try types.deneb.BeaconState.clone(allocator, state, cloned_state);
-            },
-            .electra => |state| {
-                const cloned_state = try allocator.create(BeaconStateElectra);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .electra = cloned_state };
-                try types.electra.BeaconState.clone(allocator, state, cloned_state);
-            },
-            .fulu => |state| {
-                const cloned_state = try allocator.create(BeaconStateFulu);
-                errdefer allocator.destroy(cloned_state);
-                out.* = .{ .fulu = cloned_state };
-                try types.fulu.BeaconState.clone(allocator, state, cloned_state);
-            },
-        }
-
-        return out;
-    }
-
-    pub fn hashTreeRoot(self: *const BeaconStateAllForks, allocator: std.mem.Allocator, out: *[32]u8) !void {
-        return switch (self.*) {
-            .phase0 => |state| try types.phase0.BeaconState.hashTreeRoot(allocator, state, out),
-            .altair => |state| try types.altair.BeaconState.hashTreeRoot(allocator, state, out),
-            .bellatrix => |state| try types.bellatrix.BeaconState.hashTreeRoot(allocator, state, out),
-            .capella => |state| try types.capella.BeaconState.hashTreeRoot(allocator, state, out),
-            .deneb => |state| try types.deneb.BeaconState.hashTreeRoot(allocator, state, out),
-            .electra => |state| try types.electra.BeaconState.hashTreeRoot(allocator, state, out),
-            .fulu => |state| try types.fulu.BeaconState.hashTreeRoot(allocator, state, out),
-        };
-    }
-
-    pub fn deinit(self: *BeaconStateAllForks, allocator: Allocator) void {
-        switch (self.*) {
-            .phase0 => |state| {
-                types.phase0.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-            .altair => |state| {
-                types.altair.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-            .capella => |state| {
-                types.capella.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-            .bellatrix => |state| {
-                types.bellatrix.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-            .deneb => |state| {
-                types.deneb.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-            .electra => |state| {
-                types.electra.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-            .fulu => |state| {
-                types.fulu.BeaconState.deinit(allocator, state);
-                allocator.destroy(state);
-            },
-        }
-    }
-
-    pub fn forkSeq(self: *const BeaconStateAllForks) ForkSeq {
-        return switch (self.*) {
-            .phase0 => .phase0,
-            .altair => .altair,
-            .bellatrix => .bellatrix,
-            .capella => .capella,
-            .deneb => .deneb,
-            .electra => .electra,
-            .fulu => .fulu,
-        };
-    }
-
-    pub fn isPhase0(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .phase0 => true,
-            else => false,
-        };
-    }
-
-    pub fn isAltair(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .altair => true,
-            else => false,
-        };
-    }
-
-    pub fn isPreAltair(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .phase0 => true,
-            else => false,
-        };
-    }
-
-    pub fn isPostAltair(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .phase0 => false,
-            else => true,
-        };
-    }
-
-    pub fn isBellatrix(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .bellatrix => true,
-            else => false,
-        };
-    }
-
-    pub fn isPreBellatrix(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair => false,
-            else => true,
-        };
-    }
-
-    pub fn isPostBellatrix(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair => false,
-            else => true,
-        };
-    }
-
-    pub fn isCapella(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .capella => true,
-            else => false,
-        };
-    }
-
-    pub fn isPreCapella(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix => true,
-            else => false,
-        };
-    }
-
-    pub fn isPostCapella(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix => false,
-            else => true,
-        };
-    }
-
-    pub fn isDeneb(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .deneb => true,
-            else => false,
-        };
-    }
-
-    pub fn isPreDeneb(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella => true,
-            else => false,
-        };
-    }
-
-    pub fn isPostDeneb(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella => false,
-            else => true,
-        };
-    }
-
-    pub fn isElectra(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .electra => true,
-            else => false,
-        };
-    }
-
-    pub fn isPreElectra(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .phase0, .altair, .bellatrix, .capella, .deneb => true,
-            else => false,
-        };
-    }
-
-    pub fn isPostElectra(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => false,
-            else => true,
-        };
-    }
-
-    pub fn isFulu(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .fulu => true,
-            else => false,
-        };
-    }
-
-    pub fn isPreFulu(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            .phase0, .altair, .bellatrix, .capella, .deneb, .electra => true,
-            else => false,
-        };
-    }
-
-    pub fn isPostFulu(self: *const BeaconStateAllForks) bool {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb, .electra => false,
-            else => true,
-        };
-    }
-
-    pub fn genesisTime(self: *const BeaconStateAllForks) u64 {
-        return switch (self.*) {
-            inline else => |state| state.genesis_time,
-        };
-    }
-
-    pub fn genesisValidatorsRoot(self: *const BeaconStateAllForks) Root {
-        return switch (self.*) {
-            inline else => |state| state.genesis_validators_root,
-        };
-    }
-
-    pub fn slot(self: *const BeaconStateAllForks) u64 {
-        return switch (self.*) {
-            inline else => |state| state.slot,
-        };
-    }
-
-    pub fn slotPtr(self: *const BeaconStateAllForks) *u64 {
-        return switch (self.*) {
-            inline else => |state| &state.slot,
-        };
-    }
-
-    pub fn fork(self: *const BeaconStateAllForks) Fork {
-        return switch (self.*) {
-            inline else => |state| state.fork,
-        };
-    }
-
-    pub fn forkPtr(self: *const BeaconStateAllForks) *Fork {
-        return switch (self.*) {
-            inline else => |state| &state.fork,
-        };
-    }
-
-    pub fn latestBlockHeader(self: *const BeaconStateAllForks) *BeaconBlockHeader {
-        return switch (self.*) {
-            inline else => |state| &state.latest_block_header,
-        };
-    }
-
-    pub fn blockRoots(self: *const BeaconStateAllForks) *[preset.SLOTS_PER_HISTORICAL_ROOT]Root {
-        return switch (self.*) {
-            inline else => |state| &state.block_roots,
-        };
-    }
-
-    pub fn stateRoots(self: *const BeaconStateAllForks) *[preset.SLOTS_PER_HISTORICAL_ROOT]Root {
-        return switch (self.*) {
-            inline else => |state| &state.state_roots,
-        };
-    }
-
-    pub fn historicalRoots(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(Root) {
-        return switch (self.*) {
-            inline else => |state| &state.historical_roots,
-        };
-    }
-
-    pub fn eth1Data(self: *const BeaconStateAllForks) *Eth1Data {
-        return switch (self.*) {
-            inline else => |state| &state.eth1_data,
-        };
-    }
-
-    pub fn eth1DataVotes(self: *const BeaconStateAllForks) *Eth1DataVotes {
-        return switch (self.*) {
-            inline else => |state| &state.eth1_data_votes,
-        };
-    }
-
-    pub fn eth1DepositIndex(self: *const BeaconStateAllForks) u64 {
-        return switch (self.*) {
-            inline else => |state| state.eth1_deposit_index,
-        };
-    }
-
-    pub fn eth1DepositIndexPtr(self: *const BeaconStateAllForks) *u64 {
-        return switch (self.*) {
-            inline else => |state| &state.eth1_deposit_index,
-        };
-    }
-
-    pub fn increaseEth1DepositIndex(self: *BeaconStateAllForks) void {
-        switch (self.*) {
-            inline else => |state| state.eth1_deposit_index += 1,
-        }
-    }
-
-    // TODO: change to []Validator
-    pub fn validators(self: *const BeaconStateAllForks) *Validators {
-        return switch (self.*) {
-            inline else => |state| &state.validators,
-        };
-    }
-
-    pub fn balances(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(u64) {
-        return switch (self.*) {
-            inline else => |state| &state.balances,
-        };
-    }
-
-    pub fn randaoMixes(self: *const BeaconStateAllForks) []Bytes32 {
-        return switch (self.*) {
-            inline else => |state| &state.randao_mixes,
-        };
-    }
-
-    pub fn slashings(self: *const BeaconStateAllForks) []u64 {
-        return switch (self.*) {
-            inline else => |state| &state.slashings,
-        };
-    }
-
-    pub fn previousEpochPendingAttestations(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(PendingAttestation) {
-        return switch (self.*) {
-            .phase0 => |state| &state.previous_epoch_attestations,
-            else => @panic("current_epoch_pending_attestations is not available post phase0"),
-        };
-    }
-
-    pub fn currentEpochPendingAttestations(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(PendingAttestation) {
-        return switch (self.*) {
-            .phase0 => |state| &state.current_epoch_attestations,
-            else => @panic("current_epoch_pending_attestations is not available post phase0"),
-        };
-    }
-
-    pub fn rotateEpochPendingAttestations(self: *BeaconStateAllForks, allocator: Allocator) void {
-        switch (self.*) {
-            .phase0 => |state| {
-                for (state.previous_epoch_attestations.items) |*attestation| {
-                    types.phase0.PendingAttestation.deinit(allocator, attestation);
-                }
-                state.previous_epoch_attestations.deinit(allocator);
-                state.previous_epoch_attestations = state.current_epoch_attestations;
-                state.current_epoch_attestations = types.phase0.EpochAttestations.default_value;
-            },
-            else => @panic("shift_epoch_pending_attestations is not available post phase0"),
-        }
-    }
-
-    pub fn previousEpochParticipations(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(u8) {
-        return switch (self.*) {
-            .phase0 => @panic("previous_epoch_participation is not available in phase0"),
-            inline .altair, .bellatrix, .capella, .deneb, .electra, .fulu => |state| &state.previous_epoch_participation,
-        };
-    }
-
-    pub fn currentEpochParticipations(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(u8) {
-        return switch (self.*) {
-            .phase0 => @panic("current_epoch_participation is not available in phase0"),
-            inline else => |state| &state.current_epoch_participation,
-        };
-    }
-
-    pub fn rotateEpochParticipations(self: *BeaconStateAllForks, allocator: Allocator) !void {
-        switch (self.*) {
-            .phase0 => @panic("rotate_epoch_participations is not available in phase0"),
-            inline else => |state| {
-                state.previous_epoch_participation.clearRetainingCapacity();
-                try state.previous_epoch_participation.appendSlice(allocator, state.current_epoch_participation.items);
-                @memset(state.current_epoch_participation.items, 0);
-            },
-        }
-    }
-
-    pub fn justificationBits(self: *const BeaconStateAllForks) *JustificationBits {
-        return switch (self.*) {
-            inline else => |state| &state.justification_bits,
-        };
-    }
-
-    pub fn previousJustifiedCheckpoint(self: *const BeaconStateAllForks) *Checkpoint {
-        return switch (self.*) {
-            inline else => |state| &state.previous_justified_checkpoint,
-        };
-    }
-
-    pub fn currentJustifiedCheckpoint(self: *const BeaconStateAllForks) *Checkpoint {
-        return switch (self.*) {
-            inline else => |state| &state.current_justified_checkpoint,
-        };
-    }
-
-    pub fn finalizedCheckpoint(self: *const BeaconStateAllForks) *Checkpoint {
-        return switch (self.*) {
-            inline else => |state| &state.finalized_checkpoint,
-        };
-    }
-
-    pub fn inactivityScores(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(u64) {
-        return switch (self.*) {
-            .phase0 => @panic("inactivity_scores is not available in phase0"),
-            inline else => |state| &state.inactivity_scores,
-        };
-    }
-
-    pub fn currentSyncCommittee(self: *const BeaconStateAllForks) *SyncCommittee {
-        return switch (self.*) {
-            .phase0 => @panic("current_sync_committee is not available in phase0"),
-            inline else => |state| &state.current_sync_committee,
-        };
-    }
-
-    pub fn nextSyncCommittee(self: *const BeaconStateAllForks) *SyncCommittee {
-        return switch (self.*) {
-            .phase0 => @panic("next_sync_committee is not available in phase0"),
-            inline else => |state| &state.next_sync_committee,
-        };
-    }
-
-    pub fn setNextSyncCommittee(self: *BeaconStateAllForks, sync_committee: *const SyncCommittee) void {
-        switch (self.*) {
-            .phase0 => @panic("next_sync_committee is not available in phase0"),
-            inline else => |state| state.next_sync_committee = sync_committee.*,
-        }
-    }
-
-    pub fn latestExecutionPayloadHeader(self: *const BeaconStateAllForks) ExecutionPayloadHeader {
-        return switch (self.*) {
-            .bellatrix => |state| .{ .bellatrix = &state.latest_execution_payload_header },
-            .capella => |state| .{ .capella = &state.latest_execution_payload_header },
-            .deneb => |state| .{ .deneb = &state.latest_execution_payload_header },
-            .electra => |state| .{ .electra = &state.latest_execution_payload_header },
-            .fulu => |state| .{ .electra = &state.latest_execution_payload_header },
-            else => panic("latest_execution_payload_header is not available in {}", .{self}),
-        };
-    }
-
-    // `header` ownership is transferred to BeaconState and will be deinit when state is deinit
-    // caller must guarantee that `header` is properly initialized and allocated/cloned with `allocator` and no longer used after this call
-    pub fn setLatestExecutionPayloadHeader(self: *BeaconStateAllForks, allocator: Allocator, header: ExecutionPayloadHeader) void {
-        const current_header = self.latestExecutionPayloadHeader();
-        current_header.deinit(allocator);
-
-        switch (self.*) {
-            .bellatrix => |state| state.latest_execution_payload_header = header.bellatrix.*,
-            .capella => |state| state.latest_execution_payload_header = header.capella.*,
-            .deneb => |state| state.latest_execution_payload_header = header.deneb.*,
-            .electra => |state| state.latest_execution_payload_header = header.electra.*,
-            .fulu => |state| state.latest_execution_payload_header = header.electra.*,
-            else => panic("latest_execution_payload_header is not available in {}", .{self}),
-        }
-    }
-
-    pub fn nextWithdrawalIndex(self: *const BeaconStateAllForks) *u64 {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix => panic("next_withdrawal_index is not available in {}", .{self}),
-            inline else => |state| &state.next_withdrawal_index,
-        };
-    }
-
-    pub fn nextWithdrawalValidatorIndex(self: *const BeaconStateAllForks) *u64 {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix => panic("next_withdrawal_validator_index is not available in {}", .{self}),
-            inline else => |state| &state.next_withdrawal_validator_index,
-        };
-    }
-
-    pub fn historicalSummaries(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(HistoricalSummary) {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix => panic("historical_summaries is not available in {}", .{self}),
-            inline else => |state| &state.historical_summaries,
-        };
-    }
-
-    pub fn depositRequestsStartIndex(self: *const BeaconStateAllForks) *u64 {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => panic("deposit_requests_start_index is not available in {}", .{self}),
-            inline else => |state| &state.deposit_requests_start_index,
-        };
-    }
-
-    pub fn depositBalanceToConsume(self: *const BeaconStateAllForks) *Gwei {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => panic("deposit_balance_to_consume is not available in {}", .{self}),
-            inline else => |state| &state.deposit_balance_to_consume,
-        };
-    }
-
-    pub fn exitBalanceToConsume(self: *const BeaconStateAllForks) *Gwei {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => panic("exit_balance_to_consume is not available in {}", .{self}),
-            inline else => |state| &state.exit_balance_to_consume,
-        };
-    }
-
-    pub fn earliestExitEpoch(self: *const BeaconStateAllForks) *Epoch {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => panic("earliest_exit_epoch is not available in {}", .{self}),
-            inline else => |state| &state.earliest_exit_epoch,
-        };
-    }
-
-    pub fn consolidationBalanceToConsume(self: *const BeaconStateAllForks) *Gwei {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => panic("consolidation_balance_to_consume is not available in {}", .{self}),
-            inline else => |state| &state.consolidation_balance_to_consume,
-        };
-    }
-
-    pub fn earliestConsolidationEpoch(self: *const BeaconStateAllForks) *Epoch {
-        return switch (self.*) {
-            inline .phase0, .altair, .bellatrix, .capella, .deneb => panic("earliest_consolidation_epoch is not available in {}", .{self}),
-            inline else => |state| &state.earliest_consolidation_epoch,
-        };
-    }
-
-    pub fn pendingDeposits(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(PendingDeposit) {
-        return switch (self.*) {
-            inline .electra, .fulu => |state| &state.pending_deposits,
-            else => panic("pending_deposits is not available in {}", .{self}),
-        };
-    }
-
-    pub fn pendingPartialWithdrawals(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(PendingPartialWithdrawal) {
-        return switch (self.*) {
-            inline .electra, .fulu => |state| &state.pending_partial_withdrawals,
-            else => panic("pending_partial_withdrawals is not available in {}", .{self}),
-        };
-    }
-
-    pub fn pendingConsolidations(self: *const BeaconStateAllForks) *std.ArrayListUnmanaged(PendingConsolidation) {
-        return switch (self.*) {
-            inline .electra, .fulu => |state| &state.pending_consolidations,
-            else => panic("pending_consolidations is not available in {}", .{self}),
-        };
-    }
-
-    /// Get proposer_lookahead
-    /// Returns a slice of ValidatorIndex with length (MIN_SEED_LOOKAHEAD + 1) * SLOTS_PER_EPOCH
-    pub fn proposerLookahead(self: *const BeaconStateAllForks) []ValidatorIndex {
-        return switch (self.*) {
-            .fulu => |state| &state.proposer_lookahead,
-            else => panic("proposer_lookahead is not available in {}", .{self}),
-        };
-    }
-
-    /// Copies fields of `BeaconState` from type `F` to type `T`, provided they have the same field name.
-    fn populateFields(
-        comptime F: type,
-        comptime T: type,
-        allocator: Allocator,
-        state: *F.Type,
-    ) !*T.Type {
-        var upgraded = try allocator.create(T.Type);
-        errdefer allocator.destroy(upgraded);
-        upgraded.* = T.default_value;
-        inline for (F.fields) |f| {
-            if (@hasField(T.Type, f.name)) {
-                if (comptime isFixedType(f.type)) {
-                    try f.type.clone(&@field(state, f.name), &@field(upgraded, f.name));
-                } else {
-                    if (@TypeOf(@field(upgraded, f.name)) != @TypeOf(f.type.default_value)) {
-                        // 2 BeaconState of prev_fork and cur_fork has same field name but different types
-                        // for example latest_execution_payload_header changed from Bellatrix to Capella
-                    } else {
-                        @field(upgraded, f.name) = f.type.default_value;
-                        try f.type.clone(allocator, &@field(state, f.name), &@field(upgraded, f.name));
-                    }
-                }
-            }
-        }
-
-        return upgraded;
-    }
-
-    /// Upgrade `self` from a certain fork to the next.
-    /// Allocates a new `state` of the next fork, clones all fields of the current `state` to it and assigns `self` to it.
-    /// Caller must make sure an upgrade is needed by checking BeaconConfig then free upgraded state.
-    /// Caller needs to deinit the old state
-    pub fn upgradeUnsafe(self: *BeaconStateAllForks, allocator: std.mem.Allocator) !*BeaconStateAllForks {
-        switch (self.*) {
-            .phase0 => |state| {
-                self.* = .{
-                    .altair = try populateFields(
-                        types.phase0.BeaconState,
-                        types.altair.BeaconState,
-                        allocator,
-                        state,
-                    ),
-                };
-                return self;
-            },
-            .altair => |state| {
-                self.* = .{
-                    .bellatrix = try populateFields(
-                        types.altair.BeaconState,
-                        types.bellatrix.BeaconState,
-                        allocator,
-                        state,
-                    ),
-                };
-                return self;
-            },
-            .bellatrix => |state| {
-                self.* = .{
-                    .capella = try populateFields(
-                        types.bellatrix.BeaconState,
-                        types.capella.BeaconState,
-                        allocator,
-                        state,
-                    ),
-                };
-                return self;
-            },
-            .capella => |state| {
-                self.* = .{
-                    .deneb = try populateFields(
-                        types.capella.BeaconState,
-                        types.deneb.BeaconState,
-                        allocator,
-                        state,
-                    ),
-                };
-                return self;
-            },
-            .deneb => |state| {
-                self.* = .{
-                    .electra = try populateFields(
-                        types.deneb.BeaconState,
-                        types.electra.BeaconState,
-                        allocator,
-                        state,
-                    ),
-                };
-                return self;
-            },
-            .electra => |state| {
-                self.* = .{
-                    .fulu = try populateFields(
-                        types.electra.BeaconState,
-                        types.fulu.BeaconState,
-                        allocator,
-                        state,
-                    ),
-                };
-                return self;
-            },
-            .fulu => {
-                @panic("upgrade state from fulu to glaos unimplemented");
-            },
-        }
-    }
-};
-
-test "electra - sanity" {
-    const allocator = std.testing.allocator;
-    var electra_state = types.electra.BeaconState.default_value;
-    electra_state.slot = 12345;
-    var beacon_state = BeaconStateAllForks{
-        .electra = &electra_state,
-    };
-
-    try std.testing.expect(beacon_state.genesisTime() == 0);
-    try std.testing.expectEqualSlices(u8, &[_]u8{0} ** 32, &beacon_state.genesisValidatorsRoot());
-    try std.testing.expect(beacon_state.slot() == 12345);
-    const slot = beacon_state.slotPtr();
-    slot.* = 2025;
-    try std.testing.expect(beacon_state.slot() == 2025);
-
-    var out: [32]u8 = undefined;
-    try beacon_state.hashTreeRoot(allocator, &out);
-    try expect(!std.mem.eql(u8, &[_]u8{0} ** 32, &out));
-
-    // TODO: more tests
-}
-
-test "clone - sanity" {
-    const allocator = std.testing.allocator;
-    var electra_state = types.electra.BeaconState.default_value;
-    electra_state.slot = 12345;
-    var beacon_state = BeaconStateAllForks{
-        .electra = &electra_state,
-    };
-
-    // test the clone() and deinit() works fine without memory leak
-    const cloned_state = try beacon_state.clone(allocator);
-    try expect(cloned_state.slot() == 12345);
-    defer {
-        cloned_state.deinit(allocator);
-        allocator.destroy(cloned_state);
-    }
-}
-
-test "upgrade state - sanity" {
-    const allocator = std.testing.allocator;
-    const phase0_state = try allocator.create(types.phase0.BeaconState.Type);
-    phase0_state.* = types.phase0.BeaconState.default_value;
-
-    var phase0 = BeaconStateAllForks{ .phase0 = phase0_state };
-    const old_phase0_state = phase0.phase0;
-    defer {
-        types.phase0.BeaconState.deinit(allocator, old_phase0_state);
-        allocator.destroy(old_phase0_state);
-    }
-
-    var altair = try phase0.upgradeUnsafe(allocator);
-    const old_altair_state = altair.altair;
-    defer {
-        types.altair.BeaconState.deinit(allocator, old_altair_state);
-        allocator.destroy(old_altair_state);
-    }
-
-    var bellatrix = try altair.upgradeUnsafe(allocator);
-    const old_bellatrix_state = bellatrix.bellatrix;
-    defer {
-        types.bellatrix.BeaconState.deinit(allocator, old_bellatrix_state);
-        allocator.destroy(old_bellatrix_state);
-    }
-
-    var capella = try bellatrix.upgradeUnsafe(allocator);
-    const old_capella_state = capella.capella;
-    defer {
-        types.capella.BeaconState.deinit(allocator, old_capella_state);
-        allocator.destroy(old_capella_state);
-    }
-
-    var deneb = try capella.upgradeUnsafe(allocator);
-    const old_deneb_state = deneb.deneb;
-    defer {
-        types.deneb.BeaconState.deinit(allocator, old_deneb_state);
-        allocator.destroy(old_deneb_state);
-    }
-
-    var electra = try deneb.upgradeUnsafe(allocator);
-    const old_electra_state = electra.electra;
-    defer {
-        types.electra.BeaconState.deinit(allocator, old_electra_state);
-        allocator.destroy(old_electra_state);
-    }
-
-    var fulu = try electra.upgradeUnsafe(allocator);
-    defer fulu.deinit(allocator);
-}
+++++++ Contents of side #2
const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;
const preset = @import("preset").preset;
const ForkSeq = @import("config").ForkSeq;
const Node = @import("persistent_merkle_tree").Node;
const isFixedType = @import("ssz").isFixedType;
const CloneOpts = @import("ssz").tree_view.BaseTreeView.CloneOpts;
const ct = @import("consensus_types");
const ExecutionPayloadHeader = @import("./execution_payload.zig").ExecutionPayloadHeader;

/// wrapper for all BeaconState types across forks so that we don't have to do switch/case for all methods
pub const BeaconState = union(ForkSeq) {
    phase0: ct.phase0.BeaconState.TreeView,
    altair: ct.altair.BeaconState.TreeView,
    bellatrix: ct.bellatrix.BeaconState.TreeView,
    capella: ct.capella.BeaconState.TreeView,
    deneb: ct.deneb.BeaconState.TreeView,
    electra: ct.electra.BeaconState.TreeView,
    fulu: ct.fulu.BeaconState.TreeView,

    pub fn fromValue(allocator: Allocator, pool: *Node.Pool, comptime fork_seq: ForkSeq, value: anytype) !BeaconState {
        return switch (fork_seq) {
            .phase0 => .{
                .phase0 = try ct.phase0.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
            .altair => .{
                .altair = try ct.altair.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
            .bellatrix => .{
                .bellatrix = try ct.bellatrix.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
            .capella => .{
                .capella = try ct.capella.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
            .deneb => .{
                .deneb = try ct.deneb.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
            .electra => .{
                .electra = try ct.electra.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
            .fulu => .{
                .fulu = try ct.fulu.BeaconState.TreeView.fromValue(allocator, pool, value),
            },
        };
    }

    pub fn deserialize(allocator: Allocator, pool: *Node.Pool, fork_seq: ForkSeq, bytes: []const u8) !BeaconState {
        return switch (fork_seq) {
            .phase0 => .{
                .phase0 = try ct.phase0.BeaconState.TreeView.deserialize(allocator, pool, bytes),
            },
            .altair => .{
                .altair = try ct.altair.BeaconState.TreeView.deserialize(allocator, pool, bytes),
            },
            .bellatrix => .{
                .bellatrix = try ct.bellatrix.BeaconState.TreeView.deserialize(allocator, pool, bytes),
            },
            .capella => .{
                .capella = try ct.capella.BeaconState.TreeView.deserialize(allocator, pool, bytes),
            },
            .deneb => .{
                .deneb = try ct.deneb.BeaconState.TreeView.deserialize(allocator, pool, bytes),
            },
            .electra => .{
                .electra = try ct.electra.BeaconState.TreeView.deserialize(allocator, pool, bytes),
            },
        };
    }

    pub fn serialize(self: BeaconState, allocator: Allocator) ![]u8 {
        switch (self) {
            .phase0 => |state| {
                const out = try allocator.alloc(u8, try state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
            .altair => |state| {
                const out = try allocator.alloc(u8, state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
            .bellatrix => |state| {
                const out = try allocator.alloc(u8, state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
            .capella => |state| {
                const out = try allocator.alloc(u8, state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
            .deneb => |state| {
                const out = try allocator.alloc(u8, state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
            .electra => |state| {
                const out = try allocator.alloc(u8, state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
            .fulu => |state| {
                const out = try allocator.alloc(u8, state.serializedSize());
                errdefer allocator.free(out);
                _ = state.serializeIntoBytes(out);
                return out;
            },
        }
    }

    pub fn format(
        self: BeaconState,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        return switch (self) {
            inline else => {
                try writer.print("{s} (at slot {})", .{ @tagName(self), self.slot() });
            },
        };
    }

    pub fn clone(self: *const BeaconState, opts: CloneOpts) !BeaconState {
        return switch (self.*) {
            .phase0 => |state| .{ .phase0 = try state.clone(opts) },
            .altair => |state| .{ .altair = try state.clone(opts) },
            .bellatrix => |state| .{ .bellatrix = try state.clone(opts) },
            .capella => |state| .{ .capella = try state.clone(opts) },
            .deneb => |state| .{ .deneb = try state.clone(opts) },
            .electra => |state| .{ .electra = try state.clone(opts) },
            .fulu => |state| .{ .fulu = try state.clone(opts) },
        };
    }

    pub fn commit(self: *const BeaconState) !void {
        switch (self.*) {
            inline else => |*state| try @constCast(state).commit(),
        }
    }

    pub fn hashTreeRoot(self: *const BeaconState) !*const [32]u8 {
        return switch (self.*) {
            inline else => |*state| {
                try state.commit();
                return state.base_view.root.getRoot(state.base_view.pool);
            },
        };
    }

    pub fn deinit(self: *BeaconState) void {
        switch (self.*) {
            inline else => |*state| state.deinit(),
        }
    }

    pub fn forkSeq(self: *const BeaconState) ForkSeq {
        return (self.*);
    }

    pub fn genesisTime(self: *const BeaconState) !u64 {
        return switch (self.*) {
            inline else => |state| try state.get("genesis_time"),
        };
    }

    pub fn genesisValidatorsRoot(self: *const BeaconState) !*const [32]u8 {
        return switch (self.*) {
            inline else => |state| try state.getRoot("genesis_validators_root"),
        };
    }

    pub fn slot(self: *const BeaconState) !u64 {
        return switch (self.*) {
            inline else => |state| try state.get("slot"),
        };
    }

    pub fn setSlot(self: *BeaconState, s: u64) !void {
        switch (self.*) {
            inline else => |*state| try state.set("slot", s),
        }
    }

    pub fn fork(self: *const BeaconState) !ct.phase0.Fork.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("fork"),
        };
    }

    pub fn forkCurrentVersion(self: *const BeaconState) ![4]u8 {
        var f = try self.fork();
        const current_version_root = try f.getRoot("current_version");
        var version: [4]u8 = undefined;
        @memcpy(&version, current_version_root[0..4]);
        return version;
    }

    pub fn setFork(self: *BeaconState, f: *const ct.phase0.Fork.Type) !void {
        switch (self.*) {
            inline else => |*state| try state.setValue("fork", f),
        }
    }

    pub fn latestBlockHeader(self: *const BeaconState) !ct.phase0.BeaconBlockHeader.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("latest_block_header"),
        };
    }

    pub fn setLatestBlockHeader(self: *BeaconState, header: *const ct.phase0.BeaconBlockHeader.Type) !void {
        switch (self.*) {
            inline else => |*state| try state.setValue("latest_block_header", header),
        }
    }

    pub fn blockRoots(self: *const BeaconState) !ct.phase0.HistoricalBlockRoots.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("block_roots"),
        };
    }

    pub fn stateRoots(self: *const BeaconState) !ct.phase0.HistoricalStateRoots.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("state_roots"),
        };
    }

    pub fn historicalRoots(self: *const BeaconState) !ct.phase0.HistoricalRoots.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("historical_roots"),
        };
    }

    pub fn eth1Data(self: *const BeaconState) !ct.phase0.Eth1Data.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("eth1_data"),
        };
    }

    pub fn setEth1Data(self: *BeaconState, eth1_data: *const ct.phase0.Eth1Data.Type) !void {
        switch (self.*) {
            inline else => |*state| try state.setValue("eth1_data", eth1_data),
        }
    }

    pub fn eth1DataVotes(self: *const BeaconState) !ct.phase0.Eth1DataVotes.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("eth1_data_votes"),
        };
    }

    pub fn appendEth1DataVote(self: *BeaconState, eth1_data: *const ct.phase0.Eth1Data.Type) !void {
        var votes = try self.eth1DataVotes();
        const VotesView = @TypeOf(votes);
        const ElemST = VotesView.SszType.Element;

        const child_root = try ElemST.tree.fromValue(votes.base_view.pool, eth1_data);
        errdefer votes.base_view.pool.unref(child_root);
        const child_view = try ElemST.TreeView.init(
            votes.base_view.allocator,
            votes.base_view.pool,
            child_root,
        );

        try votes.push(child_view);
    }

    pub fn eth1DepositIndex(self: *const BeaconState) !u64 {
        return switch (self.*) {
            inline else => |state| try state.get("eth1_deposit_index"),
        };
    }

    pub fn setEth1DepositIndex(self: *BeaconState, index: u64) !void {
        return switch (self.*) {
            inline else => |*state| try state.set("eth1_deposit_index", index),
        };
    }

    pub fn incrementEth1DepositIndex(self: *BeaconState) !void {
        try self.setEth1DepositIndex(try self.eth1DepositIndex() + 1);
    }

    pub fn validators(self: *const BeaconState) !ct.phase0.Validators.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("validators"),
        };
    }

    pub fn validatorsCount(self: *const BeaconState) !usize {
        return switch (self.*) {
            inline else => |state| {
                var validators_view = try state.get("validators");
                return validators_view.length();
            },
        };
    }

    // Returns a read-only slice of validators.
    // Caller owns the returned slice and must free it with the same allocator.
    pub fn validatorsSlice(self: *const BeaconState, allocator: Allocator) ![]const ct.phase0.Validator.Type {
        return switch (self.*) {
            inline else => |state| {
                var validators_view = try state.get("validators");
                return validators_view.getAllReadonlyValues(allocator);
            },
        };
    }

    pub fn balances(self: *const BeaconState) !ct.phase0.Balances.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("balances"),
        };
    }

    pub fn randaoMixes(self: *const BeaconState) !ct.phase0.RandaoMixes.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("randao_mixes"),
        };
    }

    pub fn setRandaoMix(self: *BeaconState, epoch: u64, randao_mix: *const ct.primitive.Bytes32.Type) !void {
        var mixes = try self.randaoMixes();
        const MixesView = @TypeOf(mixes);
        const ElemST = MixesView.SszType.Element;

        const child_root = try ElemST.tree.fromValue(mixes.base_view.pool, randao_mix);
        errdefer mixes.base_view.pool.unref(child_root);
        const child_view = try ElemST.TreeView.init(
            mixes.base_view.allocator,
            mixes.base_view.pool,
            child_root,
        );

        try mixes.set(epoch % preset.EPOCHS_PER_HISTORICAL_VECTOR, child_view);
    }

    pub fn slashings(self: *const BeaconState) !ct.phase0.Slashings.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("slashings"),
        };
    }

    pub fn previousEpochPendingAttestations(self: *const BeaconState) !ct.phase0.EpochAttestations.TreeView {
        return switch (self.*) {
            .phase0 => |state| try state.get("previous_epoch_attestations"),
            else => error.InvalidAtFork,
        };
    }

    pub fn currentEpochPendingAttestations(self: *const BeaconState) !ct.phase0.EpochAttestations.TreeView {
        return switch (self.*) {
            .phase0 => |state| try state.get("current_epoch_attestations"),
            else => error.InvalidAtFork,
        };
    }

    pub fn rotateEpochPendingAttestations(self: *BeaconState) !void {
        return switch (self.*) {
            .phase0 => |*state| {
                const current_epoch_attestations = try state.get("current_epoch_attestations");
                try state.set("previous_epoch_attestations", current_epoch_attestations);
                try state.setValue("current_epoch_attestations", &ct.phase0.EpochAttestations.default_value);
            },
            else => error.InvalidAtFork,
        };
    }

    pub fn previousEpochParticipation(self: *const BeaconState) !ct.altair.EpochParticipation.TreeView {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |state| try state.get("previous_epoch_participation"),
        };
    }

    pub fn setPreviousEpochParticipation(self: *BeaconState, participations: *const ct.altair.EpochParticipation.Type) !void {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |*state| try state.setValue("previous_epoch_participation", participations),
        };
    }

    pub fn currentEpochParticipation(self: *const BeaconState) !ct.altair.EpochParticipation.TreeView {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |state| try state.get("current_epoch_participation"),
        };
    }

    pub fn rotateEpochParticipation(self: *BeaconState) !void {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |*state| {
                const current_epoch_participation = try state.get("current_epoch_participation");
                try state.set("previous_epoch_participation", current_epoch_participation);
                try state.setValue("current_epoch_participation", &ct.altair.EpochParticipation.default_value);
            },
        };
    }

    pub fn justificationBits(self: *const BeaconState) !ct.phase0.JustificationBits.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("justification_bits"),
        };
    }

    pub fn previousJustifiedCheckpoint(self: *const BeaconState) !ct.phase0.Checkpoint.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("previous_justified_checkpoint"),
        };
    }

    pub fn currentJustifiedCheckpoint(self: *const BeaconState) !ct.phase0.Checkpoint.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("current_justified_checkpoint"),
        };
    }

    pub fn finalizedCheckpoint(self: *const BeaconState) !ct.phase0.Checkpoint.TreeView {
        return switch (self.*) {
            inline else => |state| try state.get("finalized_checkpoint"),
        };
    }

    pub fn finalizedEpoch(self: *const BeaconState) !u64 {
        return switch (self.*) {
            inline else => |state| {
                var checkpoint_view = try state.get("finalized_checkpoint");
                return try checkpoint_view.get("epoch");
            },
        };
    }

    pub fn inactivityScores(self: *const BeaconState) !ct.altair.InactivityScores.TreeView {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |state| try state.get("inactivity_scores"),
        };
    }

    pub fn currentSyncCommittee(self: *const BeaconState) !ct.altair.SyncCommittee.TreeView {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |state| try state.get("current_sync_committee"),
        };
    }

    pub fn setCurrentSyncCommittee(self: *BeaconState, sync_committee: *const ct.altair.SyncCommittee.Type) !void {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |*state| try state.setValue("current_sync_committee", sync_committee),
        };
    }

    pub fn nextSyncCommittee(self: *const BeaconState) !ct.altair.SyncCommittee.TreeView {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |state| try state.get("next_sync_committee"),
        };
    }

    pub fn setNextSyncCommittee(self: *BeaconState, sync_committee: *const ct.altair.SyncCommittee.Type) !void {
        return switch (self.*) {
            .phase0 => error.InvalidAtFork,
            inline else => |*state| try state.setValue("next_sync_committee", sync_committee),
        };
    }

    pub fn latestExecutionPayloadHeader(self: *const BeaconState, allocator: Allocator) !ExecutionPayloadHeader {
        return switch (self.*) {
            .phase0, .altair => error.InvalidAtFork,
            .bellatrix => |state| .{
                .bellatrix = (try state.get("latest_execution_payload_header")).toValue(allocator),
            },
            .capella => |state| .{
                .capella = (try state.get("latest_execution_payload_header")).toValue(allocator),
            },
            .deneb => |state| .{
                .deneb = (try state.get("latest_execution_payload_header")).toValue(allocator),
            },
            .electra => |state| .{
                .deneb = (try state.get("latest_execution_payload_header")).toValue(allocator),
            },
            .fulu => |state| .{
                .deneb = (try state.get("latest_execution_payload_header")).toValue(allocator),
            },
        };
    }

    pub fn latestExecutionPayloadHeaderBlockHash(self: *const BeaconState) !*const [32]u8 {
        return switch (self.*) {
            .phase0, .altair => error.InvalidAtFork,
            inline else => |state| {
                const header = try state.get("latest_execution_payload_header");
                return try header.getRoot("block_hash");
            },
        };
    }

    // `header` ownership is transferred to BeaconState and will be deinit when state is deinit
    // caller must guarantee that `header` is properly initialized and allocated/cloned with `allocator` and no longer used after this call
    pub fn setLatestExecutionPayloadHeader(self: *BeaconState, header: ExecutionPayloadHeader) !void {
        switch (self.*) {
            .bellatrix => |*state| try state.setValue("latest_execution_payload_header", header.bellatrix),
            .capella => |*state| try state.setValue("latest_execution_payload_header", header.capella),
            .deneb => |*state| try state.setValue("latest_execution_payload_header", header.deneb),
            .electra => |*state| try state.setValue("latest_execution_payload_header", header.deneb),
            .fulu => |*state| try state.setValue("latest_execution_payload_header", header.deneb),
            else => return error.InvalidAtFork,
        }
    }

    pub fn nextWithdrawalIndex(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix => error.InvalidAtFork,
            inline else => |state| try state.get("next_withdrawal_index"),
        };
    }

    pub fn setNextWithdrawalIndex(self: *BeaconState, next_withdrawal_index: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix => error.InvalidAtFork,
            inline else => |*state| try state.set("next_withdrawal_index", next_withdrawal_index),
        };
    }

    pub fn nextWithdrawalValidatorIndex(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix => error.InvalidAtFork,
            inline else => |state| try state.get("next_withdrawal_validator_index"),
        };
    }

    pub fn setNextWithdrawalValidatorIndex(self: *BeaconState, next_withdrawal_validator_index: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix => error.InvalidAtFork,
            inline else => |*state| try state.set("next_withdrawal_validator_index", next_withdrawal_validator_index),
        };
    }

    pub fn historicalSummaries(self: *const BeaconState) !ct.capella.HistoricalSummaries.TreeView {
        return switch (self.*) {
            .phase0, .altair, .bellatrix => error.InvalidAtFork,
            inline else => |state| try state.get("historical_summaries"),
        };
    }

    pub fn depositRequestsStartIndex(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("deposit_requests_start_index"),
        };
    }

    pub fn setDepositRequestsStartIndex(self: *BeaconState, index: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("deposit_requests_start_index", index),
        };
    }

    pub fn depositBalanceToConsume(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("deposit_balance_to_consume"),
        };
    }

    pub fn setDepositBalanceToConsume(self: *BeaconState, balance: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("deposit_balance_to_consume", balance),
        };
    }

    pub fn exitBalanceToConsume(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("exit_balance_to_consume"),
        };
    }

    pub fn setExitBalanceToConsume(self: *BeaconState, balance: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("exit_balance_to_consume", balance),
        };
    }

    pub fn earliestExitEpoch(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("earliest_exit_epoch"),
        };
    }

    pub fn setEarliestExitEpoch(self: *BeaconState, epoch: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("earliest_exit_epoch", epoch),
        };
    }

    pub fn consolidationBalanceToConsume(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("consolidation_balance_to_consume"),
        };
    }

    pub fn setConsolidationBalanceToConsume(self: *BeaconState, balance: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("consolidation_balance_to_consume", balance),
        };
    }

    pub fn earliestConsolidationEpoch(self: *const BeaconState) !u64 {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("earliest_consolidation_epoch"),
        };
    }

    pub fn setEarliestConsolidationEpoch(self: *BeaconState, epoch: u64) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("earliest_consolidation_epoch", epoch),
        };
    }

    pub fn pendingDeposits(self: *const BeaconState) !ct.electra.PendingDeposits.TreeView {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("pending_deposits"),
        };
    }

    pub fn setPendingDeposits(self: *BeaconState, deposits: ct.electra.PendingDeposits.TreeView) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |*state| try state.set("pending_deposits", deposits),
        };
    }

    pub fn pendingPartialWithdrawals(self: *const BeaconState) !ct.electra.PendingPartialWithdrawals.TreeView {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("pending_partial_withdrawals"),
        };
    }

    pub fn pendingConsolidations(self: *const BeaconState) !ct.electra.PendingConsolidations.TreeView {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb => error.InvalidAtFork,
            inline else => |state| try state.get("pending_consolidations"),
        };
    }

    /// Get proposer_lookahead
    pub fn proposerLookahead(self: *const BeaconState) !ct.fulu.ProposerLookahead.TreeView {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb, .electra => error.InvalidAtFork,
            inline else => |state| try state.get("proposer_lookahead"),
        };
    }

    /// Returns a read-only slice of proposer_lookahead values.
    /// Caller owns the returned slice and must free it with the same allocator.
    pub fn proposerLookaheadSlice(self: *const BeaconState, allocator: Allocator) !*const [64]u64 {
        var lookahead_view = try self.proposerLookahead();
        return @ptrCast(try lookahead_view.getAll(allocator));
    }

    pub fn setProposerLookahead(self: *BeaconState, proposer_lookahead: *const ct.fulu.ProposerLookahead.Type) !void {
        return switch (self.*) {
            .phase0, .altair, .bellatrix, .capella, .deneb, .electra => error.InvalidAtFork,
            inline else => |*state| try state.setValue("proposer_lookahead", proposer_lookahead),
        };
    }

    /// Copies fields of `BeaconState` from type `F` to type `T`, provided they have the same field name.
    fn populateFields(
        comptime F: type,
        comptime T: type,
        allocator: Allocator,
        pool: *Node.Pool,
        state: F.TreeView,
    ) !T.TreeView {
        // first ensure that the source state is committed
        var committed_state = state;
        try committed_state.commit();

        var upgraded = try T.TreeView.fromValue(allocator, pool, &T.default_value);
        errdefer upgraded.deinit();

        inline for (F.fields) |f| {
            // const field_name: []const u8 = comptime f.name[0..f.name.len];
            if (comptime T.hasField(f.name)) {
                if (comptime isFixedType(f.type)) {
                    try upgraded.set(f.name, try committed_state.get(f.name));
                } else {
                    if (T.getFieldType(f.name) != f.type) {
                        // BeaconState of prev_fork and cur_fork has the same field name but different types
                        // for example latest_execution_payload_header changed from Bellatrix to Capella
                        // In this case we just skip copying this field and leave it to caller to set properly
                    } else {
                        const source_node = try committed_state.getRootNode(f.name);
                        try upgraded.setRootNode(f.name, source_node);
                    }
                }
            }
        }

        try upgraded.commit();

        return upgraded;
    }

    /// Upgrade `self` from a certain fork to the next.
    /// Allocates a new `state` of the next fork, clones all fields of the current `state` to it and assigns `self` to it.
    /// Caller must make sure an upgrade is needed by checking BeaconConfig then free upgraded state.
    /// Caller needs to deinit the old state
    pub fn upgradeUnsafe(self: *const BeaconState) !BeaconState {
        return switch (self.*) {
            .phase0 => |state| .{
                .altair = try populateFields(
                    ct.phase0.BeaconState,
                    ct.altair.BeaconState,
                    state.base_view.allocator,
                    state.base_view.pool,
                    state,
                ),
            },
            .altair => |state| .{
                .bellatrix = try populateFields(
                    ct.altair.BeaconState,
                    ct.bellatrix.BeaconState,
                    state.base_view.allocator,
                    state.base_view.pool,
                    state,
                ),
            },
            .bellatrix => |state| .{
                .capella = try populateFields(
                    ct.bellatrix.BeaconState,
                    ct.capella.BeaconState,
                    state.base_view.allocator,
                    state.base_view.pool,
                    state,
                ),
            },
            .capella => |state| .{
                .deneb = try populateFields(
                    ct.capella.BeaconState,
                    ct.deneb.BeaconState,
                    state.base_view.allocator,
                    state.base_view.pool,
                    state,
                ),
            },
            .deneb => |state| .{
                .electra = try populateFields(
                    ct.deneb.BeaconState,
                    ct.electra.BeaconState,
                    state.base_view.allocator,
                    state.base_view.pool,
                    state,
                ),
            },
            .electra => |state| .{
                .fulu = try populateFields(
                    ct.electra.BeaconState,
                    ct.fulu.BeaconState,
                    state.base_view.allocator,
                    state.base_view.pool,
                    state,
                ),
            },
            .fulu => error.InvalidAtFork,
        };
    }
};

test "electra - sanity" {
    const allocator = std.testing.allocator;
    var pool = try Node.Pool.init(allocator, 500_000);
    defer pool.deinit();

    const beacon_state = try BeaconState.fromValue(allocator, &pool, .electra, &ct.electra.BeaconState.default_value);
    defer beacon_state.deinit();

    try beacon_state.setSlot(12345);

    try std.testing.expect(beacon_state.genesisTime() == 0);
    try std.testing.expectEqualSlices(u8, &[_]u8{0} ** 32, &beacon_state.genesisValidatorsRoot());
    try std.testing.expect(beacon_state.slot() == 12345);
    try beacon_state.setSlot(2025);
    try std.testing.expect(beacon_state.slot() == 2025);

    const out: *const [32]u8 = try beacon_state.hashTreeRoot();
    try expect(!std.mem.eql(u8, &[_]u8{0} ** 32, &out));

    // TODO: more tests
}

test "clone - sanity" {
    const allocator = std.testing.allocator;
    var pool = try Node.Pool.init(allocator, 500_000);
    defer pool.deinit();

    const beacon_state = try BeaconState.fromValue(allocator, &pool, .electra, &ct.electra.BeaconState.default_value);
    defer beacon_state.deinit();

    try beacon_state.setSlot(12345);

    // test the clone() and deinit() works fine without memory leak
    const cloned_state = try beacon_state.clone(.{});
    defer cloned_state.deinit();

    try expect(cloned_state.slot() == 12345);
}

test "upgrade state - sanity" {
    const allocator = std.testing.allocator;
    var pool = try Node.Pool.init(allocator, 500_000);
    defer pool.deinit();

    const phase0_state = try BeaconState.fromValue(allocator, &pool, .phase0, &ct.phase0.BeaconState.default_value);
    defer phase0_state.deinit();

    const altair_state = try phase0_state.upgradeUnsafe();
    defer altair_state.deinit();
    try expect(altair_state.forkSeq() == .altair);

    const bellatrix_state = try altair_state.upgradeUnsafe();
    defer bellatrix_state.deinit();
    try expect(bellatrix_state.forkSeq() == .bellatrix);

    const capella_state = try bellatrix_state.upgradeUnsafe();
    defer capella_state.deinit();
    try expect(capella_state.forkSeq() == .capella);

    const deneb_state = try capella_state.upgradeUnsafe();
    defer deneb_state.deinit();
    try expect(deneb_state.forkSeq() == .deneb);

    const electra_state = try deneb_state.upgradeUnsafe();
    defer electra_state.deinit();
    try expect(electra_state.forkSeq() == .electra);

    const fulu_state = try electra_state.upgradeUnsafe();
    defer fulu_state.deinit();
    try expect(fulu_state.forkSeq() == .fulu);
}
