import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/account/account_body.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<List<Widget>> actionsStateProvider =
    StateProvider.autoDispose<List<Widget>>(
        (ProviderReference ref) => <Widget>[]);

class AccountPage extends HookWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StateController<List<Widget>> actionsStateController =
        useProvider(actionsStateProvider);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: const Text('Account'),
            actions: actionsStateController.state,
            forceElevated: innerBoxIsScrolled,
            floating: true,
          ),
        ],
        body: const AccountBody(),
      ),
    );
  }
}
