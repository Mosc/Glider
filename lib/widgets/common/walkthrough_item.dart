import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/models/walkthrough_step.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/menu_actions_bar.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/slidable.dart';
import 'package:glider/widgets/common/smooth_animated_size.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<WalkthroughStep> _walkthroughStepStateProvider =
    StateProvider.autoDispose<WalkthroughStep>(
  (AutoDisposeStateProviderRef<WalkthroughStep> ref) => WalkthroughStep.step1,
);

final AutoDisposeStateProvider<bool> _walkthroughUpvotedStateProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);

final AutoDisposeStateProvider<bool> _walkthroughFavoritedStateProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);

final AutoDisposeStateProvider<bool> _walkthroughLongPressStateProvider =
    StateProvider.autoDispose<bool>(
  (AutoDisposeStateProviderRef<bool> ref) => false,
);

class WalkthoughItem extends HookConsumerWidget {
  const WalkthoughItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StateController<WalkthroughStep> stepStateController =
        ref.watch(_walkthroughStepStateProvider.state);
    final StateController<bool> upvotedStateController =
        ref.watch(_walkthroughUpvotedStateProvider.state);
    final StateController<bool> favoritedStateController =
        ref.watch(_walkthroughFavoritedStateProvider.state);
    final StateController<bool> longPressedStateController =
        ref.watch(_walkthroughLongPressStateProvider.state);

    Future<void>.microtask(() {
      switch (stepStateController.state) {
        case WalkthroughStep.step1:
          if (upvotedStateController.state) {
            stepStateController
                .update((WalkthroughStep state) => state.nextStep);
          }
          break;
        case WalkthroughStep.step2:
          if (favoritedStateController.state) {
            stepStateController
                .update((WalkthroughStep state) => state.nextStep);
          }
          break;
        case WalkthroughStep.step3:
          break;
      }
    });

    return Slidable(
      key: const ValueKey<Type>(WalkthoughItem),
      startToEndAction: !upvotedStateController.state
          ? SlidableAction(
              action: () async {
                Future<void>.delayed(
                  Slidable.movementDuration,
                  () => upvotedStateController.update((_) => true),
                );
              },
              icon: FluentIcons.arrow_up_24_regular,
              color: Theme.of(context).colorScheme.primary,
              iconColor: Theme.of(context).colorScheme.onPrimary,
            )
          : SlidableAction(
              action: () async {
                Future<void>.delayed(
                  Slidable.movementDuration,
                  () => upvotedStateController.update((_) => false),
                );
              },
              icon: FluentIcons.arrow_undo_24_regular,
            ),
      endToStartAction: SlidableAction(
        action: () async => true,
        icon: FluentIcons.delete_24_regular,
        color: Theme.of(context).colorScheme.error,
        iconColor: Theme.of(context).colorScheme.onError,
      ),
      onDismiss: (_) async {
        await ref.read(storageRepositoryProvider).setCompletedWalkthrough();
        ref.refresh(completedWalkthroughProvider);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: InkWell(
          onLongPress: stepStateController.state.canLongPress
              ? () => longPressedStateController.update((bool state) => !state)
              : null,
          child: Column(
            children: <Widget>[
              Block(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const MetadataItem(
                              icon: FluentIcons.book_information_24_regular,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                AppLocalizations.of(context).walkthroughTitle(
                                  stepStateController.state.number,
                                  WalkthroughStep.values.length,
                                ),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SmoothAnimatedSwitcher.horizontal(
                              condition: favoritedStateController.state,
                              child: MetadataItem(
                                icon: FluentIcons.star_24_regular,
                                highlight: favoritedStateController.state,
                              ),
                            ),
                            SmoothAnimatedSwitcher.horizontal(
                              condition: upvotedStateController.state,
                              child: MetadataItem(
                                icon: FluentIcons.arrow_up_24_regular,
                                highlight: upvotedStateController.state,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    SmoothAnimatedSize(
                      child: Text(stepStateController.state.text(context)),
                    ),
                  ],
                ),
              ),
              SmoothAnimatedSwitcher.vertical(
                condition: longPressedStateController.state,
                child: MenuActionsBar(
                  children: <IconButton>[
                    IconButton(
                      onPressed: () =>
                          upvotedStateController.update((bool state) => !state),
                      tooltip: upvotedStateController.state
                          ? AppLocalizations.of(context).unvote
                          : AppLocalizations.of(context).upvote,
                      icon: Icon(
                        upvotedStateController.state
                            ? FluentIcons.arrow_undo_20_regular
                            : FluentIcons.arrow_up_20_regular,
                      ),
                    ),
                    IconButton(
                      onPressed: () => favoritedStateController
                          .update((bool state) => !state),
                      tooltip: favoritedStateController.state
                          ? AppLocalizations.of(context).unfavorite
                          : AppLocalizations.of(context).favorite,
                      icon: Icon(
                        favoritedStateController.state
                            ? FluentIcons.star_off_20_regular
                            : FluentIcons.star_20_regular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
