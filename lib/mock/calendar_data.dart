import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';
import 'package:jiffy/jiffy.dart';

// Renamed from CalendarActivityIcon to CalendarIcon to suit both contexts
class CalendarIcon extends StatelessWidget {
  final String? emoji;
  final IconData? iconData;
  final Color? color;
  const CalendarIcon({super.key, this.emoji, this.iconData, this.color})
    : assert((emoji == null) != (iconData == null));

  CalendarIcon withColor(Color color) =>
      CalendarIcon(key: key, emoji: emoji, iconData: iconData, color: color);

  @override
  Widget build(BuildContext context) {
    late final Widget r;
    if (emoji is String) {
      r = Text(emoji!, style: TextStyle(color: color));
    } else if (iconData is IconData) {
      r = Icon(iconData!, color: color);
    } else {
      r = const Placeholder();
    }
    return AspectRatio(aspectRatio: 1, child: FittedBox(child: r));
  }
}

enum CalendarActivityEnum {
  abnormal(
    'abnormal_status',
    CalendarIcon(iconData: Icons.warning_amber_rounded),
  ),
  overtime('overtime', CalendarIcon(iconData: Icons.more_time)),
  document('document', CalendarIcon(iconData: Icons.description_outlined)),
  activity('activity', CalendarIcon(iconData: Icons.calendar_month)),
  announcement('announcement', CalendarIcon(emoji: '📢')),
  swapShift('swap_shift', CalendarIcon(iconData: Icons.swap_horiz)),
  interview('interview', CalendarIcon(emoji: '🤝')),
  birthday('birthday', CalendarIcon(emoji: '🎂')),
  firstDay('first_day', CalendarIcon(emoji: '👋')),
  lastDay('last_day', CalendarIcon(emoji: '🍂'));

  final String localizationKey;
  final CalendarIcon icon;
  const CalendarActivityEnum(this.localizationKey, this.icon);
}

enum CalendarRequest {
  leave('leave', CalendarIcon(iconData: Icons.event_busy_outlined)),
  offsiteWork('offsite_work', CalendarIcon(iconData: Icons.home_work_outlined)),
  overtimeRequest('overtime_request', CalendarIcon(iconData: Icons.timer_outlined)),
  endorse('endorse', CalendarIcon(iconData: Icons.verified_outlined)),
  collectTimeDate(
    'collect_time_date',
    CalendarIcon(iconData: Icons.edit_calendar_outlined),
  ),
  redeem('redeem', CalendarIcon(iconData: Icons.redeem_outlined)),
  expense('expense', CalendarIcon(iconData: Icons.receipt_long_outlined));

  final String langKey;
  final CalendarIcon icon; // Added icon field
  const CalendarRequest(this.langKey, this.icon);
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

  CalendarData copyWith({
    Color? color,
    String? text,
    bool? blocked,
    Set<CalendarRequest>? requests,
    List<CalendarActivity>? acitivies,
  }) {
    return CalendarData(
      color: color ?? this.color,
      text: text ?? this.text,
      blocked: blocked ?? this.blocked,
      requests: requests ?? this.requests,
      acitivies: acitivies ?? this.acitivies,
    );
  }

  List<Widget> icons([Color? color]) {
    // Collects icons from both activities and requests
    Set<CalendarIcon> iconEnums = {};
    for (var element in acitivies) {
      iconEnums.add(element.type.icon);
    }
    for (var element in requests) {
      iconEnums.add(element.icon);
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
      blocked: false,
      acitivies: [],
    );
  }

  return result;
}();

class CalendarRepository {
  // Initialize with the existing mock data
  final Map<int, Map<int, Map<int, CalendarData>>> _db = Map.from(calendarData);

  Future<Map<int, CalendarData>> getMonthData(int year, int month) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 100));
    return _db[year]?[month] ?? {};
  }

  Future<void> addActivity(int year, int month, int date, CalendarActivity activity) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    _db.putIfAbsent(year, () => {});
    _db[year]!.putIfAbsent(month, () => {});
    
    final currentDayData = _db[year]![month]![date];

    if (currentDayData != null) {
      // Update existing day entry
      _db[year]![month]![date] = currentDayData.copyWith(
        acitivies: [...currentDayData.acitivies, activity],
      );
    } else {
      // Create new day entry if empty
      _db[year]![month]![date] = CalendarData(
        color: const Color.fromRGBO(220, 110, 77, 1),
        text: "New Activity",
        acitivies: [activity],
      );
    }
  }

  Future<void> addRequest(int year, int month, int date, CalendarRequest request) async {
    await Future.delayed(const Duration(milliseconds: 50));

    _db.putIfAbsent(year, () => {});
    _db[year]!.putIfAbsent(month, () => {});

    final currentDayData = _db[year]![month]![date];

    if (currentDayData != null) {
      _db[year]![month]![date] = currentDayData.copyWith(
        requests: {...currentDayData.requests, request},
      );
    } else {
      _db[year]![month]![date] = CalendarData(
        color: const Color.fromRGBO(220, 110, 77, 1),
        text: "New Request",
        requests: {request},
      );
    }
  }
}
