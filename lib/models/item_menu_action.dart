import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/favorite_command.dart';
import 'package:glider/commands/item_options_command.dart';
import 'package:glider/commands/reply_command.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ItemMenuAction {
  vote,
  reply,
  favorite,
  copy,
  share,
}

extension ItemMenuActionExtension on ItemMenuAction {
  bool visible(BuildContext context, WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        if (ref.watch(upvotedProvider(id)).data == null) {
          return false;
        } else {
          final Item? item = ref.watch(itemNotifierProvider(id)).data?.value;
          return item?.type != ItemType.job;
        }
      case ItemMenuAction.reply:
        final Item? item = ref.watch(itemNotifierProvider(id)).data?.value;
        return item?.type != ItemType.job && item?.type != ItemType.pollopt;
      case ItemMenuAction.favorite:
        if (ref.watch(favoritedProvider(id)).data == null) {
          return false;
        } else {
          final Item? item = ref.watch(itemNotifierProvider(id)).data?.value;
          return item?.type != ItemType.job && item?.type != ItemType.pollopt;
        }
      case ItemMenuAction.copy:
      case ItemMenuAction.share:
        return true;
    }
  }

  String title(BuildContext context, WidgetRef ref, {required int id}) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted =
            ref.watch(upvotedProvider(id)).data?.value ?? false;
        return upvoted ? appLocalizations.unvote : appLocalizations.upvote;
      case ItemMenuAction.reply:
        return appLocalizations.reply;
      case ItemMenuAction.favorite:
        final bool favorited =
            ref.watch(favoritedProvider(id)).data?.value ?? false;
        return favorited
            ? appLocalizations.unfavorite
            : appLocalizations.favorite;
      case ItemMenuAction.copy:
        return appLocalizations.copy;
      case ItemMenuAction.share:
        return appLocalizations.share;
    }
  }

  Command command(BuildContext context, WidgetRef ref,
      {required int id, int? rootId}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted = ref.read(upvotedProvider(id)).data?.value ?? false;
        return VoteCommand(context, ref, id: id, upvote: !upvoted);
      case ItemMenuAction.reply:
        return ReplyCommand(context, ref, id: id, rootId: rootId);
      case ItemMenuAction.favorite:
        final bool favorited =
            ref.read(favoritedProvider(id)).data?.value ?? false;
        return FavoriteCommand(context, ref, id: id, favorite: !favorited);
      case ItemMenuAction.copy:
        return ItemOptionsCommand.copy(context, ref, id: id);
      case ItemMenuAction.share:
        return ItemOptionsCommand.share(context, ref, id: id);
    }
  }
}
