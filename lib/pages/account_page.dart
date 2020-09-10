import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/widgets/account/account_body.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<Widget>> actionsNotifier = useState(<Widget>[]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: actionsNotifier.value,
      ),
      body: AccountBody(actionsNotifier),
    );
  }
}
