import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

enum SearchRange {
  custom,
  pastDay,
  pastWeek,
  pastMonth,
  pastYear,
}

extension SearchRangeExtension on SearchRange {
  String title(DateTimeRange? customDateTimeRange) {
    String formatDate(DateTime dateTime) => Jiffy(dateTime).yMMMd;

    switch (this) {
      case SearchRange.custom:
        return customDateTimeRange != null
            ? customDateTimeRange.duration != Duration.zero
                ? '${formatDate(customDateTimeRange.start)} to '
                    '${formatDate(customDateTimeRange.end)}'
                : formatDate(customDateTimeRange.start)
            : 'Custom';
      case SearchRange.pastDay:
        return 'Past day';
      case SearchRange.pastWeek:
        return 'Past week';
      case SearchRange.pastMonth:
        return 'Past month';
      case SearchRange.pastYear:
        return 'Past year';
    }
  }

  DateTimeRange dateTimeRange(DateTimeRange? customDateTimeRange) {
    DateTimeRange pastDuration(Duration duration) {
      final DateTime now = DateTime.now();
      return DateTimeRange(start: now.subtract(duration), end: now);
    }

    DateTimeRange pastDays(int days) => pastDuration(Duration(days: days));

    switch (this) {
      case SearchRange.custom:
        return DateTimeRange(
          start: customDateTimeRange!.start,
          end: (Jiffy(customDateTimeRange.end)..endOf(Units.DAY)).dateTime,
        );
      case SearchRange.pastDay:
        return pastDays(1);
      case SearchRange.pastWeek:
        return pastDays(7);
      case SearchRange.pastMonth:
        return pastDays(30);
      case SearchRange.pastYear:
        return pastDays(365);
    }
  }
}
