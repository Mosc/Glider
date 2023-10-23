import 'package:flutter/material.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum StoryType {
  topStories,
  newStories,
  bestStories,
  askStories,
  showStories,
  jobStories;

  String label(BuildContext context) {
    return switch (this) {
      StoryType.topStories => context.l10n.storyTypeTop,
      StoryType.newStories => context.l10n.storyTypeNew,
      StoryType.bestStories => context.l10n.storyTypeBest,
      StoryType.askStories => context.l10n.storyTypeAsk,
      StoryType.showStories => context.l10n.storyTypeShow,
      StoryType.jobStories => context.l10n.storyTypeJob,
    };
  }

  IconData get icon {
    return switch (this) {
      StoryType.topStories => Icons.whatshot_outlined,
      StoryType.newStories => Icons.new_releases_outlined,
      StoryType.bestStories => Icons.recommend_outlined,
      StoryType.askStories => Icons.help_outline_outlined,
      StoryType.showStories => Icons.play_circle_outlined,
      StoryType.jobStories => Icons.monetization_on_outlined,
    };
  }

  IconData get selectedIcon {
    return switch (this) {
      StoryType.topStories => Icons.whatshot,
      StoryType.newStories => Icons.new_releases,
      StoryType.bestStories => Icons.recommend,
      StoryType.askStories => Icons.help,
      StoryType.showStories => Icons.play_circle,
      StoryType.jobStories => Icons.monetization_on,
    };
  }
}
