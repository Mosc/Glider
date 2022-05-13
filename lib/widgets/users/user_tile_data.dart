import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/user.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/metadata_username.dart';
import 'package:glider/widgets/users/user_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserTileData extends HookConsumerWidget {
  const UserTileData(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onLongPress: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => UserBottomSheet(id: user.id),
      ),
      child: Padding(
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
                MetadataUsername(by: user.id),
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
    );
  }
}
