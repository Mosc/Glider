import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/utils/date_time_extension.dart';

enum SearchRange {
  custom,
  pastDay,
  pastWeek,
  pastMonth,
  pastYear,
}

extension SearchRangeExtension on SearchRange {
  String title(BuildContext context, DateTimeRange? customDateTimeRange) {
    switch (this) {
      case SearchRange.custom:
        return customDateTimeRange != null
            ? customDateTimeRange.duration != Duration.zero
                ? AppLocalizations.of(context)!.dateRange(
                    customDateTimeRange.start,
                    customDateTimeRange.end,
                  )
                : AppLocalizations.of(context)!.dateRangeSingle(
                    customDateTimeRange.start,
                  )
            : AppLocalizations.of(context)!.custom;
      case SearchRange.pastDay:
        return AppLocalizations.of(context)!.pastDay;
      case SearchRange.pastWeek:
        return AppLocalizations.of(context)!.pastWeek;
      case SearchRange.pastMonth:
        return AppLocalizations.of(context)!.pastMonth;
      case SearchRange.pastYear:
        return AppLocalizations.of(context)!.pastYear;
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
  }
}
