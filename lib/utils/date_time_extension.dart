extension DateTimeExtension on DateTime {
  static DateTime fromSecondsSinceEpoch(int seconds) =>
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  DateTime get endOfDay => DateTime(
        year,
        month,
        day,
        Duration.hoursPerDay - 1,
        Duration.minutesPerHour - 1,
        Duration.secondsPerMinute - 1,
        Duration.millisecondsPerSecond - 1,
        Duration.microsecondsPerMillisecond - 1,
      );
}
