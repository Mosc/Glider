import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/router/app_router.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_style.dart';
import 'package:glider/user/typedefs/user_typedefs.dart';
import 'package:glider/user/widgets/user_bottom_sheet.dart';
import 'package:glider/user/widgets/user_data_tile.dart';
import 'package:glider/user/widgets/user_loading_tile.dart';

class UserTile extends StatelessWidget {
  const UserTile(
    this._userCubit,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    this.style = UserStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
  });

  final UserCubit _userCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final UserStyle style;
  final EdgeInsets padding;
  final UserCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<UserCubit, UserCubitEvent>(
      bloc: _userCubit,
      listener: (context, event) => switch (event) {
        UserActionFailedEvent() => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.failure),
            ),
          ),
      },
      child: BlocBuilder<UserCubit, UserState>(
        bloc: _userCubit,
        builder: (context, state) => state.whenOrDefaultWidgets(
          loading: () => UserLoadingTile(
            style: style,
            padding: padding,
          ),
          success: () {
            final user = state.data!;
            return UserDataTile(
              user,
              parsedAbout: state.parsedAbout,
              blocked: state.blocked,
              style: style,
              padding: padding,
              onTap: onTap,
              onLongPress: (context, item) async => showModalBottomSheet(
                context: rootNavigatorKey.currentContext!,
                builder: (context) => UserBottomSheet(
                  _userCubit,
                  _authCubit,
                  _settingsCubit,
                ),
              ),
            );
          },
          onRetry: () async => _userCubit.load(),
        ),
      ),
    );
  }
}
