import 'package:flutter/material.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/interfaces/menu_item.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_value.dart';
import 'package:go_router/go_router.dart';

enum UserAction<T extends MenuItem<S>, S> implements MenuItem<UserState> {
  block,
  select,
  copy(options: UserValue.values),
  share(options: UserValue.values),
  logout;

  const UserAction({this.options});

  final List<T>? options;

  @override
  bool isVisible(
    UserState state,
    AuthState authState,
    SettingsState settingsState,
  ) {
    final user = state.data;
    if (user == null) return false;
    return switch (this) {
      UserAction.block => user.username != authState.username,
      UserAction.select => user.about != null,
      UserAction.copy || UserAction.share => true,
      UserAction.logout => user.username == authState.username,
    };
  }

  @override
  String label(BuildContext context, UserState state) {
    return switch (this) {
      UserAction.block =>
        state.blocked ? context.l10n.unblock : context.l10n.block,
      UserAction.select => context.l10n.select,
      UserAction.copy => context.l10n.copy,
      UserAction.share => context.l10n.share,
      UserAction.logout => context.l10n.logout,
    };
  }

  @override
  IconData icon(
    UserState state,
  ) {
    return switch (this) {
      UserAction.block =>
        state.blocked ? Icons.healing_outlined : Icons.block_outlined,
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
        if (!userCubit.state.blocked) {
          final confirm =
              await context.push<bool>(AppRoute.confirmDialog.location());
          if (confirm ?? false) await userCubit.block(true);
        } else {
          await userCubit.block(false);
        }
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
              extra: context.l10n.copy,
            );

        if (valueAction != null) {
          await userCubit.copy(valueAction.value(userCubit)!);
        }
      case UserAction.share:
        final valueAction = option as UserValue? ??
            await context.push(
              AppRoute.userValueDialog
                  .location(parameters: {'id': userCubit.username}),
              extra: context.l10n.share,
            );

        if (valueAction != null) {
          await userCubit.share(
            valueAction.value(userCubit)!,
            subject: valueAction != UserValue.username
                ? UserValue.username.value(userCubit)
                : null,
          );
        }
      case UserAction.logout:
        await authCubit.logout();
    }
  }
}
