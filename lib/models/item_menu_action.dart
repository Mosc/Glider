import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/delete_command.dart';
import 'package:glider/commands/edit_command.dart';
import 'package:glider/commands/favorite_command.dart';
import 'package:glider/commands/flag_command.dart';
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
  flag,
  edit,
  delete,
  copy,
  share,
}

extension ItemMenuActionExtension on ItemMenuAction {
  bool visible(BuildContext context, WidgetRef ref, {required int id}) {
    final Item? item = ref.read(itemNotifierProvider(id)).asData?.value;

    switch (this) {
      case ItemMenuAction.vote:
        return item != null &&
            !<ItemType>{ItemType.job}.contains(item.type) &&
            ref.read(upvotedProvider(id)).asData != null;
      case ItemMenuAction.reply:
        return item != null &&
            !<ItemType>{ItemType.job, ItemType.pollopt}.contains(item.type);
      case ItemMenuAction.favorite:
        return item != null &&
            !<ItemType>{ItemType.job, ItemType.pollopt}.contains(item.type) &&
            ref.read(favoritedProvider(id)).asData != null;
      case ItemMenuAction.flag:
        return item != null &&
            !<ItemType>{ItemType.job, ItemType.pollopt}.contains(item.type);
      case ItemMenuAction.edit:
        return item != null &&
            !<ItemType>{ItemType.job, ItemType.poll, ItemType.pollopt}
                .contains(item.type) &&
            ref.read(usernameProvider).asData?.value == item.by &&
            item.editable;
      case ItemMenuAction.delete:
        return item != null &&
            !<ItemType>{ItemType.job, ItemType.poll, ItemType.pollopt}
                .contains(item.type) &&
            ref.read(usernameProvider).asData?.value == item.by &&
            item.deletable;
      case ItemMenuAction.copy:
      case ItemMenuAction.share:
        return true;
    }
  }

  String title(BuildContext context, WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted =
            ref.read(upvotedProvider(id)).asData?.value ?? false;
        return upvoted
            ? AppLocalizations.of(context)!.unvote
            : AppLocalizations.of(context)!.upvote;
      case ItemMenuAction.reply:
        return AppLocalizations.of(context)!.reply;
      case ItemMenuAction.favorite:
        final bool favorited =
            ref.read(favoritedProvider(id)).asData?.value ?? false;
        return favorited
            ? AppLocalizations.of(context)!.unfavorite
            : AppLocalizations.of(context)!.favorite;
      case ItemMenuAction.flag:
        final bool flagged =
            ref.read(itemNotifierProvider(id)).asData?.value.dead ?? false;
        return flagged
            ? AppLocalizations.of(context)!.unflag
            : AppLocalizations.of(context)!.flag;
      case ItemMenuAction.edit:
        return AppLocalizations.of(context)!.edit;
      case ItemMenuAction.delete:
        return AppLocalizations.of(context)!.delete;
      case ItemMenuAction.copy:
        return AppLocalizations.of(context)!.copy;
      case ItemMenuAction.share:
        return AppLocalizations.of(context)!.share;
    }
  }

  IconData icon(WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted =
            ref.read(upvotedProvider(id)).asData?.value ?? false;
        return upvoted
            ? FluentIcons.arrow_undo_24_regular
            : FluentIcons.arrow_up_24_regular;
      case ItemMenuAction.reply:
        return FluentIcons.arrow_reply_24_regular;
      case ItemMenuAction.favorite:
        final bool favorited =
            ref.read(favoritedProvider(id)).asData?.value ?? false;
        return favorited
            ? FluentIcons.star_off_24_regular
            : FluentIcons.star_24_regular;
      case ItemMenuAction.flag:
        final bool flagged =
            ref.read(itemNotifierProvider(id)).asData?.value.dead ?? false;
        return flagged
            ? FluentIcons.flag_off_24_regular
            : FluentIcons.flag_24_regular;
      case ItemMenuAction.edit:
        return FluentIcons.edit_24_regular;
      case ItemMenuAction.delete:
        return FluentIcons.delete_24_regular;
      case ItemMenuAction.copy:
        return FluentIcons.copy_24_regular;
      case ItemMenuAction.share:
        return FluentIcons.share_24_regular;
    }
  }

  CommandMixin command(BuildContext context, WidgetRef ref,
      {required int id, int? rootId}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted =
            ref.read(upvotedProvider(id)).asData?.value ?? false;
        return VoteCommand(context, ref, id: id, upvote: !upvoted);
      case ItemMenuAction.reply:
        return ReplyCommand(context, ref, id: id, rootId: rootId);
      case ItemMenuAction.favorite:
        final bool favorited =
            ref.read(favoritedProvider(id)).asData?.value ?? false;
        return FavoriteCommand(context, ref, id: id, favorite: !favorited);
      case ItemMenuAction.flag:
        final bool flagged =
            ref.read(itemNotifierProvider(id)).asData?.value.dead ?? false;
        return FlagCommand(context, ref, id: id, flag: !flagged);
      case ItemMenuAction.edit:
        return EditCommand(context, ref, id: id);
      case ItemMenuAction.delete:
        return DeleteCommand(context, ref, id: id);
      case ItemMenuAction.copy:
        return ItemOptionsCommand.copy(context, ref, id: id);
      case ItemMenuAction.share:
        return ItemOptionsCommand.share(context, ref, id: id);
    }
  }
}
