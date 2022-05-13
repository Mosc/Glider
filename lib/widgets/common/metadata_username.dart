import 'package:flutter/material.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/avatar.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MetadataUsername extends HookConsumerWidget {
  const MetadataUsername({super.key, required this.by, this.rootBy});

  final String by;
  final String? rootBy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool byLoggedInUser = by == ref.watch(usernameProvider).value;
    final bool byRoot = by == rootBy;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UserPage(id: by),
        ),
      ),
      child: Row(
        children: <Widget>[
          SmoothAnimatedSwitcher.horizontal(
            condition: ref.watch(showAvatarProvider).value ?? false,
            child: Row(
              children: <Widget>[
                Avatar(by: by),
                const SizedBox(width: 6),
              ],
            ),
          ),
          if (byLoggedInUser || byRoot)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: byLoggedInUser ? colorScheme.primary : null,
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                by,
                style: textTheme.bodySmall?.copyWith(
                  color: byLoggedInUser
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                by,
                style:
                    textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}
