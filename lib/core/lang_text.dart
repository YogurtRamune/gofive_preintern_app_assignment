import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/language_bloc.dart';
import 'package:flutter_preintern_app/core/enum/language_enum.dart';

/// Enum to handle the three different display lengths for days[cite: 1]
enum DayFormat { short, mid, full }

const Map<LanguageEnum, Map<String, String>> _localizeMap = {
  LanguageEnum.uk: {
    'january': 'January',
    'february': 'February',
    'march': 'March',
    'april': 'April',
    'may': 'May',
    'june': 'June',
    'july': 'July',
    'august': 'August',
    'september': 'September',
    'october': 'October',
    'november': 'November',
    'december': 'December',
    'mon_short': 'M', 'mon_mid': 'Mon', 'monday': 'Monday',
    'tue_short': 'T', 'tue_mid': 'Tue', 'tuesday': 'Tuesday',
    'wed_short': 'W', 'wed_mid': 'Wed', 'wednesday': 'Wednesday',
    'thu_short': 'TH', 'thu_mid': 'Thu', 'thursday': 'Thursday',
    'fri_short': 'F', 'fri_mid': 'Fri', 'friday': 'Friday',
    'sat_short': 'S', 'sat_mid': 'Sat', 'saturday': 'Saturday',
    'sun_short': 'S', 'sun_mid': 'Sun', 'sunday': 'Sunday',
    'abnormal_status': 'Abnormal working status',
    'overtime': 'Overtime',
    'document': 'Document',
    'activity': 'Activity',
    'announcement': 'Announcement',
    'swap_shift': 'Swap shift',
    'interview': 'Interview',
    'birthday': 'Birthday',
    'first_day': 'First Day at Work',
    'last_day': 'Last Working Day',
    'leave': 'Leave',
    'offsite_work': 'Offsite Work',
    'overtime_request': 'Overtime',
    'endorse': 'Endorse',
    'collect_time_date': 'Collect Time Date',
    'redeem': 'Redeem',
    'expense': 'Expense',
  },
  LanguageEnum.th: {
    'january': 'มกราคม',
    'february': 'กุมภาพันธ์',
    'march': 'มีนาคม',
    'april': 'เมษายน',
    'may': 'พฤษภาคม',
    'june': 'มิถุนายน',
    'july': 'กรกฎาคม',
    'august': 'สิงหาคม',
    'september': 'กันยายน',
    'october': 'ตุลาคม',
    'november': 'พฤศจิกายน',
    'december': 'ธันวาคม',
    'mon_short': 'จ', 'mon_mid': 'จ.', 'monday': 'จันทร์',
    'tue_short': 'อ', 'tue_mid': 'อ.', 'tuesday': 'อังคาร',
    'wed_short': 'พ', 'wed_mid': 'พ.', 'wednesday': 'พุธ',
    'thu_short': 'พฤ', 'thu_mid': 'พฤ.', 'thursday': 'พฤหัสบดี',
    'fri_short': 'ศ', 'fri_mid': 'ศ.', 'friday': 'ศุกร์',
    'sat_short': 'ส', 'sat_mid': 'ส.', 'saturday': 'เสาร์',
    'sun_short': 'อา', 'sun_mid': 'อา.', 'sunday': 'อาทิตย์',
    'abnormal_status': 'สถานะการทำงานผิดปกติ',
    'overtime': 'ทำงานล่วงเวลา',
    'document': 'เอกสาร',
    'activity': 'กิจกรรม',
    'announcement': 'ประกาศ',
    'swap_shift': 'สลับกะ',
    'interview': 'นัดสัมภาษณ์',
    'birthday': 'วันเกิด',
    'first_day': 'เริ่มงานวันแรก',
    'last_day': 'สิ้นสุดการทำงาน',
    'leave': 'ลางาน',
    'offsite_work': 'ปฏิบัติงานนอกสถานที่',
    'overtime_request': 'ล่วงเวลา',
    'endorse': 'รับรองเวลา',
    'collect_time_date': 'ขอสะสมเวลา',
    'redeem': 'แลกเวลา',
    'expense': 'ค่าใช้จ่าย',
  },
};

class LangText {
  final Map<String, String>? _map;
  LangText(LanguageEnum langEnum) : _map = _localizeMap[langEnum];

  String operator [](String key) {
    return _map?[key] ?? 'N/A';
  }

  factory LangText.of(BuildContext context) {
    return LangText(context.watch<LanguageBloc>().state);
  }

  /// Returns the day string based on number (1-7) and the desired format[cite: 1]
  String getDayByNumber(int dayNum, {DayFormat format = DayFormat.full}) {
    final Map<int, Map<DayFormat, String>> dayKeys = {
      1: {
        DayFormat.short: 'sun_short',
        DayFormat.mid: 'sun_mid',
        DayFormat.full: 'sunday',
      },
      2: {
        DayFormat.short: 'mon_short',
        DayFormat.mid: 'mon_mid',
        DayFormat.full: 'monday',
      },
      3: {
        DayFormat.short: 'tue_short',
        DayFormat.mid: 'tue_mid',
        DayFormat.full: 'tuesday',
      },
      4: {
        DayFormat.short: 'wed_short',
        DayFormat.mid: 'wed_mid',
        DayFormat.full: 'wednesday',
      },
      5: {
        DayFormat.short: 'thu_short',
        DayFormat.mid: 'thu_mid',
        DayFormat.full: 'thursday',
      },
      6: {
        DayFormat.short: 'fri_short',
        DayFormat.mid: 'fri_mid',
        DayFormat.full: 'friday',
      },
      7: {
        DayFormat.short: 'sat_short',
        DayFormat.mid: 'sat_mid',
        DayFormat.full: 'saturday',
      },
    };

    final key = dayKeys[dayNum]?[format];
    return key != null ? this[key] : 'N/A';
  }

  String getMonthByNumber(int monthNum) {
    final months = {
      1: 'january',
      2: 'february',
      3: 'march',
      4: 'april',
      5: 'may',
      6: 'june',
      7: 'july',
      8: 'august',
      9: 'september',
      10: 'october',
      11: 'november',
      12: 'december',
    };

    final key = months[monthNum];
    return key != null ? this[key] : 'N/A';
  }
}
