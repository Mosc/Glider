import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/validators.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedOut extends HookConsumerWidget {
  const AccountLoggedOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Column(
                children: <Widget>[
                  DecoratedHtml(
                    appLocalizations.legalHtml,
                    textStyle: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 16),
                  Row(
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
                                    ref,
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
                                    ref,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context, WidgetRef ref,
      {required String username, required String password}) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success =
        await authRepository.register(username: username, password: password);

    if (success) {
      ref
        ..refresh(usernameProvider)
        ..refresh(loggedInProvider);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(appLocalizations.registerError)),
      );
    }
  }

  Future<void> _login(BuildContext context, WidgetRef ref,
      {required String username,
      required String password,
      required bool synchronize}) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success =
        await authRepository.login(username: username, password: password);

    if (success) {
      if (synchronize) {
        await _synchronize(context, ref);
      }

      ref
        ..refresh(usernameProvider)
        ..refresh(loggedInProvider);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(appLocalizations.logInError)),
      );
    }
  }

  Future<void> _synchronize(BuildContext context, WidgetRef ref) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success = await authRepository.fetchUpvoted(
          onUpdate: (int id) => ref.refresh(upvotedProvider(id)),
        ) &&
        await authRepository.fetchFavorited(
          onUpdate: (int id) => ref.refresh(favoritedProvider(id)),
        );

    if (!success) {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(appLocalizations.synchronizeError),
        ),
      );
    }
  }
}
