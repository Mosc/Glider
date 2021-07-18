import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
        (ProviderReference ref) => WalkthroughStep.step1);

final AutoDisposeStateProvider<bool> _walkthroughUpvotedStateProvider =
    StateProvider.autoDispose<bool>((ProviderReference ref) => false);

final AutoDisposeStateProvider<bool> _walkthroughFavoritedStateProvider =
    StateProvider.autoDispose<bool>((ProviderReference ref) => false);

class WalkthoughItem extends HookWidget {
  const WalkthoughItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final StateController<WalkthroughStep> stepStateController =
        useProvider(_walkthroughStepStateProvider);
    final StateController<bool> upvotedStateController =
        useProvider(_walkthroughUpvotedStateProvider);
    final StateController<bool> favoritedStateController =
        useProvider(_walkthroughFavoritedStateProvider);

    Future<void>.microtask(() {
      switch (stepStateController.state) {
        case WalkthroughStep.step1:
          if (upvotedStateController.state) {
            stepStateController.state = stepStateController.state.nextStep;
          }
          break;
        case WalkthroughStep.step2:
          if (favoritedStateController.state) {
            stepStateController.state = stepStateController.state.nextStep;
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
                  () => upvotedStateController.state = true,
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
                  () => upvotedStateController.state = false,
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
      onDismiss: (_) {
        context.read(storageRepositoryProvider).setCompletedWalkthrough();
        context.refresh(completedWalkthroughProvider);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: InkWell(
          onLongPress: stepStateController.state.canLongPress
              ? () => _buildModalBottomSheet(context, favoritedStateController)
              : null,
          child: Block(
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
                            appLocalizations.walkthroughTitle(
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
        ),
      ),
    );
  }

  Future<void> _buildModalBottomSheet(BuildContext context,
      StateController<bool> demoFavoritedStateController) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ScrollableBottomSheet(
        children: <Widget>[
          ListTile(
            title: demoFavoritedStateController.state
                ? Text(appLocalizations.unfavorite)
                : Text(appLocalizations.favorite),
            onTap: () {
              demoFavoritedStateController.state =
                  !demoFavoritedStateController.state;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
