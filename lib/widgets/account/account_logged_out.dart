import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/utils/validators.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

class AccountLoggedOut extends HookWidget {
  const AccountLoggedOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey());
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final ValueNotifier<bool> synchronizeState = useState(false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSynchronizationInfo(context),
              const SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: Validators.notEmpty,
                autofocus: true,
                enabled: !loadingState.value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: Validators.notEmpty,
                enabled: !loadingState.value,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    value: synchronizeState.value,
                    onChanged: loadingState.value
                        ? null
                        : (_) =>
                            synchronizeState.value = !synchronizeState.value,
                  ),
                  GestureDetector(
                    onTap: loadingState.value
                        ? null
                        : () =>
                            synchronizeState.value = !synchronizeState.value,
                    child: const Text('Synchronize'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: loadingState.value
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() == true) {
                              loadingState.value = true;
                              await _register(
                                context,
                                username: usernameController.text,
                                password: passwordController.text,
                              );
                              loadingState.value = false;
                            }
                          },
                    child: const Text('Register'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: loadingState.value
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() == true) {
                              loadingState.value = true;
                              await _login(
                                context,
                                username: usernameController.text,
                                password: passwordController.text,
                                synchronize: synchronizeState.value,
                              );
                              loadingState.value = false;
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

  Block _buildSynchronizationInfo(BuildContext context) {
    return Block(
      child: Row(
        children: <Widget>[
          Icon(
            FluentIcons.info_24_regular,
            size:
                Theme.of(context).textTheme.bodyText2?.scaledFontSize(context),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Synchronize fetches all your favorites and upvotes from '
              'the Hacker News server. '
              'Any favorites added in the app before logging in will be lost.',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register(BuildContext context,
      {required String username, required String password}) async {
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
      {required String username,
      required String password,
      required bool synchronize}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success =
        await authRepository.login(username: username, password: password);

    if (success) {
      if (synchronize) {
        await _synchronize(context);
      }

      unawaited(context.refresh(usernameProvider));
      unawaited(context.refresh(loggedInProvider));
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(content: Text('Logging in failed')),
      );
    }
  }

  Future<void> _synchronize(BuildContext context) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success = await authRepository.fetchFavorited(
          onUpdate: (int id) => context.refresh(favoritedProvider(id)),
        ) &&
        await authRepository.fetchUpvoted(
          onUpdate: (int id) => context.refresh(upvotedProvider(id)),
        );

    if (success != true) {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(
          content: Text('Synchronization failed'),
        ),
      );
    }
  }
}
