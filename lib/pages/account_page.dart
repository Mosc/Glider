import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/account/account_body.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/src/framework.dart';

final AutoDisposeStateProvider<List<Widget>> actionsStateProvider =
    StateProvider.autoDispose<List<Widget>>(
        (AutoDisposeProviderReference ref) => <Widget>[]);

class AccountPage extends HookWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarUtil.buildFluentIconsLeading(context),
        title: const Text('Account'),
        actions: useProvider(actionsStateProvider).state,
      ),
      body: const AccountBody(),
    );
  }
}
