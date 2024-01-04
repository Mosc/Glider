import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:share_plus/share_plus.dart';

part 'user_cubit_event.dart';
part 'user_state.dart';

class UserCubit extends HydratedCubit<UserState>
    with BlocPresentationMixin<UserState, UserCubitEvent> {
  UserCubit(
    this._userRepository,
    this._userInteractionRepository,
    this._itemInteractionRepository, {
    required this.username,
  }) : super(const UserState()) {
    _userSubscription = _userRepository.getUserStream(username).listen(
          (user) => safeEmit(
            state.copyWith(
              status: () => Status.success,
              data: () => user,
              parsedAbout: () => switch (user.about) {
                final String about => HackerNewsText.parse(about),
                _ => null,
              },
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
    _synchronizingSubscription =
        _userInteractionRepository.synchronizingStream.listen(
      (synchronizing) => safeEmit(
        state.copyWith(synchronizing: () => synchronizing),
      ),
    );
  }

  final UserRepository _userRepository;
  final UserInteractionRepository _userInteractionRepository;
  final ItemInteractionRepository _itemInteractionRepository;
  final String username;

  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<bool> _synchronizingSubscription;

  @override
  String get id => username;

  Future<void> load() async {
    safeEmit(
      state.copyWith(status: () => Status.loading),
    );
    await _userRepository.getUser(username);
  }

  Future<void> block(bool block) async {
    final blocked = state.blocked;
    safeEmit(
      state.copyWith(blocked: () => block),
    );
    final success =
        await _userInteractionRepository.block(username, block: block);

    if (!success) {
      safeEmit(
        state.copyWith(blocked: () => blocked),
      );
      emitPresentation(const UserActionFailedEvent());
    }
  }

  Future<void> synchronize() async {
    final success = await _userInteractionRepository.synchronize();

    if (!success) {
      emitPresentation(const UserActionFailedEvent());
    } else {
      await _itemInteractionRepository.getUpvotedIds();
      await _itemInteractionRepository.getFavoritedIds();
      await _itemInteractionRepository.getFlaggedIds();
    }
  }

  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> share(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) => UserState.fromMap(json);

  @override
  Map<String, dynamic>? toJson(UserState state) =>
      state.status == Status.success ? state.toMap() : null;

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    await _synchronizingSubscription.cancel();
    return super.close();
  }
}
