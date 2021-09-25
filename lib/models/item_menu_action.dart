import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/favorite_command.dart';
import 'package:glider/commands/flag_command.dart';
import 'package:glider/commands/item_options_command.dart';
import 'package:glider/commands/reply_command.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ItemMenuAction {
  vote,
  reply,
  favorite,
  flag,
  copy,
  share,
}

extension ItemMenuActionExtension on ItemMenuAction {
  bool visible(BuildContext context, WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        return ref.watch(upvotedProvider(id)).data != null &&
            ItemType.job !=
                ref.watch(itemNotifierProvider(id)).data?.value.type;
      case ItemMenuAction.reply:
        return !<ItemType>[ItemType.job, ItemType.pollopt]
            .contains(ref.watch(itemNotifierProvider(id)).data?.value.type);
      case ItemMenuAction.favorite:
        return ref.watch(favoritedProvider(id)).data != null &&
            !<ItemType>[ItemType.job, ItemType.pollopt]
                .contains(ref.watch(itemNotifierProvider(id)).data?.value.type);
      case ItemMenuAction.flag:
        return !<ItemType>[ItemType.job, ItemType.pollopt]
            .contains(ref.watch(itemNotifierProvider(id)).data?.value.type);
      case ItemMenuAction.copy:
      case ItemMenuAction.share:
        return true;
    }
  }

  String title(BuildContext context, WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        return ref.watch(upvotedProvider(id)).data?.value ?? false
            ? AppLocalizations.of(context)!.unvote
            : AppLocalizations.of(context)!.upvote;
      case ItemMenuAction.reply:
        return AppLocalizations.of(context)!.reply;
      case ItemMenuAction.favorite:
        return ref.watch(favoritedProvider(id)).data?.value ?? false
            ? AppLocalizations.of(context)!.unfavorite
            : AppLocalizations.of(context)!.favorite;
      case ItemMenuAction.flag:
        return ref.read(itemNotifierProvider(id)).data?.value.dead ?? false
            ? AppLocalizations.of(context)!.unflag
            : AppLocalizations.of(context)!.flag;
      case ItemMenuAction.copy:
        return AppLocalizations.of(context)!.copy;
      case ItemMenuAction.share:
        return AppLocalizations.of(context)!.share;
    }
  }

  CommandMixin command(BuildContext context, WidgetRef ref,
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
      case ItemMenuAction.flag:
        final bool flagged =
            ref.read(itemNotifierProvider(id)).data?.value.dead ?? false;
        return FlagCommand(context, ref, id: id, flag: !flagged);
      case ItemMenuAction.copy:
        return ItemOptionsCommand.copy(context, ref, id: id);
      case ItemMenuAction.share:
        return ItemOptionsCommand.share(context, ref, id: id);
    }
  }
}
