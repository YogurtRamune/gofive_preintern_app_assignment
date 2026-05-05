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
  final CalendarRequest request;
  const CalendarAddRequest(this.request);
}

typedef CalendarVisibleMonthData =
    Map<({int year, int month}), Map<int, CalendarData>>;

class CalendarState {
  final int pickedDate, pickedMonth, pickedYear, month, year;
  final CalendarVisibleMonthData visibleMonthData;
  final bool isLoading;

  const CalendarState({
    required this.month,
    required this.year,
    required this.pickedDate,
    required this.pickedMonth,
    required this.pickedYear,
    this.visibleMonthData = const {},
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
    CalendarVisibleMonthData? visibleMonthData,
    bool? isLoading,
  }) => CalendarState(
    month: month ?? this.month,
    year: year ?? this.year,
    pickedDate: pickedDate ?? this.pickedDate,
    pickedMonth: pickedMonth ?? this.pickedMonth,
    pickedYear: pickedYear ?? this.pickedYear,
    visibleMonthData: visibleMonthData ?? this.visibleMonthData,
    isLoading: isLoading ?? this.isLoading,
  );

  CalendarData? dataFor(int year, int month, int date) =>
      visibleMonthData[(year: year, month: month)]?[date];

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
      final int loadYear = state.year;
      final int loadMonth = state.month;
      emit(state.copyWith(isLoading: true));
      final data = await _getVisibleMonthData(loadYear, loadMonth);

      if (state.year != loadYear || state.month != loadMonth) return;

      emit(state.copyWith(visibleMonthData: data, isLoading: false));
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
          visibleMonthData: {}, // clear stale data immediately
          isLoading: true, // cells go invisible this same frame
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
          visibleMonthData: {}, // clear stale data immediately
          isLoading: true, // cells go invisible this same frame
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
      await repo.addRequest(
        state.pickedYear,
        state.pickedMonth,
        state.pickedDate,
        event.request,
      );
      add(CalendarLoadData());
    });
  }

  Future<CalendarVisibleMonthData> _getVisibleMonthData(
    int year,
    int month,
  ) async {
    final months = [
      Jiffy.parseFromList([year, month], isUtc: true).subtract(months: 1),
      Jiffy.parseFromList([year, month], isUtc: true),
      Jiffy.parseFromList([year, month], isUtc: true).add(months: 1),
    ];

    final entries = await Future.wait(
      months.map((date) async {
        final data = Map<int, CalendarData>.from(
          await repo.getMonthData(date.year, date.month),
        );
        return MapEntry((year: date.year, month: date.month), data);
      }),
    );

    return Map.fromEntries(entries);
  }
}
