import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'favorites_state.dart';

class FavoritesCubit extends HydratedCubit<FavoritesState> {
  FavoritesCubit(this._itemInteractionRepository)
      : super(const FavoritesState()) {
    _favoriteIdsSubscription =
        _itemInteractionRepository.favoritedStream.listen(
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

  late final StreamSubscription<List<int>> _favoriteIdsSubscription;

  Future<void> load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );
    await _itemInteractionRepository.getFavoritedIds();
  }

  @override
  FavoritesState? fromJson(Map<String, dynamic> json) =>
      FavoritesState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(FavoritesState state) =>
      state.status == Status.success ? state.toJson() : null;

  @override
  Future<void> close() async {
    await _favoriteIdsSubscription.cancel();
    return super.close();
  }
}
