import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SynchronizeDialog extends HookWidget {
  const SynchronizeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> loadingState = useState(false);
    final double titleHeight =
        Theme.of(context).textTheme.headline6.scaledFontSize(context);

    return AlertDialog(
      title: Row(children: <Widget>[
        const Expanded(
          child: Text('Synchronize'),
        ),
        if (loadingState.value)
          Center(
            child: SizedBox(
              width: titleHeight,
              height: titleHeight,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ]),
      content: const Text(
        'Glider sends favorites and upvotes to your Hacker News account, '
        'but it is not aware of actions performed in other interfaces, '
        'such as the official website or alternative apps.\n\n'
        'The synchronization feature attempts to keep data consistent '
        'by treating the server data as the source of truth.\n\n'
        'Any favorites added in the app before logging in will be lost.\n\n'
        'Do you want to synchronize now?',
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
    final AuthRepository authRepository = context.read(authRepositoryProvider);
    final bool success = await authRepository.fetchFavorited(
          onUpdate: (int id) => context.refresh(favoritedProvider(id)),
        ) &&
        await authRepository.fetchUpvoted(
          onUpdate: (int id) => context.refresh(upvotedProvider(id)),
        );

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(
          content: Text('Favorites and upvotes have been synchronized'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
