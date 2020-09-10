import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/auth_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedOut extends HookWidget {
  const AccountLoggedOut(this.actionsNotifier, {Key key}) : super(key: key);

  final ValueNotifier<List<Widget>> actionsNotifier;

  @override
  Widget build(BuildContext context) {
    useMemoized(
      () => Future<void>.microtask(() => actionsNotifier.value = <Widget>[]),
    );

    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    final AuthRepository authRepository = useProvider(authRepositoryProvider);

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
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Username must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Password must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        final String username = usernameController.text;
                        final String password = passwordController.text;

                        final bool success = await authRepository.register(
                          username: username,
                          password: password,
                        );

                        if (success) {
                          await context.refresh(loggedInProvider);
                        } else {
                          Scaffold.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registering failed'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(width: 16),
                  RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        final String username = usernameController.text;
                        final String password = passwordController.text;

                        final bool success = await authRepository.login(
                          username: username,
                          password: password,
                        );

                        if (success) {
                          await context.refresh(loggedInProvider);
                        } else {
                          Scaffold.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logging in failed'),
                            ),
                          );
                        }
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
}
