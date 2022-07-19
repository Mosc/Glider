import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SynchronizeDialog extends HookConsumerWidget {
  const SynchronizeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loadingState = useState(false);
    final double? titleHeight =
        Theme.of(context).textTheme.titleLarge?.scaledFontSize(context);

    return AlertDialog(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(AppLocalizations.of(context).synchronize),
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
        AppLocalizations.of(context).synchronizeDescriptionLong(
          AppLocalizations.of(context).appName,
        ),
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
                  await _synchronize(context, ref);
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

  Future<void> _synchronize(BuildContext context, WidgetRef ref) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final bool success = await authRepository.fetchUpvoted(
          onUpdate: (int id) => ref.invalidate(upvotedProvider(id)),
        ) &&
        await authRepository.fetchFavorited(
          onUpdate: (int id) => ref.invalidate(favoritedProvider(id)),
        );

    if (success) {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).synchronizeSuccess),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).synchronizeError),
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
