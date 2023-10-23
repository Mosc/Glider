import 'package:flutter/material.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_action.dart';
import 'package:go_router/go_router.dart';

class UserBottomSheet extends StatefulWidget {
  const UserBottomSheet(
    this._userCubitFactory,
    this._authCubit, {
    super.key,
    required this.username,
  });

  final UserCubitFactory _userCubitFactory;
  final AuthCubit _authCubit;
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
    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        for (final action in UserAction.values)
          if (action.isVisible(_userCubit.state, widget._authCubit.state))
            ListTile(
              leading: Icon(action.icon),
              title: Text(action.label(context)),
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
    );
  }
}
