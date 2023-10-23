import 'package:flutter/material.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_value.dart';
import 'package:go_router/go_router.dart';

class UserValueDialog extends StatefulWidget {
  const UserValueDialog(
    this._userCubitFactory,
    this._authCubit, {
    required this.username,
    this.title,
    super.key,
  });

  final UserCubitFactory _userCubitFactory;
  final AuthCubit _authCubit;
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
    return SimpleDialog(
      title: widget.title != null ? Text(widget.title!) : null,
      children: [
        for (final value in UserValue.values)
          if (value.isVisible(_userCubit.state, widget._authCubit.state))
            ListTile(
              leading: Icon(value.icon),
              title: Text(value.label(context)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              onTap: () => context.pop(value),
            ),
      ],
    );
  }
}
