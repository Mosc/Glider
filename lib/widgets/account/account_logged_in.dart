import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/users/user_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedIn extends HookWidget {
  const AccountLoggedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(usernameProvider).when(
      loading: () => const Loading(),
      error: (_, __) => const Error(),
      data: (String? username) =>
          username != null ? UserBody(id: username) : const Error(),
    );
  }
}
