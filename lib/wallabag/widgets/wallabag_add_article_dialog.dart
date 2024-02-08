import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/failure_widget.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_value.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/wallabag/cubit/wallabag_add_cubit.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';
import 'package:glider/wallabag/cubit/wallabag_duplicate_cubit.dart';
import 'package:go_router/go_router.dart';

typedef WallabagAddArticleExtra = ({
  WallabagCubit wallabagCubit,
  ItemCubit itemCubit,
});

class WallabagAddArticleDialog extends StatefulWidget {
  const WallabagAddArticleDialog(
    this._wallabagCubit,
    this._itemCubit,
    this._settingsCubit, {
    super.key,
  });

  final WallabagCubit _wallabagCubit;
  final ItemCubit _itemCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<WallabagAddArticleDialog> createState() =>
      _WallabagAddArticleDialogState();
}

class _WallabagAddArticleDialogState extends State<WallabagAddArticleDialog> {
  late final WallabagDuplicateCubit _duplicateCheckCubit;
  late final TextEditingController _tagTextController;

  late final Uri _articleUrl;
  late WallabagAddCubit _addCubit;
  late bool _useTitle;

  @override
  void initState() {
    super.initState();
    _articleUrl = widget._itemCubit.state.data!.url!;
    _duplicateCheckCubit = WallabagDuplicateCubit(
      widget._wallabagCubit,
      _articleUrl,
    );
    _tagTextController = TextEditingController();
    _useTitle = false;

    _addCubit = WallabagAddCubit(
      widget._wallabagCubit,
      widget._itemCubit,
      tags: _tagTextController.text,
      useHNTitle: _useTitle,
    );

    unawaited(_duplicateCheckCubit.load());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallabagDuplicateCubit, WallabagDuplicateState>(
      bloc: _duplicateCheckCubit,
      builder: (context, duplicateState) =>
          BlocConsumer<WallabagAddCubit, WallabagAddState>(
        bloc: _addCubit,
        listener: (context, state) {
          if (state.status == Status.success && state.data == 200) {
            context.pop();
          }
        },
        builder: (context, addState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(AppSpacing.m),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    height: 128,
                    isAntiAlias: true,
                    (Theme.of(context).brightness == Brightness.dark)
                        ? 'assets/icons/wallabag/logo-icon-white.png'
                        : 'assets/icons/wallabag/logo-icon-black.png',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  ItemValue.title.value(widget._itemCubit) ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  child: Text(
                    _articleUrl.authority,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onPressed: () async => _articleUrl.tryLaunch(
                    context,
                    useInAppBrowser:
                        widget._settingsCubit.state.useInAppBrowser,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                if (addState.status == Status.initial)
                  duplicateState.whenOrDefaultWidgets(
                    success: () {
                      return Column(
                        children: [
                          if (duplicateState.data ?? false)
                            Text(
                              context.l10n.wallabagArticleDuplicateContent,
                            )
                          else ...[
                            SwitchListTile.adaptive(
                              value: _useTitle,
                              onChanged: (state) {
                                setState(() {
                                  _useTitle = state;
                                });
                              },
                              title: Text(context.l10n.useHNTitle),
                              subtitle: Text(context.l10n.useHNTitleDesc),
                              contentPadding: EdgeInsets.zero,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                label: Text(context.l10n.tags),
                                hintText: context.l10n.tagsHint,
                                prefixIcon:
                                    const Icon(Icons.local_offer_outlined),
                              ),
                              controller: _tagTextController,
                            ),
                          ],
                        ],
                      );
                    },
                    onRetry: () => unawaited(_duplicateCheckCubit.load()),
                  )
                else
                  addState.whenOrDefaultWidgets(
                    success: () {
                      if (addState.data != 200) {
                        return FailureWidget(
                          exception: context.l10n.wallabagHttpError,
                        );
                      } else {
                        return Text(context.l10n.wallabagAddSuccess);
                      }
                    },
                    onRetry: () => unawaited(_addCubit.load()),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
              TextButton(
                onPressed: (duplicateState.status != Status.success ||
                        (duplicateState.data ?? false) ||
                        addState.status != Status.initial)
                    ? null
                    : () {
                        setState(() {
                          _addCubit = WallabagAddCubit(
                            widget._wallabagCubit,
                            widget._itemCubit,
                            tags: _tagTextController.text,
                            useHNTitle: _useTitle,
                          );
                          unawaited(_addCubit.load());
                        });
                      },
                child: Text(context.l10n.add),
              ),
            ],
          );
        },
      ),
    );
  }
}
