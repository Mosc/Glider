import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/interfaces/menu_item.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_value.dart';
import 'package:glider/item/models/vote_type.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

enum ItemAction<T extends MenuItem<S>, S> implements MenuItem<ItemState> {
  visit,
  upvote,
  downvote,
  favorite,
  flag,
  edit,
  delete,
  reply,
  select,
  copy(options: ItemValue.values),
  share(options: ItemValue.values),
  wallabagSave;

  const ItemAction({this.options});

  final List<T>? options;

  @override
  bool isVisible(
    ItemState state,
    AuthState authState,
    SettingsState settingsState,
    WallabagState? wallabagState,
  ) {
    final item = state.data;
    if (item == null) return false;
    return switch (this) {
      ItemAction.visit => true,
      ItemAction.upvote => !item.isDeleted &&
          item.type != ItemType.job &&
          authState.isLoggedIn &&
          item.username != authState.username,
      ItemAction.downvote => !item.isDeleted &&
          item.type != ItemType.job &&
          authState.isLoggedIn &&
          item.username != authState.username &&
          settingsState.enableDownvoting,
      ItemAction.favorite => !item.isDeleted && item.type != ItemType.job,
      ItemAction.flag =>
        !item.isDeleted && item.type != ItemType.job && authState.isLoggedIn,
      ItemAction.edit => !item.isDeleted &&
          item.isMaxTwoHoursAge &&
          // Restricted because of uncertainty on how editing a job, poll or
          // pollopt even works.
          (item.type == ItemType.story || item.type == ItemType.comment) &&
          authState.isLoggedIn &&
          item.username == authState.username,
      ItemAction.delete => !item.isDeleted &&
          item.isMaxTwoHoursAge &&
          item.childIds != null &&
          item.childIds!.isEmpty &&
          item.type != ItemType.job &&
          authState.isLoggedIn &&
          item.username == authState.username,
      ItemAction.reply =>
        !item.isDeleted && item.type != ItemType.job && authState.isLoggedIn,
      ItemAction.select => item.text != null,
      ItemAction.copy || ItemAction.share => true,
      ItemAction.wallabagSave =>
        item.url != null && wallabagState?.status == Status.success,
    };
  }

  @override
  String label(BuildContext context, ItemState state) {
    return switch (this) {
      ItemAction.visit =>
        state.visited ? context.l10n.unvisit : context.l10n.visit,
      ItemAction.upvote =>
        state.vote.upvoted ? context.l10n.unvote : context.l10n.upvote,
      ItemAction.downvote =>
        state.vote.downvoted ? context.l10n.unvote : context.l10n.downvote,
      ItemAction.favorite =>
        state.favorited ? context.l10n.unfavorite : context.l10n.favorite,
      ItemAction.flag =>
        state.flagged ? context.l10n.unflag : context.l10n.flag,
      ItemAction.edit => context.l10n.edit,
      ItemAction.delete => context.l10n.delete,
      ItemAction.reply => context.l10n.reply,
      ItemAction.select => context.l10n.select,
      ItemAction.copy => context.l10n.copy,
      ItemAction.share => context.l10n.share,
      ItemAction.wallabagSave => context.l10n.wallabagSave,
    };
  }

  @override
  IconData icon(ItemState state) {
    return switch (this) {
      ItemAction.upvote =>
        state.vote.upvoted ? Icons.undo_outlined : Icons.arrow_upward_outlined,
      ItemAction.downvote => state.vote.downvoted
          ? Icons.undo_outlined
          : Icons.arrow_downward_outlined,
      ItemAction.favorite => state.favorited
          ? Icons.heart_broken_outlined
          : Icons.favorite_outline_outlined,
      ItemAction.flag => state.flagged ? Icons.flag : Icons.flag_outlined,
      ItemAction.visit => state.visited
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined,
      ItemAction.edit => Icons.edit_outlined,
      ItemAction.delete => Icons.delete_outline_outlined,
      ItemAction.reply => Icons.reply_outlined,
      ItemAction.select => Icons.select_all_outlined,
      ItemAction.copy => Icons.copy_outlined,
      ItemAction.share => Icons.adaptive.share_outlined,
      ItemAction.wallabagSave => Icons.add,
    };
  }

  Future<void> execute(
    BuildContext context,
    ItemCubit itemCubit,
    AuthCubit authCubit,
    WallabagCubit wallabagCubit, {
    T? option,
  }) async {
    final id = itemCubit.id;
    switch (this) {
      case ItemAction.visit:
        await itemCubit.visit(!itemCubit.state.visited);
      case ItemAction.upvote:
        await itemCubit.upvote(itemCubit.state.vote != VoteType.upvote);
      case ItemAction.downvote:
        await itemCubit.downvote(itemCubit.state.vote != VoteType.downvote);
      case ItemAction.favorite:
        await itemCubit.favorite(!itemCubit.state.favorited);
      case ItemAction.flag:
        if (!itemCubit.state.flagged) {
          final confirm =
              await context.push<bool>(AppRoute.confirmDialog.location());
          if (confirm ?? false) await itemCubit.flag(true);
        } else {
          await itemCubit.flag(false);
        }
      case ItemAction.edit:
        await context.push(
          AppRoute.edit.location(parameters: {'id': id}),
        );
      case ItemAction.delete:
        final confirm =
            await context.push<bool>(AppRoute.confirmDialog.location());
        if (confirm ?? false) await itemCubit.delete();
      case ItemAction.reply:
        await context.push(
          AppRoute.reply.location(parameters: {'id': id}),
        );
      case ItemAction.select:
        await context.push(
          AppRoute.textSelectDialog.location(),
          extra: itemCubit.state.data!.text,
        );
      case ItemAction.copy:
        final valueAction = option as ItemValue? ??
            await context.push(
              AppRoute.itemValueDialog.location(parameters: {'id': id}),
              extra: context.l10n.copy,
            );

        if (valueAction != null) {
          await itemCubit.copy(valueAction.value(itemCubit)!);
        }
      case ItemAction.share:
        final valueAction = option as ItemValue? ??
            await context.push(
              AppRoute.itemValueDialog.location(parameters: {'id': id}),
              extra: context.l10n.share,
            );

        if (valueAction != null) {
          await itemCubit.share(
            valueAction.value(itemCubit)!,
            subject: valueAction != ItemValue.title
                ? ItemValue.title.value(itemCubit)
                : null,
          );
        }
      case ItemAction.wallabagSave:
        await context.push(
          AppRoute.wallabagAddArticleDialog.location(),
          extra: (itemCubit: itemCubit, wallabagCubit: wallabagCubit),
        );
    }
  }
}

extension on Item {
  bool get isMaxTwoHoursAge =>
      dateTime != null && clock.hoursAgo(2).isBefore(dateTime!);
}
