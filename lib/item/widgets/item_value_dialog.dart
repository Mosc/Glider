import 'package:flutter/material.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_value.dart';
import 'package:go_router/go_router.dart';

class ItemValueDialog extends StatefulWidget {
  const ItemValueDialog(
    this._itemCubitFactory,
    this._authCubit, {
    required this.id,
    this.title,
    super.key,
  });

  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final int id;
  final String? title;

  @override
  State<ItemValueDialog> createState() => _ItemValueDialogState();
}

class _ItemValueDialogState extends State<ItemValueDialog> {
  late final ItemCubit _itemCubit;

  @override
  void initState() {
    _itemCubit = widget._itemCubitFactory(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: widget.title != null ? Text(widget.title!) : null,
      children: [
        for (final value in ItemValue.values)
          if (value.isVisible(_itemCubit.state, widget._authCubit.state))
            ListTile(
              leading: Icon(value.icon),
              title: Text(value.label(context)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              onTap: () => context.pop(value),
            ),
      ],
    );
  }
}
