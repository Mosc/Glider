import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_value.dart';
import 'package:go_router/go_router.dart';

class UserValueDialog extends StatefulWidget {
  const UserValueDialog(
    this._userCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    required this.username,
    this.title,
    super.key,
  });

  final UserCubitFactory _userCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final String username;
  final String? title;

  @override
  State<UserValueDialog> createState() => _UserValueDialogState();
}

class _UserValueDialogState extends State<UserValueDialog> {
  late final UserCubit _userCubit;

  @override
  void initState() {
    _userCubit = widget._userCubitFactory(widget.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: widget._authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: widget._settingsCubit,
          builder: (context, settingsState) => SimpleDialog(
            title: widget.title != null ? Text(widget.title!) : null,
            children: [
              for (final value in UserValue.values)
                if (value.isVisible(state, authState, settingsState))
                  ListTile(
                    leading: Icon(value.icon(state)),
                    title: Text(value.label(context, state)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    onTap: () => context.pop(value),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
