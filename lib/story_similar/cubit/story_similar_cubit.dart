import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'story_similar_state.dart';

class StorySimilarCubit extends HydratedCubit<StorySimilarState> {
  StorySimilarCubit(this._itemRepository, {required int id})
      : itemId = id,
        super(const StorySimilarState()) {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );
    _itemSubscription = _itemRepository.getItemStream(itemId).listen(
      (item) async {
        if (item.url != state.item?.url) {
          safeEmit(
            state.copyWith(item: () => item),
          );

          await _load();
        }
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object exception) => safeEmit(
        state.copyWith(
          status: () => Status.failure,
          exception: () => exception,
        ),
      ),
    );
  }

  final ItemRepository _itemRepository;
  final int itemId;

  late final StreamSubscription<Item> _itemSubscription;

  @override
  String get id => itemId.toString();

  Future<void> _load() async {
    if (state.item?.url case final url?) {
      try {
        final similarStories = await _itemRepository.getSimilarStories(
          itemId,
          url: url.toString(),
        );
        safeEmit(
          state.copyWith(
            status: () => Status.success,
            data: () =>
                similarStories.map((item) => item.id).toList(growable: false),
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

  @override
  StorySimilarState? fromJson(Map<String, dynamic> json) =>
      StorySimilarState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(StorySimilarState state) =>
      state.status == Status.success ? state.toMap() : null;

  @override
  Future<void> close() {
    _itemSubscription.cancel();
    return super.close();
  }
}
