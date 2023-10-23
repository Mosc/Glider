import 'package:flutter/material.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/interfaces/menu_item.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum ItemValue implements MenuItem<ItemState> {
  title,
  link,
  text,
  itemLink;

  @override
  bool isVisible(ItemState state, AuthState authState) {
    final item = state.data;
    if (item == null) return false;
    return switch (this) {
      ItemValue.title => item.title != null,
      ItemValue.link => item.url != null,
      ItemValue.text => item.text != null,
      ItemValue.itemLink => true,
    };
  }

  @override
  String label(BuildContext context) {
    return switch (this) {
      ItemValue.title => context.l10n.title,
      ItemValue.link => context.l10n.link,
      ItemValue.text => context.l10n.text,
      ItemValue.itemLink => context.l10n.itemLink,
    };
  }

  @override
  IconData get icon {
    return switch (this) {
      ItemValue.title => Icons.title_outlined,
      ItemValue.link => Icons.link_outlined,
      ItemValue.text => Icons.notes_outlined,
      ItemValue.itemLink => Icons.forum_outlined,
    };
  }

  String? value(ItemCubit itemCubit) {
    final item = itemCubit.state.data;
    return switch (this) {
      ItemValue.title => item?.title,
      ItemValue.link => item?.url.toString(),
      ItemValue.text => item?.text,
      ItemValue.itemLink => Uri.https(
          'news.ycombinator.com',
          'item',
          <String, String>{
            'id': itemCubit.itemId.toString(),
          },
        ).toString(),
    };
  }
}
