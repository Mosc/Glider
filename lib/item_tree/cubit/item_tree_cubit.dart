import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'item_tree_state.dart';

class ItemTreeCubit extends HydratedCubit<ItemTreeState> {
  ItemTreeCubit(
    this._itemRepository, {
    required int id,
  })  : itemId = id,
        super(ItemTreeState());

  final ItemRepository _itemRepository;

  final int itemId;

  @override
  String get id => itemId.toString();

  Future<void> load() async {
    safeEmit(
      state.copyWith(
        status: () => Status.loading,
        visited: () => state.status != Status.initial,
      ),
    );
    final descendantsStream =
        _itemRepository.getFlatItemDescendantsStream(itemId);

    if (state.data == null || state.data!.isEmpty) {
      descendantsStream.listen(
        (descendants) => safeEmit(
          state.copyWith(
            status: () => Status.success,
            data: () => descendants,
            exception: () => null,
          ),
        ),
        // ignore: avoid_types_on_closure_parameters
        onError: (Object exception) => safeEmit(
          state.copyWith(
            status: () => Status.failure,
            exception: () => exception,
          ),
        ),
        onDone: () => safeEmit(
          state.copyWith(
            status: () => Status.success,
          ),
        ),
        cancelOnError: true,
      );
    } else {
      try {
        final descendants = await descendantsStream.last;
        safeEmit(
          state.copyWith(
            status: () => Status.success,
            data: () => descendants,
            previousData: () => state.data,
            exception: () => null,
          ),
        );
      } on Object catch (exception) {
        safeEmit(
          state.copyWith(
            status: () => Status.failure,
            exception: () => exception,
          ),
        );
      }
    }
  }

  void toggleCollapsed(int id) {
    safeEmit(
      state.copyWith(
        collapsedIds: () => state.collapsedIds.contains(id)
            ? {...state.collapsedIds.where((collapsedId) => collapsedId != id)}
            : {...state.collapsedIds, id},
      ),
    );
  }

  @override
  ItemTreeState? fromJson(Map<String, dynamic> json) =>
      ItemTreeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ItemTreeState state) =>
      state.status == Status.success ? state.toJson() : null;
}
