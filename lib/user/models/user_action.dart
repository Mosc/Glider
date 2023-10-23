import 'package:flutter/material.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/interfaces/menu_item.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_value.dart';
import 'package:go_router/go_router.dart';

enum UserAction<T extends MenuItem<S>, S> implements MenuItem<UserState> {
  block,
  unblock,
  select,
  copy(options: UserValue.values),
  share(options: UserValue.values),
  logout;

  const UserAction({this.options});

  final List<T>? options;

  @override
  bool isVisible(UserState state, AuthState authState) {
    final user = state.data;
    if (user == null) return false;
    return switch (this) {
      UserAction.block => !state.blocked && user.username != authState.username,
      UserAction.unblock =>
        state.blocked && user.username != authState.username,
      UserAction.select => user.about != null,
      UserAction.copy => true,
      UserAction.share => true,
      UserAction.logout => user.username == authState.username,
    };
  }

  @override
  String label(BuildContext context) {
    return switch (this) {
      UserAction.block => context.l10n.block,
      UserAction.unblock => context.l10n.unblock,
      UserAction.select => context.l10n.select,
      UserAction.copy => context.l10n.copy,
      UserAction.share => context.l10n.share,
      UserAction.logout => context.l10n.logout,
    };
  }

  @override
  IconData get icon {
    return switch (this) {
      UserAction.block => Icons.block_outlined,
      UserAction.unblock => Icons.healing_outlined,
      UserAction.select => Icons.select_all_outlined,
      UserAction.copy => Icons.copy_outlined,
      UserAction.share => Icons.adaptive.share_outlined,
      UserAction.logout => Icons.logout_outlined,
    };
  }

  Future<void> execute(
    BuildContext context,
    UserCubit userCubit,
    AuthCubit authCubit, {
    T? option,
  }) async {
    switch (this) {
      case UserAction.block:
        final confirm =
            await context.push<bool>(AppRoute.confirmDialog.location());
        if (confirm ?? false) await userCubit.block(true);
      case UserAction.unblock:
        await userCubit.block(false);
      case UserAction.select:
        await context.push(
          AppRoute.textSelectDialog.location(),
          extra: userCubit.state.data!.about,
        );
      case UserAction.copy:
        final valueAction = option as UserValue? ??
            await context.push(
              AppRoute.userValueDialog
                  .location(parameters: {'id': userCubit.username}),
              extra: (userCubit.username, context.l10n.copy),
            );

        if (valueAction != null) {
          await userCubit.copy(valueAction.value(userCubit)!);
        }
      case UserAction.share:
        final valueAction = option as UserValue? ??
            await context.push(
              AppRoute.userValueDialog
                  .location(parameters: {'id': userCubit.username}),
              extra: (userCubit.username, context.l10n.share),
            );

        if (valueAction != null) {
          await userCubit.share(valueAction.value(userCubit)!);
        }
      case UserAction.logout:
        await authCubit.logout();
    }
  }
}
