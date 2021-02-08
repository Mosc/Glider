import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/account/account_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<bool> loggedIn = useProvider(loggedInProvider);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: const Text('Account'),
            actions: loggedIn.data?.value == true
                ? <Widget>[
                    IconButton(
                      icon: const Icon(FluentIcons.sign_out_24_filled),
                      tooltip: 'Log out',
                      onPressed: () async {
                        await context.read(authRepositoryProvider).logout();
                        unawaited(context.refresh(loggedInProvider));
                        unawaited(context.refresh(usernameProvider));
                      },
                    ),
                  ]
                : null,
            forceElevated: innerBoxIsScrolled,
            floating: true,
            backwardsCompatibility: false,
          ),
        ],
        body: const AccountBody(),
      ),
    );
  }
}
