import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  DateTime get endOfDay => DateUtils.addDaysToDate(this, 1)
      .subtract(const Duration(microseconds: 1));
}
