import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

sealed class CalendarEvent {
  const CalendarEvent();
}

class CalendarNextMonth extends CalendarEvent {}

class CalendarPreviousMonth extends CalendarEvent {}

class CalendarPickDate extends CalendarEvent {
  final int year;
  final int month;
  final int date;
  const CalendarPickDate({
    required this.month,
    required this.date,
    required this.year,
  });
}

class CalendarState {
  final int pickedDate;
  final int pickedMonth;
  final int pickedYear; // ← new
  final int month;
  final int year;

  const CalendarState({
    required this.month,
    required this.year,
    required this.pickedDate,
    required this.pickedMonth,
    required this.pickedYear, // ← new
  });

  Jiffy get jiffy => Jiffy.parseFromList([year, month], isUtc: true);
  Jiffy get pickedJiffy => Jiffy.parseFromList([pickedYear, pickedMonth, pickedDate], isUtc: true);

  CalendarState next() {
    Jiffy r = jiffy.add(months: 1);
    return CalendarState(
      year: r.year,
      month: r.month,
      pickedDate: 1,
      pickedMonth: r.month,
      pickedYear: r.year, // ← new
    );
  }

  CalendarState prev() {
    Jiffy r = jiffy.subtract(months: 1);
    return CalendarState(
      year: r.year,
      month: r.month,
      pickedDate: 1,
      pickedMonth: r.month,
      pickedYear: r.year, // ← new
    );
  }

  (Jiffy date, int place) dateAtIndex(int index) {
    int startAt = (jiffy.dayOfWeek - 2) % 7;
    int diff = index - startAt;
    Jiffy r = jiffy.add(days: diff);
    return (r, r.month - month);
  }

  bool isDiffMonth(CalendarState other) {
    return other.year != year || other.month != month;
  }

  bool isDiffPicked(CalendarState other) {
    return other.pickedDate != pickedDate ||
        other.pickedMonth != pickedMonth ||
        other.pickedYear != pickedYear; // ← new
  }

  bool isSelected(Jiffy cellDate) {
    return pickedDate == cellDate.date &&
        pickedMonth == cellDate.month &&
        pickedYear == cellDate.year; // ← new
  }
}

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({required int month, required int year})
    : super(
        CalendarState(
          month: month,
          year: year,
          pickedDate: 1,
          pickedMonth: month,
          pickedYear: year, // ← new
        ),
      ) {
    on<CalendarNextMonth>((event, emit) => emit(state.next()));
    on<CalendarPreviousMonth>((event, emit) => emit(state.prev()));
    on<CalendarPickDate>(
      (event, emit) => emit(
        CalendarState(
          year: state.year,
          month: state.month,
          pickedDate: event.date,
          pickedMonth: event.month,
          pickedYear: event.year, // ← new
        ),
      ),
    );
  }
}
