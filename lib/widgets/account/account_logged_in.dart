import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/auth_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/users/user_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedIn extends HookWidget {
  const AccountLoggedIn(this.actionsNotifier, {Key key}) : super(key: key);

  final ValueNotifier<List<Widget>> actionsNotifier;

  @override
  Widget build(BuildContext context) {
    useMemoized(
      () => Future<void>.microtask(() => actionsNotifier.value = <Widget>[
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await context.read(authRepositoryProvider).logout();
                  await context.refresh(loggedInProvider);
                }),
          ]),
    );

    return useProvider(usernameProvider).when(
      loading: () => const Loading(),
      error: (_, __) => const Error(),
      data: (String username) => UserBody(id: username),
    );
  }
}
