import 'package:flutter/material.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final StateProvider<DateTimeRange> customDateTimeRangeStateProvider =
    StateProvider<DateTimeRange>((ProviderReference ref) => null);

enum SearchRange {
  custom,
  pastDay,
  pastWeek,
  pastMonth,
  pastYear,
}

extension SearchRangeExtension on SearchRange {
  String title(BuildContext context) {
    String formatDate(DateTime dateTime) => DateFormat.yMMMd().format(dateTime);

    switch (this) {
      case SearchRange.custom:
        final DateTimeRange customDateTimeRange =
            context.read(customDateTimeRangeStateProvider).state;
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

    throw UnsupportedError('$this does not have a title');
  }

  DateTimeRange dateTimeRange(BuildContext context) {
    DateTimeRange pastDuration(Duration duration) {
      final DateTime now = DateTime.now();
      return DateTimeRange(start: now.subtract(duration), end: now);
    }

    DateTimeRange pastDays(int days) => pastDuration(Duration(days: days));

    switch (this) {
      case SearchRange.custom:
        final DateTimeRange customDateTimeRange =
            context.read(customDateTimeRangeStateProvider).state;
        return DateTimeRange(
          start: customDateTimeRange.start,
          end: customDateTimeRange.end.endOfDay,
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

    throw UnsupportedError('$this does not have a date time range');
  }
}
