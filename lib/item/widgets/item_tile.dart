import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/typedefs/item_typedefs.dart';
import 'package:glider/item/widgets/item_data_tile.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/username_widget.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class ItemTile extends StatefulWidget {
  ItemTile(
    ItemCubit itemCubit,
    this._authCubit, {
    super.key,
    this.storyUsername,
    required this.loadingType,
    this.collapsedCount,
    this.showVisited = true,
    this.highlight = false,
    this.useLargeStoryStyle = true,
    this.showMetadata = true,
    this.useActionButtons = false,
    this.showJobs = true,
    this.style = ItemStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
  })  : _itemCubit = itemCubit,
        _itemCubitFactory = null,
        id = itemCubit.itemId;

  const ItemTile.create(
    ItemCubitFactory itemCubitFactory,
    this._authCubit, {
    super.key,
    required this.id,
    this.storyUsername,
    required this.loadingType,
    this.collapsedCount,
    this.showVisited = true,
    this.highlight = false,
    this.useLargeStoryStyle = true,
    this.showMetadata = true,
    this.useActionButtons = false,
    this.showJobs = true,
    this.style = ItemStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
  })  : _itemCubit = null,
        _itemCubitFactory = itemCubitFactory;

  final ItemCubit? _itemCubit;
  final ItemCubitFactory? _itemCubitFactory;
  final AuthCubit _authCubit;
  final int id;
  final String? storyUsername;
  final ItemType loadingType;
  final int? collapsedCount;
  final bool showVisited;
  final bool highlight;
  final bool useLargeStoryStyle;
  final bool showMetadata;
  final bool useActionButtons;
  final bool showJobs;
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
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: _itemCubit,
      builder: (context, state) => state.whenOrDefaultWidgets(
        loading: () => ItemLoadingTile(
          type: widget.loadingType,
          collapsedCount: widget.collapsedCount,
          showMetadata: widget.showMetadata,
          useLargeStoryStyle: widget.useLargeStoryStyle,
          style: widget.style,
          padding: widget.padding,
        ),
        success: () {
          final item = state.data!;

          if (item.type == ItemType.job && !widget.showJobs) {
            return const SizedBox.shrink();
          }

          return Material(
            type: widget.highlight
                ? MaterialType.canvas
                : MaterialType.transparency,
            elevation: 4,
            shadowColor: Colors.transparent,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            child: BlocBuilder<AuthCubit, AuthState>(
              bloc: widget._authCubit,
              builder: (context, authState) => ItemDataTile(
                item,
                visited: state.visited && widget.showVisited,
                upvoted: state.upvoted,
                favorited: state.favorited,
                flagged: state.flagged,
                blocked: state.blocked,
                failed: state.status == Status.failure,
                collapsedCount: widget.collapsedCount,
                useLargeStoryStyle: widget.useLargeStoryStyle,
                showMetadata: widget.showMetadata,
                style: widget.style,
                usernameStyle: authState.username == item.username
                    ? UsernameStyle.loggedInUser
                    : widget.storyUsername == item.username
                        ? UsernameStyle.storyUser
                        : UsernameStyle.none,
                padding: widget.padding,
                onTap: item.type == ItemType.pollopt
                    ? ItemAction.upvote.isVisible(state, authState)
                        ? (context, item) async => ItemAction.upvote
                            .execute(context, _itemCubit, widget._authCubit)
                        : null
                    : widget.onTap,
                onLongPress: (context, item) async => context.push(
                  AppRoute.itemBottomSheet
                      .location(parameters: {'id': item.id}),
                ),
                onTapUpvote: widget.useActionButtons &&
                        ItemAction.upvote.isVisible(state, authState)
                    ? () async => ItemAction.upvote
                        .execute(context, _itemCubit, widget._authCubit)
                    : null,
                onTapFavorite: widget.useActionButtons &&
                        ItemAction.favorite.isVisible(state, authState)
                    ? () async => ItemAction.favorite
                        .execute(context, _itemCubit, widget._authCubit)
                    : null,
              ),
            ),
          );
        },
        onRetry: () async => _itemCubit.load(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => switch (_itemCubit.state.status) {
        Status.loading || Status.success => true,
        _ => false,
      };
}
