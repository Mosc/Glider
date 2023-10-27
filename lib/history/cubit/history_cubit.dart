import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'history_state.dart';

class HistoryCubit extends HydratedCubit<HistoryState> {
  HistoryCubit(this._itemInteractionRepository) : super(const HistoryState()) {
    _historySubscription = _itemInteractionRepository.visitedStream.listen(
      (itemIds) => safeEmit(
        state.copyWith(
          status: () => Status.success,
          data: () => itemIds,
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
    );
  }

  final ItemInteractionRepository _itemInteractionRepository;

  late final StreamSubscription<Map<int, DateTime?>> _historySubscription;

  Future<void> load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );
    await _itemInteractionRepository.getVisitedItems();
  }

  @override
  HistoryState? fromJson(Map<String, dynamic> json) =>
      HistoryState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(HistoryState state) =>
      state.status == Status.success ? state.toJson() : null;

  @override
  Future<void> close() async {
    await _historySubscription.cancel();
    return super.close();
  }
}
