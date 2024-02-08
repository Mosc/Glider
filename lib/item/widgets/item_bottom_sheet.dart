import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/widgets/notification_canceler.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';
import 'package:go_router/go_router.dart';

class ItemBottomSheet extends StatelessWidget {
  const ItemBottomSheet(
    this._itemCubit,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit, {
    super.key,
  });

  final ItemCubit _itemCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

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
              BlocBuilder<WallabagCubit, WallabagState>(
            bloc: _wallabagCubit,
            builder: (context, wallabagState) =>
                NotificationCanceler<ScrollNotification>(
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  for (final action in ItemAction.values)
                    if (action.isVisible(
                      state,
                      authState,
                      settingsState,
                      wallabagState,
                    ))
                      ListTile(
                        leading: Icon(action.icon(state)),
                        title: Text(action.label(context, state)),
                        trailing: action.options != null
                            ? const Icon(Icons.chevron_right)
                            : null,
                        onTap: () async {
                          context.pop();
                          await action.execute(
                            context,
                            _itemCubit,
                            _authCubit,
                            _wallabagCubit,
                          );
                        },
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
