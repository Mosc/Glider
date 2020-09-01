import 'package:flutter/material.dart';
import 'package:glider/models/user.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/tile_meta_data_item.dart';

class UserTileData extends StatelessWidget {
  const UserTileData(this.user, {Key key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (user.karma != null)
                TileMetaDataItem(
                  icon: Icons.favorite_outline,
                  text: user.karma.toString(),
                ),
              if (user.submitted != null)
                TileMetaDataItem(
                  icon: Icons.chat_bubble_outline,
                  text: user.submitted.length.toString(),
                ),
              if (user.id != null)
                TileMetaDataItem(
                  icon: Icons.person_outline,
                  text: user.id,
                ),
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
    );
  }
}
