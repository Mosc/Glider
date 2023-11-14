import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/widgets/notification_canceler.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:go_router/go_router.dart';

class ItemBottomSheet extends StatelessWidget {
  const ItemBottomSheet(
    this._itemCubit,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final ItemCubit _itemCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: _itemCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: _authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: _settingsCubit,
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
                          _authCubit,
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
