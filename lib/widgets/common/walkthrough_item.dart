import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/models/walkthrough_step.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
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

class WalkthoughItem extends HookConsumerWidget {
  const WalkthoughItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StateController<WalkthroughStep> stepStateController =
        ref.watch(_walkthroughStepStateProvider.notifier);
    final StateController<bool> upvotedStateController =
        ref.watch(_walkthroughUpvotedStateProvider.notifier);
    final StateController<bool> favoritedStateController =
        ref.watch(_walkthroughFavoritedStateProvider.notifier);

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
                return false;
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
                return false;
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
        await ref
            .read(storageRepositoryProvider)
            .setCompletedWalkthrough(value: true);
        ref.invalidate(completedWalkthroughProvider);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: InkWell(
          onLongPress: stepStateController.state.canLongPress
              ? () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => ScrollableBottomSheet(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            upvotedStateController.state
                                ? FluentIcons.arrow_undo_24_regular
                                : FluentIcons.arrow_up_24_regular,
                          ),
                          title: Text(
                            upvotedStateController.state
                                ? AppLocalizations.of(context).unvote
                                : AppLocalizations.of(context).upvote,
                          ),
                          onTap: () {
                            upvotedStateController
                                .update((bool state) => !state);
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            favoritedStateController.state
                                ? FluentIcons.star_off_24_regular
                                : FluentIcons.star_24_regular,
                          ),
                          title: Text(
                            favoritedStateController.state
                                ? AppLocalizations.of(context).unfavorite
                                : AppLocalizations.of(context).favorite,
                          ),
                          onTap: () {
                            favoritedStateController
                                .update((bool state) => !state);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  )
              : null,
          child: Block(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: Theme.of(context).textTheme.bodySmall,
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
                SmoothAnimatedSize(
                  child: Text(stepStateController.state.text(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
