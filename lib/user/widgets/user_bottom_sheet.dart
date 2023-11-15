import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_action.dart';
import 'package:go_router/go_router.dart';

class UserBottomSheet extends StatefulWidget {
  const UserBottomSheet(
    this._userCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    required this.username,
  });

  final UserCubitFactory _userCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final String username;

  @override
  State<UserBottomSheet> createState() => _UserBottomSheetState();
}

class _UserBottomSheetState extends State<UserBottomSheet> {
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
          builder: (context, settingsState) => ListView(
            primary: false,
            shrinkWrap: true,
            children: [
              for (final action in UserAction.values)
                if (action.isVisible(state, authState, settingsState))
                  ListTile(
                    leading: Icon(action.icon(state)),
                    title: Text(action.label(context, state)),
                    onTap: () async {
                      context.pop();
                      await action.execute(
                        context,
                        _userCubit,
                        widget._authCubit,
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
