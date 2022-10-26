import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/delete_command.dart';
import 'package:glider/commands/edit_command.dart';
import 'package:glider/commands/favorite_command.dart';
import 'package:glider/commands/flag_command.dart';
import 'package:glider/commands/item_options_command.dart';
import 'package:glider/commands/reply_command.dart';
import 'package:glider/commands/select_text_command.dart';
import 'package:glider/commands/show_parent_command.dart';
import 'package:glider/commands/toggle_visited_command.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:glider/models/item.dart';
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
  selectText,
  showParent,
  copy,
  share,
  toggleVisited,
}

extension ItemMenuActionExtension on ItemMenuAction {
  bool visible(BuildContext context, WidgetRef ref, {required int id}) {
    final Item? item = ref.watch(itemNotifierProvider(id)).value;

    switch (this) {
      case ItemMenuAction.vote:
        return item != null &&
            item.votable &&
            ref.watch(upvotedProvider(id)).asData != null;
      case ItemMenuAction.reply:
        return item != null && item.replyable;
      case ItemMenuAction.favorite:
        return item != null &&
            item.favoritable &&
            ref.watch(favoritedProvider(id)).asData != null;
      case ItemMenuAction.flag:
        return item != null && item.flaggable;
      case ItemMenuAction.edit:
        return item != null &&
            item.editable &&
            ref.watch(usernameProvider).value == item.by;
      case ItemMenuAction.delete:
        return item != null &&
            item.deletable &&
            ref.watch(usernameProvider).value == item.by;
      case ItemMenuAction.selectText:
        return item != null && (item.text?.isNotEmpty ?? false);
      case ItemMenuAction.showParent:
        return item != null && item.parent != null;
      case ItemMenuAction.copy:
      case ItemMenuAction.share:
        return true;
      case ItemMenuAction.toggleVisited:
        return item != null && item.visitable;
    }
  }

  String title(BuildContext context, WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted = ref.watch(upvotedProvider(id)).value ?? false;
        return upvoted
            ? AppLocalizations.of(context).unvote
            : AppLocalizations.of(context).upvote;
      case ItemMenuAction.reply:
        return AppLocalizations.of(context).reply;
      case ItemMenuAction.favorite:
        final bool favorited = ref.watch(favoritedProvider(id)).value ?? false;
        return favorited
            ? AppLocalizations.of(context).unfavorite
            : AppLocalizations.of(context).favorite;
      case ItemMenuAction.flag:
        final bool flagged =
            ref.watch(itemNotifierProvider(id)).value?.dead ?? false;
        return flagged
            ? AppLocalizations.of(context).unflag
            : AppLocalizations.of(context).flag;
      case ItemMenuAction.edit:
        return AppLocalizations.of(context).edit;
      case ItemMenuAction.delete:
        return AppLocalizations.of(context).delete;
      case ItemMenuAction.selectText:
        return AppLocalizations.of(context).selectText;
      case ItemMenuAction.showParent:
        return AppLocalizations.of(context).showParent;
      case ItemMenuAction.copy:
        return AppLocalizations.of(context).copy;
      case ItemMenuAction.share:
        return AppLocalizations.of(context).share;
      case ItemMenuAction.toggleVisited:
        final bool visited = ref.read(visitedProvider(id)).value ?? false;
        return visited
            ? AppLocalizations.of(context).markUnread
            : AppLocalizations.of(context).markRead;
    }
  }

  IconData icon(BuildContext context, WidgetRef ref, {required int id}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted = ref.watch(upvotedProvider(id)).value ?? false;
        return upvoted
            ? FluentIcons.arrow_undo_24_regular
            : FluentIcons.arrow_up_24_regular;
      case ItemMenuAction.reply:
        return FluentIcons.arrow_reply_24_regular;
      case ItemMenuAction.favorite:
        final bool favorited = ref.watch(favoritedProvider(id)).value ?? false;
        return favorited
            ? FluentIcons.star_off_24_regular
            : FluentIcons.star_24_regular;
      case ItemMenuAction.flag:
        final bool flagged =
            ref.watch(itemNotifierProvider(id)).value?.dead ?? false;
        return flagged
            ? FluentIcons.flag_off_24_regular
            : FluentIcons.flag_24_regular;
      case ItemMenuAction.edit:
        return FluentIcons.edit_24_regular;
      case ItemMenuAction.delete:
        return FluentIcons.delete_24_regular;
      case ItemMenuAction.selectText:
        return FluentIcons.split_vertical_24_regular;
      case ItemMenuAction.showParent:
        return FluentIcons.fluid_24_regular;
      case ItemMenuAction.copy:
        return Directionality.of(context) == TextDirection.rtl
            ? FluentIcons.clipboard_text_rtl_24_regular
            : FluentIcons.clipboard_text_ltr_24_regular;
      case ItemMenuAction.share:
        return FluentIcons.share_24_regular;
      case ItemMenuAction.toggleVisited:
        final bool visited = ref.read(visitedProvider(id)).value ?? false;
        return visited
            ? FluentIcons.eye_off_24_regular
            : FluentIcons.eye_24_regular;
    }
  }

  CommandMixin command(BuildContext context, WidgetRef ref,
      {required int id, int? rootId}) {
    switch (this) {
      case ItemMenuAction.vote:
        final bool upvoted = ref.read(upvotedProvider(id)).value ?? false;
        return VoteCommand(context, ref, id: id, upvote: !upvoted);
      case ItemMenuAction.reply:
        return ReplyCommand(context, ref, id: id, rootId: rootId);
      case ItemMenuAction.favorite:
        final bool favorited = ref.read(favoritedProvider(id)).value ?? false;
        return FavoriteCommand(context, ref, id: id, favorite: !favorited);
      case ItemMenuAction.flag:
        final bool flagged =
            ref.read(itemNotifierProvider(id)).value?.dead ?? false;
        return FlagCommand(context, ref, id: id, flag: !flagged);
      case ItemMenuAction.edit:
        return EditCommand(context, ref, id: id);
      case ItemMenuAction.delete:
        return DeleteCommand(context, ref, id: id);
      case ItemMenuAction.selectText:
        return SelectTextCommand(context, ref, id: id);
      case ItemMenuAction.showParent:
        return ShowParentCommand(context, ref, id: id);
      case ItemMenuAction.copy:
        return ItemOptionsCommand.copy(context, ref, id: id);
      case ItemMenuAction.share:
        return ItemOptionsCommand.share(context, ref, id: id);
      case ItemMenuAction.toggleVisited:
        final bool visited = ref.read(visitedProvider(id)).value ?? false;
        return ToggleVisitedCommand(context, ref,
            id: id, newVisitedState: !visited);
    }
  }
}
