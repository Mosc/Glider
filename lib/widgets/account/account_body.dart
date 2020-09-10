import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/auth_provider.dart';
import 'package:glider/widgets/account/account_logged_in.dart';
import 'package:glider/widgets/account/account_logged_out.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountBody extends HookWidget {
  const AccountBody(this.actionsNotifier, {Key key}) : super(key: key);

  final ValueNotifier<List<Widget>> actionsNotifier;

  @override
  Widget build(BuildContext context) {
    return useProvider(loggedInProvider).when(
      loading: () => const Loading(),
      error: (_, __) => const Error(),
      data: (bool loggedIn) => loggedIn
          ? AccountLoggedIn(actionsNotifier)
          : AccountLoggedOut(actionsNotifier),
    );
  }
}
