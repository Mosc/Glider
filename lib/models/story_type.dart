import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';

enum StoryType {
  topStories,
  newTopStories,
  newStories,
  bestStories,
  askStories,
  showStories,
}

extension StoryTypeExtension on StoryType {
  String get title {
    switch (this) {
      case StoryType.topStories:
        return 'Top stories';
      case StoryType.newTopStories:
        return 'New top stories';
      case StoryType.newStories:
        return 'New stories';
      case StoryType.bestStories:
        return 'Best stories';
      case StoryType.askStories:
        return 'Ask HN';
      case StoryType.showStories:
        return 'Show HN';
    }

    throw UnsupportedError('$this does not have a title');
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

    throw UnsupportedError('$this does not have an icon');
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

  String get searchApiPath {
    switch (this) {
      case StoryType.newStories:
        return 'search_by_date';
      case StoryType.bestStories:
        return 'search';
      case StoryType.topStories:
      case StoryType.newTopStories:
      case StoryType.askStories:
      case StoryType.showStories:
        break;
    }

    throw UnsupportedError('$this does not have a search API path');
  }

  bool get searchable {
    switch (this) {
      case StoryType.newStories:
      case StoryType.bestStories:
        return true;
      case StoryType.topStories:
      case StoryType.newTopStories:
      case StoryType.askStories:
      case StoryType.showStories:
        return false;
    }

    throw UnsupportedError('$this does not have a searchable property');
  }
}
