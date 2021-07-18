import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/l10n/app_localizations.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

class AccountLoggedOut extends HookWidget {
  const AccountLoggedOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final ValueNotifier<bool> loadingState = useState(false);
    final GlobalKey<FormState> formKey = useMemoized(() => GlobalKey());
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final ValueNotifier<bool> synchronizeState = useState(false);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: usernameController,
                    decoration:
                        InputDecoration(labelText: appLocalizations.username),
                    validator: (String? value) =>
                        Validators.notEmpty(context, value),
                    autofocus: true,
                    enabled: !loadingState.value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration:
                        InputDecoration(labelText: appLocalizations.password),
                    validator: (String? value) =>
                        Validators.notEmpty(context, value),
                    enabled: !loadingState.value,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: Text(appLocalizations.synchronize),
              subtitle: Text(appLocalizations.synchronizeDescription),
              dense: true,
              value: synchronizeState.value,
              onChanged: loadingState.value
                  ? null
                  : (_) => synchronizeState.value = !synchronizeState.value,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: loadingState.value
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() ?? false) {
                              loadingState.value = true;
                              await _register(
                                context,
                                username: usernameController.text,
                                password: passwordController.text,
                              );
                              loadingState.value = false;
                            }
                          },
                    child: Text(appLocalizations.register),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: loadingState.value
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() ?? false) {
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
                    child: Text(appLocalizations.logIn),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context,
      {required String username, required String password}) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success =
        await authRepository.register(username: username, password: password);

    if (success) {
      unawaited(context.refresh(usernameProvider));
      unawaited(context.refresh(loggedInProvider));
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(content: Text(appLocalizations.registerError)),
      );
    }
  }

  Future<void> _login(BuildContext context,
      {required String username,
      required String password,
      required bool synchronize}) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

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
        SnackBar(content: Text(appLocalizations.logInError)),
      );
    }
  }

  Future<void> _synchronize(BuildContext context) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success = await authRepository.fetchUpvoted(
          onUpdate: (int id) => context.refresh(upvotedProvider(id)),
        ) &&
        await authRepository.fetchFavorited(
          onUpdate: (int id) => context.refresh(favoritedProvider(id)),
        );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: Text(appLocalizations.synchronizeError),
        ),
      );
    }
  }
}
