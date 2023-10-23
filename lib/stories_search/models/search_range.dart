import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum SearchRange {
  custom,
  pastDay,
  past3Days,
  pastWeek,
  pastMonth,
  pastYear;

  String label(BuildContext context, {DateTimeRange? dateRange}) {
    return switch (this) {
      SearchRange.custom => dateRange != null
          ? dateRange.duration != Duration.zero
              ? context.l10n.dateRangeCustomMulti(
                  dateRange.start,
                  dateRange.end,
                )
              : context.l10n.dateRangeCustomSingle(dateRange.start)
          : context.l10n.dateRangeCustom,
      SearchRange.pastDay => context.l10n.dateRangePastDay,
      SearchRange.past3Days => context.l10n.dateRangePast3Days,
      SearchRange.pastWeek => context.l10n.dateRangePastWeek,
      SearchRange.pastMonth => context.l10n.dateRangePastMonth,
      SearchRange.pastYear => context.l10n.dateRangePastYear,
    };
  }

  DateTimeRange? dateRange() {
    DateTimeRange pastDuration(Duration duration) {
      final now = clock.now();
      return DateTimeRange(start: now.subtract(duration), end: now);
    }

    DateTimeRange pastDays(int days) => pastDuration(Duration(days: days));

    return switch (this) {
      SearchRange.custom => null,
      SearchRange.pastDay => pastDays(1),
      SearchRange.past3Days => pastDays(3),
      SearchRange.pastWeek => pastDays(7),
      SearchRange.pastMonth => pastDays(30),
      SearchRange.pastYear => pastDays(365),
    };
  }
}
