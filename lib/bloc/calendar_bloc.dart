// lib/bloc/calendar_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import '../mock/calendar_data.dart';

sealed class CalendarEvent {
  const CalendarEvent();
}

class CalendarNextMonth extends CalendarEvent {}

class CalendarPreviousMonth extends CalendarEvent {}

class CalendarLoadData extends CalendarEvent {}

class CalendarPickDate extends CalendarEvent {
  final int year, month, date;
  const CalendarPickDate({
    required this.month,
    required this.date,
    required this.year,
  });
}

class CalendarAddRequest extends CalendarEvent {
  final CalendarActivity activity;
  const CalendarAddRequest(this.activity);
}

class CalendarState {
  final int pickedDate, pickedMonth, pickedYear, month, year;
  final Map<int, CalendarData> monthData;
  final bool isLoading;

  const CalendarState({
    required this.month,
    required this.year,
    required this.pickedDate,
    required this.pickedMonth,
    required this.pickedYear,
    this.monthData = const {},
    this.isLoading = false,
  });

  Jiffy get jiffy => Jiffy.parseFromList([year, month], isUtc: true);
  Jiffy get pickedJiffy =>
      Jiffy.parseFromList([pickedYear, pickedMonth, pickedDate], isUtc: true);

  CalendarState copyWith({
    int? month,
    int? year,
    int? pickedDate,
    int? pickedMonth,
    int? pickedYear,
    Map<int, CalendarData>? monthData,
    bool? isLoading,
  }) => CalendarState(
    month: month ?? this.month,
    year: year ?? this.year,
    pickedDate: pickedDate ?? this.pickedDate,
    pickedMonth: pickedMonth ?? this.pickedMonth,
    pickedYear: pickedYear ?? this.pickedYear,
    monthData: monthData ?? this.monthData,
    isLoading: isLoading ?? this.isLoading,
  );

  bool isSelected(Jiffy cellDate) =>
      pickedDate == cellDate.date &&
      pickedMonth == cellDate.month &&
      pickedYear == cellDate.year;
  bool isDiffMonth(CalendarState other) =>
      month != other.month || year != other.year;
  bool isDiffPicked(CalendarState other) =>
      pickedDate != other.pickedDate ||
      pickedMonth != other.pickedMonth ||
      pickedYear != other.pickedYear;
  (Jiffy date, int place) dateAtIndex(int index) {
    int startAt = (jiffy.dayOfWeek - 2) % 7;
    Jiffy r = jiffy.add(days: index - startAt);
    return (r, r.month - month);
  }
}

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository repo;
  CalendarBloc({required int month, required int year, required this.repo})
    : super(
        CalendarState(
          month: month,
          year: year,
          pickedDate: 1,
          pickedMonth: month,
          pickedYear: year,
          isLoading: true,
        ),
      ) {
    on<CalendarLoadData>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final data = await repo.getMonthData(state.year, state.month);
      emit(state.copyWith(monthData: data, isLoading: false));
    });

    on<CalendarNextMonth>((event, emit) {
      Jiffy r = state.jiffy.add(months: 1);
      emit(
        state.copyWith(
          year: r.year,
          month: r.month,
          pickedDate: 1,
          pickedMonth: r.month,
          pickedYear: r.year,
        ),
      );
      add(CalendarLoadData());
    });

    on<CalendarPreviousMonth>((event, emit) {
      Jiffy r = state.jiffy.subtract(months: 1);
      emit(
        state.copyWith(
          year: r.year,
          month: r.month,
          pickedDate: 1,
          pickedMonth: r.month,
          pickedYear: r.year,
        ),
      );
      add(CalendarLoadData());
    });

    on<CalendarPickDate>(
      (event, emit) => emit(
        state.copyWith(
          pickedDate: event.date,
          pickedMonth: event.month,
          pickedYear: event.year,
        ),
      ),
    );

    on<CalendarAddRequest>((event, emit) async {
      await repo.addActivity(
        state.pickedYear,
        state.pickedMonth,
        state.pickedDate,
        event.activity,
      );
      add(CalendarLoadData());
    });
  }
}
