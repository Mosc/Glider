import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

class AccountLoggedOut extends HookWidget {
  const AccountLoggedOut({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We can't set this during initial build, so delay execution by one frame.
    Future<void>.microtask(
      () => context.read(actionsStateProvider).state = <Widget>[],
    );

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await _register(
                          context,
                          username: usernameController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await _login(
                          context,
                          username: usernameController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context,
      {@required String username, @required String password}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    final bool success =
        await authRepository.register(username: username, password: password);

    if (success) {
      unawaited(context.refresh(usernameProvider));
      unawaited(context.refresh(loggedInProvider));
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(content: Text('Registering failed')),
      );
    }
  }

  Future<void> _login(BuildContext context,
      {@required String username, @required String password}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    final bool success =
        await authRepository.login(username: username, password: password);

    if (success) {
      unawaited(context.refresh(usernameProvider));
      unawaited(context.refresh(loggedInProvider));
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(content: Text('Logging in failed')),
      );
    }
  }
}
