import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SynchronizeDialog extends HookWidget {
  const SynchronizeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final ValueNotifier<bool> loadingState = useState(false);
    final double? titleHeight =
        Theme.of(context).textTheme.headline6?.scaledFontSize(context);

    return AlertDialog(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(appLocalizations.synchronize),
          ),
          if (loadingState.value)
            Center(
              child: SizedBox(
                width: titleHeight,
                height: titleHeight,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      content: Text(
        appLocalizations.synchronizeDescriptionLong(appLocalizations.appName),
      ),
      actions: <Widget>[
        TextButton(
          onPressed:
              loadingState.value ? null : () => Navigator.of(context).pop(),
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
            textAlign: TextAlign.end,
          ),
        ),
        TextButton(
          onPressed: loadingState.value
              ? null
              : () async {
                  loadingState.value = true;
                  await _synchronize(context);
                  loadingState.value = false;
                },
          child: Text(
            MaterialLocalizations.of(context).okButtonLabel,
            textAlign: TextAlign.end,
          ),
        ),
      ],
      scrollable: true,
    );
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

    if (success) {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: Text(appLocalizations.synchronizeSuccess),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: Text(appLocalizations.synchronizeError),
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
