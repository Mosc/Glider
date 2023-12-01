import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/extensions/string_extension.dart';
import 'package:glider/app/router/app_router.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/typedefs/item_typedefs.dart';
import 'package:glider/item/widgets/item_bottom_sheet.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/username_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider_domain/glider_domain.dart';

class ItemTile extends StatefulWidget {
  ItemTile(
    ItemCubit itemCubit,
    this._authCubit,
    this._settingsCubit, {
    this.storyUsername,
    required this.loadingType,
    this.collapsedCount,
    this.showVisited = true,
    this.highlight = false,
    this.forceShowMetadata = true,
    this.style = ItemStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
  })  : _itemCubit = itemCubit,
        _itemCubitFactory = null,
        id = itemCubit.itemId,
        super(key: ValueKey(itemCubit.itemId));

  ItemTile.create(
    ItemCubitFactory itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    required this.id,
    this.storyUsername,
    required this.loadingType,
    this.collapsedCount,
    this.showVisited = true,
    this.highlight = false,
    this.forceShowMetadata = true,
    this.style = ItemStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
  })  : _itemCubit = null,
        _itemCubitFactory = itemCubitFactory,
        super(key: ValueKey(id));

  final ItemCubit? _itemCubit;
  final ItemCubitFactory? _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final int id;
  final String? storyUsername;
  final ItemType loadingType;
  final int? collapsedCount;
  final bool showVisited;
  final bool highlight;
  final bool forceShowMetadata;
  final ItemStyle style;
  final EdgeInsets padding;
  final ItemCallback? onTap;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile>
    with AutomaticKeepAliveClientMixin {
  late final ItemCubit _itemCubit;

  @override
  void initState() {
    _itemCubit = widget._itemCubit ?? widget._itemCubitFactory!(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocPresentationListener<ItemCubit, ItemCubitEvent>(
      bloc: _itemCubit,
      listener: (context, event) => switch (event) {
        ItemActionFailedEvent() => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.failure),
            ),
          ),
      },
      child: BlocBuilder<ItemCubit, ItemState>(
        bloc: _itemCubit,
        builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
          bloc: widget._authCubit,
          builder: (context, authState) =>
              BlocBuilder<SettingsCubit, SettingsState>(
            bloc: widget._settingsCubit,
            builder: (context, settingsState) => AnimatedSize(
              alignment: Alignment.topCenter,
              duration: AppAnimation.emphasized.duration,
              curve: AppAnimation.emphasized.easing,
              child: state.whenOrDefaultWidgets(
                loading: () => ItemLoadingTile(
                  type: widget.loadingType,
                  collapsedCount: widget.collapsedCount,
                  useLargeStoryStyle: settingsState.useLargeStoryStyle,
                  showMetadata: settingsState.showStoryMetadata ||
                      widget.forceShowMetadata,
                  style: widget.style,
                  padding: widget.padding,
                ),
                success: () {
                  final item = state.data!;

                  if (item.type == ItemType.job && !settingsState.showJobs) {
                    return const SizedBox.shrink();
                  }

                  return Material(
                    type: widget.highlight
                        ? MaterialType.canvas
                        : MaterialType.transparency,
                    elevation: 4,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                    child: ItemDataTile(
                      item,
                      parsedText: state.parsedText,
                      visited: state.visited && widget.showVisited,
                      vote: state.vote,
                      favorited: state.favorited,
                      flagged: state.flagged,
                      blocked: state.blocked,
                      filtered: item.title != null &&
                              settingsState.wordFilters.any(
                                (word) =>
                                    item.title!.caseInsensitiveContains(word),
                              ) ||
                          item.url != null &&
                              settingsState.domainFilters.any(
                                (domain) => item.url!.host
                                    .caseInsensitiveContains(domain),
                              ),
                      failed: state.status == Status.failure,
                      collapsedCount: widget.collapsedCount,
                      useLargeStoryStyle: settingsState.useLargeStoryStyle,
                      showFavicons: settingsState.showFavicons,
                      showMetadata: settingsState.showStoryMetadata ||
                          widget.forceShowMetadata,
                      showUserAvatars: settingsState.showUserAvatars,
                      style: widget.style,
                      usernameStyle: authState.username == item.username
                          ? UsernameStyle.loggedInUser
                          : widget.storyUsername == item.username
                              ? UsernameStyle.storyUser
                              : UsernameStyle.none,
                      padding: widget.padding,
                      useInAppBrowser: settingsState.useInAppBrowser,
                      onTap: item.type == ItemType.pollopt
                          ? ItemAction.upvote
                                  .isVisible(state, authState, settingsState)
                              ? (context, item) async =>
                                  ItemAction.upvote.execute(
                                    context,
                                    _itemCubit,
                                    widget._authCubit,
                                  )
                              : null
                          : widget.onTap,
                      onLongPress: (context, item) async =>
                          showModalBottomSheet(
                        context: rootNavigatorKey.currentContext!,
                        builder: (context) => ItemBottomSheet(
                          _itemCubit,
                          widget._authCubit,
                          widget._settingsCubit,
                        ),
                      ),
                      onTapUpvote: settingsState.useActionButtons &&
                              ItemAction.upvote
                                  .isVisible(state, authState, settingsState)
                          ? () async => ItemAction.upvote
                              .execute(context, _itemCubit, widget._authCubit)
                          : null,
                      onTapFavorite: settingsState.useActionButtons &&
                              ItemAction.favorite
                                  .isVisible(state, authState, settingsState)
                          ? () async => ItemAction.favorite
                              .execute(context, _itemCubit, widget._authCubit)
                          : null,
                    ),
                  );
                },
                onRetry: () async => _itemCubit.load(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => switch (_itemCubit.state.status) {
        Status.loading || Status.success => true,
        _ => false,
      };
}
