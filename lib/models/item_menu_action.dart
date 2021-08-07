import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/favorite_command.dart';
import 'package:glider/commands/item_options_command.dart';
import 'package:glider/commands/reply_command.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ItemMenuAction {
  vote,
  reply,
  favorite,
  copy,
  share,
}

extension ItemMenuActionExtension on ItemMenuAction {
  String title(BuildContext context,
      {required bool upvoted, required bool favorited}) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case ItemMenuAction.vote:
        return upvoted ? appLocalizations.unvote : appLocalizations.upvote;
      case ItemMenuAction.reply:
        return appLocalizations.reply;
      case ItemMenuAction.favorite:
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
      {required int id, required bool upvoted, required bool favorited}) {
    switch (this) {
      case ItemMenuAction.vote:
        return VoteCommand(context, ref, id: id, upvote: !upvoted);
      case ItemMenuAction.reply:
        return ReplyCommand(context, ref, id: id);
      case ItemMenuAction.favorite:
        return FavoriteCommand(context, ref, id: id, favorite: !favorited);
      case ItemMenuAction.copy:
        return ItemOptionsCommand.copy(context, ref, id: id);
      case ItemMenuAction.share:
        return ItemOptionsCommand.share(context, ref, id: id);
    }
  }
}
