import 'package:flutter/material.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_uris.dart';
import 'package:glider/common/interfaces/menu_item.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';

enum UserValue implements MenuItem<UserState> {
  username,
  about,
  userLink;

  @override
  bool isVisible(
    UserState state,
    AuthState authState,
    SettingsState settingsState,
  ) {
    final user = state.data;
    if (user == null) return false;
    return switch (this) {
      UserValue.username => true,
      UserValue.about => user.about != null,
      UserValue.userLink => true,
    };
  }

  @override
  String label(BuildContext context, UserState state) {
    return switch (this) {
      UserValue.username => context.l10n.username,
      UserValue.about => context.l10n.about,
      UserValue.userLink => context.l10n.userLink,
    };
  }

  @override
  IconData icon(UserState state) {
    return switch (this) {
      UserValue.username => Icons.person_outline_outlined,
      UserValue.about => Icons.notes_outlined,
      UserValue.userLink => Icons.account_circle_outlined,
    };
  }

  String? value(UserCubit userCubit) {
    final user = userCubit.state.data;
    return switch (this) {
      UserValue.username => userCubit.username,
      UserValue.about => user?.about,
      UserValue.userLink => AppUris.hackerNewsUri.replace(
          path: 'user',
          queryParameters: <String, String>{
            'id': userCubit.username,
          },
        ).toString(),
    };
  }
}
