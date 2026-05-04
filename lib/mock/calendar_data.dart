import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';
import 'package:jiffy/jiffy.dart';

class CalendarActivityIcon extends StatelessWidget {
  final String? emoji;
  final IconData? iconData;
  final Color? color;
  const CalendarActivityIcon({super.key, this.emoji, this.iconData, this.color})
    : assert((emoji == null) != (iconData == null));

  CalendarActivityIcon withColor(Color color) => CalendarActivityIcon(
    key: key,
    emoji: emoji,
    iconData: iconData,
    color: color,
  );

  @override
  Widget build(BuildContext context) {
    late final Widget r;
    if (emoji is String) {
      r = Text(emoji!, style: TextStyle(color: color));
    } else if (iconData is IconData) {
      r = Icon(iconData!, color: color);
    } else {
      r = Placeholder();
    }
    return AspectRatio(aspectRatio: 1, child: FittedBox(child: r));
  }
}

enum CalendarActivityEnum {
  irregularWork(
    'abnormal_status',
    CalendarActivityIcon(iconData: Icons.warning_amber_rounded),
  ),
  overtime('overtime', CalendarActivityIcon(iconData: Icons.more_time)),
  document(
    'document',
    CalendarActivityIcon(iconData: Icons.description_outlined),
  ),
  activity('activity', CalendarActivityIcon(iconData: Icons.calendar_month)),
  announcement('announcement', CalendarActivityIcon(emoji: '📣')),
  swapShift('swap_shift', CalendarActivityIcon(iconData: Icons.swap_horiz)),
  interview('interview', CalendarActivityIcon(emoji: '👥')),
  birthday('birthday', CalendarActivityIcon(emoji: '🎂')),
  firstDay('first_day', CalendarActivityIcon(emoji: '👋')),
  lastDay('last_day', CalendarActivityIcon(emoji: '🍂'));

  final String localizationKey;
  final CalendarActivityIcon icon;
  const CalendarActivityEnum(this.localizationKey, this.icon);
}

enum CalendarRequest {
  leave('leave'),
  offsiteWork('offsite_work'),
  overtime('overtime_request'),
  endorse('endorse'),
  collectTimeDate('collect_time_date'),
  redeem('redeem'),
  expense('expense');

  const CalendarRequest(this.langKey);

  final String langKey;
}

final class CalendarActivity {
  final CalendarActivityEnum type;
  final Jiffy time;
  final String text;
  const CalendarActivity({
    required this.type,
    required this.time,
    required this.text,
  });
}

final class CalendarData {
  final Color color;
  final String text;
  final bool blocked;
  final Set<CalendarRequest> requests;
  final List<CalendarActivity> acitivies;
  const CalendarData({
    required this.color,
    required this.text,
    this.blocked = false,
    this.requests = const {},
    this.acitivies = const [],
  });

  List<Widget> icons([Color? color]) {
    Set<CalendarActivityIcon> iconEnums = {};
    for (var element in acitivies) {
      iconEnums.add(element.type.icon);
    }
    return iconEnums
        .map((icon) => color != null ? icon.withColor(color) : icon)
        .toList();
  }
}

final Map<int, Map<int, Map<int, CalendarData>>> calendarData = () {
  final Map<int, Map<int, Map<int, CalendarData>>> result = {};

  final totalDays = Jiffy.parse('2026-12-31', isUtc: true).dayOfYear;

  for (int index = 0; index < totalDays; index++) {
    final Jiffy date = Jiffy.parse('2026-01-01', isUtc: true).add(days: index);

    final bool work = ((date.dayOfWeek - 2) % 7) <= 4;
    final String text = work ? "Business Leave" : "OFF";
    final Color color = work
        ? Color.fromRGBO(220, 110, 77, 1)
        : AppTheme.surface;

    final int year = date.year;
    final int month = date.month;
    final int day = date.date;

    result
        .putIfAbsent(year, () => {})
        .putIfAbsent(month, () => {})[day] = CalendarData(
      color: color,
      text: text,
      blocked: true,
      acitivies: [
        CalendarActivity(
          type: .activity,
          time: Jiffy.parseFromList([
            date.year,
            date.month,
            date.date,
            17,
            0,
          ], isUtc: true),
          text: text,
        ),
        CalendarActivity(
          type: .announcement,
          time: Jiffy.parseFromList([
            date.year,
            date.month,
            date.date,
            17,
            0,
          ], isUtc: true),
          text: text,
        ),
        CalendarActivity(
          type: .firstDay,
          time: Jiffy.parseFromList([
            date.year,
            date.month,
            date.date,
            17,
            0,
          ], isUtc: true),
          text: text,
        ),
        CalendarActivity(
          type: .document,
          time: Jiffy.parseFromList([
            date.year,
            date.month,
            date.date,
            17,
            0,
          ], isUtc: true),
          text: text,
        ),
        CalendarActivity(
          type: .swapShift,
          time: Jiffy.parseFromList([
            date.year,
            date.month,
            date.date,
            17,
            0,
          ], isUtc: true),
          text: text,
        ),
      ],
    );
  }

  return result;
}();
