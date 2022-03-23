import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountLoggedOut extends HookConsumerWidget {
  const AccountLoggedOut({Key? key}) : super(key: key);

  static const int _usernameMinLength = 2;
  static const int _usernameMaxLength = 15;
  static const String _usernamePattern = r'^[A-Za-z0-9\-_]+$';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).username,
                    ),
                    maxLength: _usernameMaxLength,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    validator: FormBuilderValidators.compose(
                      <FormFieldValidator<String>>[
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(
                          context,
                          _usernameMinLength,
                        ),
                        FormBuilderValidators.maxLength(
                          context,
                          _usernameMaxLength,
                        ),
                        FormBuilderValidators.match(
                          context,
                          _usernamePattern,
                          errorText:
                              AppLocalizations.of(context).usernamePatternError,
                        ),
                      ],
                    ),
                    autofocus: true,
                    enabled: !loadingState.value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).password,
                    ),
                    validator: FormBuilderValidators.required(context),
                    enabled: !loadingState.value,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context).synchronize),
              subtitle:
                  Text(AppLocalizations.of(context).synchronizeDescription),
              dense: true,
              value: synchronizeState.value,
              onChanged: loadingState.value
                  ? null
                  : (_) => synchronizeState.value = !synchronizeState.value,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HtmlWidget(
                    AppLocalizations.of(context).legalHtml,
                    onTapUrl: (String url) =>
                        UrlUtil.tryLaunch(context, ref, url),
                    textStyle: Theme.of(context).textTheme.bodySmall,
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
                        child: Text(AppLocalizations.of(context).register),
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
                        child: Text(AppLocalizations.of(context).logIn),
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
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success =
        await authRepository.register(username: username, password: password);

    if (success) {
      ref
        ..invalidate(usernameProvider)
        ..invalidate(loggedInProvider);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).registerError)),
      );
    }
  }

  Future<void> _login(BuildContext context, WidgetRef ref,
      {required String username,
      required String password,
      required bool synchronize}) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success =
        await authRepository.login(username: username, password: password);

    if (success) {
      if (synchronize) {
        await _synchronize(context, ref);
      }

      ref
        ..invalidate(usernameProvider)
        ..invalidate(loggedInProvider);
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).logInError)),
      );
    }
  }

  Future<void> _synchronize(BuildContext context, WidgetRef ref) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success = await authRepository.fetchUpvoted(
          onUpdate: (int id) => ref.invalidate(upvotedProvider(id)),
        ) &&
        await authRepository.fetchFavorited(
          onUpdate: (int id) => ref.invalidate(favoritedProvider(id)),
        );

    if (!success) {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).synchronizeError),
        ),
      );
    }
  }
}
