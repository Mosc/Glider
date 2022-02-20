import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/user.dart';
import 'package:glider/models/user_menu_action.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/menu_actions_bar.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

StateProviderFamily<bool, String> _longPressStateProvider =
    StateProvider.family(
  (StateProviderRef<bool> ref, String id) => false,
);

class UserTileData extends HookConsumerWidget {
  const UserTileData(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onLongPress: () => ref
          .read(_longPressStateProvider(user.id).state)
          .update((bool state) => !state),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    MetadataItem(
                      icon: FluentIcons.arrow_up_24_regular,
                      text: user.karma.toString(),
                    ),
                    MetadataItem(
                      icon: FluentIcons.comment_24_regular,
                      text: user.submitted.length.toString(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text(
                        user.id,
                        style: textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Spacer(),
                    Text(
                      AppLocalizations.of(context).sinceDate(user.createdDate),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                if (user.about != null) ...<Widget>[
                  const SizedBox(height: 12),
                  DecoratedHtml(user.about!),
                ],
              ],
            ),
          ),
          SmoothAnimatedSwitcher.vertical(
            condition: ref.watch(_longPressStateProvider(user.id)),
            child: MenuActionsBar(
              children: <IconButton>[
                for (UserMenuAction menuAction in UserMenuAction.values)
                  IconButton(
                    icon: Icon(menuAction.icon(context)),
                    tooltip: menuAction.title(context),
                    onPressed: () =>
                        menuAction.command(context, ref, id: user.id).execute(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
