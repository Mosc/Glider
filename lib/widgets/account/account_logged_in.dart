import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/auth_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/users/user_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedIn extends HookWidget {
  const AccountLoggedIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We can't set this during initial build, so delay execution by one frame.
    Future<void>.microtask(
      () => context.read(actionsStateProvider).state = <Widget>[
        IconButton(
          icon: const Icon(FluentIcons.sign_out_24_filled),
          tooltip: 'Log out',
          onPressed: () async {
            await context.read(authRepositoryProvider).logout();
            await context.refresh(loggedInProvider);
          },
        ),
      ],
    );

    return useProvider(usernameProvider).when(
      loading: () => const Loading(),
      error: (_, __) => const Error(),
      data: (String username) => UserBody(id: username),
    );
  }
}
