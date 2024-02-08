import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';

part 'wallabag_duplicate_state.dart';

class WallabagDuplicateCubit extends Cubit<WallabagDuplicateState> {
  WallabagDuplicateCubit(this._wallabagCubit, this.articleUri)
      : super(WallabagDuplicateState());

  final WallabagCubit _wallabagCubit;
  final Uri articleUri;

  Future<void> load() async {
    safeEmit(WallabagDuplicateState(status: Status.loading));

    final service = (_wallabagCubit.state.status == Status.success &&
            _wallabagCubit.state.data != null)
        ? _wallabagCubit.state.data
        : await _wallabagCubit.validate();

    if (service != null) {
      try {
        final exists = await service.entryExists(articleUri);
        safeEmit(
          state.copyWith(data: () => exists, status: () => Status.success),
        );
      } on Object catch (exception) {
        safeEmit(
          state.copyWith(
            status: () => Status.failure,
            exception: () => exception,
          ),
        );
      }
    } else {
      safeEmit(
        state.copyWith(
          status: () => Status.failure,
          exception: () => _wallabagCubit.state.exception,
        ),
      );
    }
  }
}
