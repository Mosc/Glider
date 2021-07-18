import 'package:flutter/material.dart';
import 'package:glider/l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';

enum SearchRange {
  custom,
  pastDay,
  pastWeek,
  pastMonth,
  pastYear,
}

extension SearchRangeExtension on SearchRange {
  String title(BuildContext context, DateTimeRange? customDateTimeRange) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case SearchRange.custom:
        return customDateTimeRange != null
            ? customDateTimeRange.duration != Duration.zero
                ? appLocalizations.dateRange(
                    customDateTimeRange.start,
                    customDateTimeRange.end,
                  )
                : appLocalizations.dateRangeSingle(customDateTimeRange.start)
            : appLocalizations.custom;
      case SearchRange.pastDay:
        return appLocalizations.pastDay;
      case SearchRange.pastWeek:
        return appLocalizations.pastWeek;
      case SearchRange.pastMonth:
        return appLocalizations.pastMonth;
      case SearchRange.pastYear:
        return appLocalizations.pastYear;
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
