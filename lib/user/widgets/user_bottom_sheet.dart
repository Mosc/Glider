import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_action.dart';
import 'package:go_router/go_router.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet(
    this._userCubit,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final UserCubit _userCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: _authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: _settingsCubit,
          builder: (context, settingsState) => ListView(
            primary: false,
            shrinkWrap: true,
            children: [
              for (final action in UserAction.values)
                if (action.isVisible(state, authState, settingsState))
                  ListTile(
                    leading: Icon(action.icon(state)),
                    title: Text(action.label(context, state)),
                    trailing: action.options != null
                        ? const Icon(Icons.chevron_right)
                        : null,
                    onTap: () async {
                      context.pop();
                      await action.execute(
                        context,
                        _userCubit,
                        _authCubit,
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
