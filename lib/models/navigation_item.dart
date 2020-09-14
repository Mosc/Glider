import 'package:flutter/material.dart';

enum NavigationItem {
  topStories,
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
        return Icons.whatshot;
      case NavigationItem.newStories:
        return Icons.new_releases;
      case NavigationItem.bestStories:
        return Icons.favorite;
      case NavigationItem.askStories:
        return Icons.question_answer;
      case NavigationItem.showStories:
        return Icons.announcement;
      case NavigationItem.jobStories:
        return Icons.work;
    }

    throw UnsupportedError('$this does not have an icon');
  }

  String get jsonName {
    switch (this) {
      case NavigationItem.topStories:
        return 'topstories';
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
