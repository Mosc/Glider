import 'package:equatable/equatable.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'inbox_state.dart';

class InboxCubit extends HydratedCubit<InboxState> {
  InboxCubit(this._itemRepository, this._authRepository)
      : super(const InboxState());

  final ItemRepository _itemRepository;
  final AuthRepository _authRepository;

  Future<void> load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );

    try {
      final (username, _) = await _authRepository.getUserAuth();
      final items = await _itemRepository.getUserReplies(username!);
      safeEmit(
        state.copyWith(
          status: () => Status.success,
          data: () => items
              .where((e) => e.parentId != null)
              .map((e) => (e.parentId!, e.id))
              .toList(growable: false),
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

  @override
  InboxState? fromJson(Map<String, dynamic> json) => InboxState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(InboxState state) =>
      state.status == Status.success ? state.toMap() : null;
}
