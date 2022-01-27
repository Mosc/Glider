import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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

  IconData get icon {
    switch (this) {
      case StoryType.topStories:
        return FluentIcons.arrow_trending_24_regular;
      case StoryType.newTopStories:
        return FluentIcons.rocket_24_filled;
      case StoryType.newStories:
        return FluentIcons.new_24_regular;
      case StoryType.bestStories:
        return FluentIcons.ribbon_star_24_regular;
      case StoryType.askStories:
        return FluentIcons.chat_help_24_regular;
      case StoryType.showStories:
        return FluentIcons.chat_warning_24_regular;
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
