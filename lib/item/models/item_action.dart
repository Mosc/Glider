import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/interfaces/menu_item.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_value.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

enum ItemAction<T extends MenuItem<S>, S> implements MenuItem<ItemState> {
  upvote,
  favorite,
  flag,
  edit,
  delete,
  reply,
  select,
  copy(options: ItemValue.values),
  share(options: ItemValue.values);

  const ItemAction({this.options});

  final List<T>? options;

  @override
  bool isVisible(ItemState state, AuthState authState) {
    final item = state.data;
    if (item == null) return false;
    return switch (this) {
      ItemAction.upvote => !item.isDeleted &&
          item.type != ItemType.job &&
          authState.isLoggedIn &&
          item.username != authState.username,
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
      ItemAction.copy => true,
      ItemAction.share => true,
    };
  }

  @override
  String label(BuildContext context, ItemState state) {
    return switch (this) {
      ItemAction.upvote =>
        state.upvoted ? context.l10n.unvote : context.l10n.upvote,
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
    };
  }

  @override
  IconData icon(ItemState state) {
    return switch (this) {
      ItemAction.upvote =>
        state.upvoted ? Icons.undo_outlined : Icons.arrow_upward_outlined,
      ItemAction.favorite => state.favorited
          ? Icons.heart_broken_outlined
          : Icons.favorite_outline_outlined,
      ItemAction.flag => state.flagged ? Icons.flag : Icons.flag_outlined,
      ItemAction.edit => Icons.edit_outlined,
      ItemAction.delete => Icons.delete_outline_outlined,
      ItemAction.reply => Icons.reply_outlined,
      ItemAction.select => Icons.select_all_outlined,
      ItemAction.copy => Icons.copy_outlined,
      ItemAction.share => Icons.adaptive.share_outlined,
    };
  }

  Future<void> execute(
    BuildContext context,
    ItemCubit itemCubit,
    AuthCubit authCubit, {
    T? option,
  }) async {
    final id = itemCubit.id;
    switch (this) {
      case ItemAction.upvote:
        await itemCubit.upvote(!itemCubit.state.upvoted);
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
    }
  }
}

extension on Item {
  bool get isMaxTwoHoursAge =>
      dateTime != null && clock.hoursAgo(2).isBefore(dateTime!);
}
