import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/calendar_bloc.dart';
import 'package:flutter_preintern_app/component/help_button.dart';
import 'package:jiffy/jiffy.dart';

class CalendarPage extends StatelessWidget {
  final int month;
  final int year;
  const CalendarPage({super.key, this.month = 2, this.year = 2026});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc(month: month, year: year),
      child: SafeArea(
        child: Stack(
          fit: .expand,
          children: [
            // Reserve the same bottom space the Placeholder used to occupy
            // so the calendar grid isn't obscured by the sheet at rest.
            Column(
              children: [
                _Header(),
                Flexible(flex: 10, child: _Body()),
                Flexible(flex: 3, child: SizedBox.expand()),
              ],
            ),
            Positioned.fill(child: _BottomSheet()),
          ],
        ),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final double sheetMinSize =
            (constraint.maxHeight - _Header.height) *
                (3 / 13) /
                constraint.maxHeight -
            (7 / constraint.maxHeight);
        const double sheetMaxSize = 0.85;

        return DraggableScrollableSheet(
          initialChildSize: sheetMinSize,
          minChildSize: sheetMinSize,
          maxChildSize: sheetMaxSize,
          snap: true,
          snapSizes: [sheetMinSize, sheetMaxSize],
          builder: (context, scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: .only(top: 20.0),
                      itemBuilder: (context, index) {
                        return Text('${index}th meow');
                      },
                    ),
                  ),
                  IgnorePointer(
                    child: Align(
                      alignment: .topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                        child: SizedBox(
                          height: 5,
                          child: FractionallySizedBox(
                            widthFactor: 0.15,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).colorScheme.outline,
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Row(
            children: [
              "จ",
              "อ",
              "พ",
              "พฤ",
              "ศ",
              "ส",
              "อา",
            ].map((day) => Expanded(child: Center(child: Text(day)))).toList(),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: BlocBuilder<CalendarBloc, CalendarState>(
              buildWhen: (previous, current) => previous.isDiffMonth(current),
              builder: (context, state) {
                const ncol = 7;
                const nrow = 6;
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: List<Expanded>.generate(nrow, (row) {
                    return Expanded(
                      child: Row(
                        children: List<Widget>.generate(ncol, (col) {
                          // debugPrint('$row, $col, ${row * ncol + col}');
                          final (date, place) = state.dateAtIndex(
                            (row * ncol) + col,
                          );
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: DateCell(date: date, place: place),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DateCell extends StatelessWidget {
  final Jiffy date;
  final int place;

  const DateCell({super.key, required this.date, required this.place})
    : assert(-1 <= place && place <= 1);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: (row+col)%2==0 ? Colors.blue : Colors.orange
    // );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ((date.millisecondsSinceEpoch) / 86400000).floor() % 2 == 0
            ? Colors.blue
            : Colors.orange,
        borderRadius: .circular(3),
      ),
      child: Center(
        child: Text(
          '$place ${date.date}',
          style: TextTheme.of(context).labelSmall,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  static const double _arrowOffset = 0.55;
  static const double height = 40;

  static LayoutBuilder arrowIcon(CalendarEvent event, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return IconButton(
          onPressed: () => context.read<CalendarBloc>().add(event),
          icon: Icon(icon),
          padding: .zero,
          iconSize: constraint.maxHeight * 0.75,
          constraints: .new(
            minHeight: constraint.maxHeight,
            minWidth: constraint.maxHeight,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(-_arrowOffset, 0),
                child: arrowIcon(
                  CalendarPreviousMonth(),
                  Icons.keyboard_arrow_left,
                ),
              ),
              BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  return Center(
                    child: Text(
                      '${state.month} ${state.year}',
                      style: TextTheme.of(
                        context,
                      ).titleMedium?.copyWith(letterSpacing: 0),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment(_arrowOffset, 0),
                child: arrowIcon(
                  CalendarNextMonth(),
                  Icons.keyboard_arrow_right,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(
                      builder: (context) {
                        final scheme = ColorScheme.of(context);
                        return HelpButton(
                          color: Colors.transparent,
                          borderColor: scheme.onSurface,
                          borderWidth: 2,
                          iconColor: scheme.onSurface,
                        );
                      },
                    ),
                    SizedBox(width: 5),
                    GestureDetector(child: Icon(Icons.add, size: 30)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
