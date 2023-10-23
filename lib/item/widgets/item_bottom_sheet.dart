import 'package:flutter/material.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/widgets/notification_canceler.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:go_router/go_router.dart';

class ItemBottomSheet extends StatefulWidget {
  const ItemBottomSheet(
    this._itemCubitFactory,
    this.authCubit, {
    super.key,
    required this.id,
  });

  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit authCubit;
  final int id;

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  late final ItemCubit _itemCubit;

  @override
  void initState() {
    _itemCubit = widget._itemCubitFactory(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationCanceler<ScrollNotification>(
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          for (final action in ItemAction.values)
            if (action.isVisible(_itemCubit.state, widget.authCubit.state))
              ListTile(
                leading: Icon(action.icon),
                title: Text(action.label(context)),
                onTap: () async {
                  context.pop();
                  await action.execute(context, _itemCubit, widget.authCubit);
                },
              ),
        ],
      ),
    );
  }
}
