import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum StoryType {
  topStories,
  newTopStories,
  newStories,
  bestStories,
  askStories,
  showStories,
}

extension StoryTypeExtension on StoryType {
  String title(BuildContext context) {
    switch (this) {
      case StoryType.topStories:
        return AppLocalizations.of(context).topStories;
      case StoryType.newTopStories:
        return AppLocalizations.of(context).newTopStories;
      case StoryType.newStories:
        return AppLocalizations.of(context).newStories;
      case StoryType.bestStories:
        return AppLocalizations.of(context).bestStories;
      case StoryType.askStories:
        return AppLocalizations.of(context).askHn;
      case StoryType.showStories:
        return AppLocalizations.of(context).showHn;
    }
  }

  String get apiPath {
    switch (this) {
      case StoryType.topStories:
        return 'topstories';
      case StoryType.newTopStories:
        break;
      case StoryType.newStories:
        return 'newstories';
      case StoryType.bestStories:
        return 'beststories';
      case StoryType.askStories:
        return 'askstories';
      case StoryType.showStories:
        return 'showstories';
    }

    throw UnsupportedError('$this does not have an API path');
  }
}
