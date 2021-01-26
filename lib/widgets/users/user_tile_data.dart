import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glider/models/user.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:share/share.dart';

class UserTileData extends StatelessWidget {
  const UserTileData(this.user, {Key key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onLongPress: () => _buildModalBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (user.karma != null)
                  MetadataItem(
                    icon: FluentIcons.arrow_up_24_regular,
                    text: user.karma.toString(),
                  ),
                if (user.submitted != null)
                  MetadataItem(
                    icon: FluentIcons.comment_24_regular,
                    text: user.submitted.length.toString(),
                  ),
                if (user.id != null) ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      user.id,
                      style: textTheme.caption.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Spacer(),
                Text(
                  'since ${user.createdDate}',
                  style: textTheme.caption,
                ),
              ],
            ),
            if (user.about != null) ...<Widget>[
              const SizedBox(height: 12),
              DecoratedHtml(user.about),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _buildModalBottomSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => Wrap(
        children: <Widget>[
          if (user.about != null)
            ListTile(
              title: const Text('Copy text'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: user.about));
                ScaffoldMessenger.of(context).showSnackBarQuickly(
                  const SnackBar(content: Text('Text has been copied')),
                );
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            title: const Text('Share user link'),
            onTap: () async {
              await Share.share(
                Uri.https(
                  WebsiteRepository.authority,
                  'user',
                  <String, String>{'id': user.id},
                ).toString(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
