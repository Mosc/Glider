import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

enum NavigationItem {
  topStories,
  newTopStories,
  newStories,
  bestStories,
  askStories,
  showStories,
  jobStories,
}

extension NavigationItemExtension on NavigationItem {
  String get title {
    switch (this) {
      case NavigationItem.topStories:
        return 'Top stories';
      case NavigationItem.newTopStories:
        return 'New top stories';
      case NavigationItem.newStories:
        return 'New stories';
      case NavigationItem.bestStories:
        return 'Best stories';
      case NavigationItem.askStories:
        return 'Ask HN';
      case NavigationItem.showStories:
        return 'Show HN';
      case NavigationItem.jobStories:
        return 'Jobs';
    }

    throw UnsupportedError('$this does not have a title');
  }

  IconData get icon {
    switch (this) {
      case NavigationItem.topStories:
        return FluentIcons.arrow_trending_24_filled;
      case NavigationItem.newTopStories:
        return FluentIcons.rocket_24_filled;
      case NavigationItem.newStories:
        return FluentIcons.new_24_filled;
      case NavigationItem.bestStories:
        return FluentIcons.ribbon_star_24_filled;
      case NavigationItem.askStories:
        return FluentIcons.chat_help_24_filled;
      case NavigationItem.showStories:
        return FluentIcons.chat_warning_24_filled;
      case NavigationItem.jobStories:
        return FluentIcons.briefcase_24_filled;
    }

    throw UnsupportedError('$this does not have an icon');
  }

  String get jsonName {
    switch (this) {
      case NavigationItem.topStories:
        return 'topstories';
      case NavigationItem.newTopStories:
        break;
      case NavigationItem.newStories:
        return 'newstories';
      case NavigationItem.bestStories:
        return 'beststories';
      case NavigationItem.askStories:
        return 'askstories';
      case NavigationItem.showStories:
        return 'showstories';
      case NavigationItem.jobStories:
        return 'jobstories';
    }

    throw UnsupportedError('$this does not have a JSON name');
  }
}
