import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/widgets/notification_canceler.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:go_router/go_router.dart';

class ItemBottomSheet extends StatefulWidget {
  const ItemBottomSheet(
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    required this.id,
  });

  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
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
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: _itemCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: widget._authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: widget._settingsCubit,
          builder: (context, settingsState) =>
              NotificationCanceler<ScrollNotification>(
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: [
                for (final action in ItemAction.values)
                  if (action.isVisible(state, authState, settingsState))
                    ListTile(
                      leading: Icon(action.icon(state)),
                      title: Text(action.label(context, state)),
                      onTap: () async {
                        context.pop();
                        await action.execute(
                          context,
                          _itemCubit,
                          widget._authCubit,
                        );
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
