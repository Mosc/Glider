import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_value.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:go_router/go_router.dart';

class ItemValueDialog extends StatefulWidget {
  ItemValueDialog(
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    required this.id,
    this.title,
  }) : super(key: ValueKey(id));

  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
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
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: _itemCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: widget._authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: widget._settingsCubit,
          builder: (context, settingsState) => AlertDialog(
            title: widget.title != null ? Text(widget.title!) : null,
            contentPadding: const EdgeInsets.all(AppSpacing.m),
            content: SizedBox(
              width: 0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final value in ItemValue.values)
                    if (value.isVisible(state, authState, settingsState))
                      ListTile(
                        leading: Icon(value.icon(state)),
                        title: Text(value.label(context, state)),
                        onTap: () => context.pop(value),
                      ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child:
                    Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
