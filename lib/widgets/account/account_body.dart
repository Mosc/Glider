import 'package:flutter/widgets.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/account/account_logged_in.dart';
import 'package:glider/widgets/account/account_logged_out.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountBody extends HookConsumerWidget {
  const AccountBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(loggedInProvider).when(
          data: _accountDataBuilder,
          loading: () => const Loading(),
          error: (_, __) => const Error(),
        );
  }

  Widget _accountDataBuilder(bool loggedIn) =>
      loggedIn ? const AccountLoggedIn() : const AccountLoggedOut();
}
