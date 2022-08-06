import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreviewSection extends HookConsumerWidget {
  const PreviewSection({super.key});

  static const int _previewStoryId = -1 << 31;
  static const int _previewCommentId = _previewStoryId + 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            AppLocalizations.of(context).preview,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ItemTileData(
          Item(
            id: _previewStoryId,
            type: ItemType.story,
            by: 'this_user_does_not_exist',
            time: DateTime.now().secondsSinceEpoch,
            url: 'https://github.com/Mosc/Glider',
            score: 3154,
            title: 'Glider is an opinionated Hacker News client',
            descendants: 322,
            preview: true,
          ),
          dense: true,
        ),
        ItemTileData(
          Item(
            id: _previewCommentId,
            type: ItemType.comment,
            by: 'neither_does_this_user',
            time: DateTime.now().secondsSinceEpoch,
            text: "That's <i>awesome</i>.",
            indentation: 1,
            preview: true,
          ),
        ),
      ],
    );
  }
}
