import 'package:flutter/material.dart';
import 'package:glider/models/user_tag.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/avatar.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/common/tag.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MetadataUsername extends HookConsumerWidget {
  const MetadataUsername({
    super.key,
    required this.by,
    this.rootBy,
    this.tappable = true,
  });

  final String by;
  final String? rootBy;
  final bool tappable;

  static const Map<String, UserTag> usernameTags = <String, UserTag>{
    'tlb': UserTag.founder,
    'pg': UserTag.founder,
    'jl': UserTag.founder,
    'rtm': UserTag.founder,
    'garry': UserTag.ceo,
    'dang': UserTag.moderator,
    'sctb': UserTag.exModerator,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool byLoggedInUser = by == ref.watch(usernameProvider).value;
    final bool byRoot = by == rootBy;

    return GestureDetector(
      onTap: tappable
          ? () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UserPage(id: by),
                ),
              )
          : null,
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
          if (byLoggedInUser)
            Tag(
              text: by,
              color: colorScheme.onPrimary,
              backgroundColor: colorScheme.primary,
            )
          else if (byRoot)
            Tag(
              text: by,
              color: colorScheme.primary,
              borderColor: colorScheme.primary,
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                by,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          if (usernameTags.containsKey(by)) ...<Widget>[
            const SizedBox(width: 6),
            Tag(
              text: usernameTags[by]!.title(context),
              color: colorScheme.onSurface,
              backgroundColor: colorScheme.surface,
            ),
          ],
        ],
      ),
    );
  }
}
