enum SearchRange {
  pastDay,
  pastWeek,
  pastMonth,
  pastYear,
}

extension SearchRangeExtension on SearchRange {
  String get title {
    switch (this) {
      case SearchRange.pastDay:
        return 'Past day';
      case SearchRange.pastWeek:
        return 'Past week';
      case SearchRange.pastMonth:
        return 'Past month';
      case SearchRange.pastYear:
        return 'Past year';
    }

    throw UnsupportedError('$this does not have a title');
  }

  Duration get duration {
    switch (this) {
      case SearchRange.pastDay:
        return const Duration(days: 1);
      case SearchRange.pastWeek:
        return const Duration(days: 7);
      case SearchRange.pastMonth:
        return const Duration(days: 30);
      case SearchRange.pastYear:
        return const Duration(days: 365);
    }

    throw UnsupportedError('$this does not have a title');
  }
}
