import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum StoryType {
  topStories,
  newStories,
  bestStories,
  askStories,
  showStories,
  jobStories,
}

extension StoryTypeExtension on StoryType {
  bool visible(BuildContext context, WidgetRef ref) {
    switch (this) {
      case StoryType.topStories:
      case StoryType.newStories:
      case StoryType.bestStories:
      case StoryType.askStories:
      case StoryType.showStories:
        return true;
      case StoryType.jobStories:
        return ref.watch(showJobsProvider).value ?? true;
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case StoryType.topStories:
        return AppLocalizations.of(context).topStories;
      case StoryType.newStories:
        return AppLocalizations.of(context).newStories;
      case StoryType.bestStories:
        return AppLocalizations.of(context).bestStories;
      case StoryType.askStories:
        return AppLocalizations.of(context).askHn;
      case StoryType.showStories:
        return AppLocalizations.of(context).showHn;
      case StoryType.jobStories:
        return AppLocalizations.of(context).jobs;
    }
  }

  String get apiPath {
    switch (this) {
      case StoryType.topStories:
        return 'topstories';
      case StoryType.newStories:
        return 'newstories';
      case StoryType.bestStories:
        return 'beststories';
      case StoryType.askStories:
        return 'askstories';
      case StoryType.showStories:
        return 'showstories';
      case StoryType.jobStories:
        return 'jobstories';
    }
  }
}
