import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

sealed class CalendarEvent {}

class CalendarNextMonth extends CalendarEvent {}

class CalendarPreviousMonth extends CalendarEvent {}

class CalendarState {
  final int date;
  final int month;
  final int year;
  const CalendarState({required this.month, required this.year, required this.date});
  Jiffy get jiffy => Jiffy.parseFromList([year, month], isUtc: true);
  CalendarState next() {
    Jiffy r = jiffy.add(months: 1);
    return CalendarState(year: r.year, month: r.month, date: 1);
  }
  CalendarState prev() {
    Jiffy r = jiffy.subtract(months: 1);
    return CalendarState(year: r.year, month: r.month, date: 1);
  }
  (Jiffy date, int place) dateAtIndex(int index) {
    int startAt = (jiffy.dayOfWeek-2)%7;
    int diff = index - startAt;
    Jiffy r = jiffy.add(days: diff);
    late int place;
    if (diff < 0) {
      place = -1;
    }
    else if (r.date <= r.daysInMonth) {
      place = 0;
    }
    else {
      place = 1;
    }
    return (r, place);
  }
  bool isDiffMonth(CalendarState other) {
    return other.month != month || other.year != year;
  }
  bool isDiffDate(CalendarState other) {
    return isDiffMonth(other) || other.date != date;
  }
}

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({required int month, required int year, int date=1})
    : super(CalendarState(month: month, year: year, date: date)) {
    on<CalendarNextMonth>((event, emit) {
      emit(state.next());
    });
    on<CalendarPreviousMonth>((event, emit) {
      emit(state.prev());
    });
  }
}
