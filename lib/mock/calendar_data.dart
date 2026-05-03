import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';
import 'package:jiffy/jiffy.dart';

final class CalendarData {
  final Color color;
  final String text;
  const CalendarData({required this.color, required this.text});
}

final Map<int, Map<int, Map<int, CalendarData>>> calendarData = () {
  final Map<int, Map<int, Map<int, CalendarData>>> result = {};

  final totalDays = Jiffy.parse('2026-12-31', isUtc: true).dayOfYear;

  for (int index = 0; index < totalDays; index++) {
    final Jiffy date = Jiffy.parse('2026-01-01', isUtc: true).add(days: index);

    final bool work = ((date.dayOfWeek - 2) % 7) <= 4;
    final String text = work ? "GO5" : "OFF";
    final Color color = work ? Color.fromRGBO(220,	110,	77, 1) : AppTheme.surface;

    final int year = date.year;
    final int month = date.month;
    final int day = date.date;

    result.putIfAbsent(year, () => {}).putIfAbsent(month, () => {})[day] =
        CalendarData(color: color, text: text);
  }

  return result;
}();
