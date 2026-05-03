import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/calendar_bloc.dart';
import 'package:flutter_preintern_app/component/help_button.dart';
import 'package:flutter_preintern_app/mock/calendar_data.dart';
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
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
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
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  // ── Pinned header that doubles as the drag handle ─────────
                  _BottomSheetHeader(),
                  SliverFixedExtentList(
                    itemExtent: 56,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                        leading: const Icon(Icons.event),
                        title: Text('Event $index'),
                        subtitle: Text('Description for event $index'),
                      ),
                      childCount: 20,
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

class _BottomSheetHeader extends StatelessWidget {
  static const double _spaceHeight = 40;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _spaceHeight,
      expandedHeight: _spaceHeight,
      collapsedHeight: _spaceHeight,
      flexibleSpace: Stack(
        children: [
          _BottomSheetHandle(),
          Align(
            alignment: .centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  Jiffy jdate = state.jiffy;
                  return Row(
                    children: [
                      Text('${jdate.dayOfWeek} ${jdate.date} ${jdate.month}'),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topCenter,
      child: Padding(
        padding: .only(top: 5),
        child: SizedBox(
          height: 5,
          child: FractionallySizedBox(
            widthFactor: 0.15,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: ColorScheme.of(context).outline,
              ),
            ),
          ),
        ),
      ),
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
          child: ColoredBox(
            color: ColorScheme.of(context).surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, top: 2),
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
                                padding: const EdgeInsets.all(3),
                                child: _DateCell(date: date, place: place, selected: true,),
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
        ),
      ],
    );
  }
}

class _DateCell extends StatelessWidget {
  final Jiffy date;
  final bool selected;
  final int place;

  const _DateCell({
    required this.date,
    required this.place,
    this.selected = false,
  }) : assert(-1 <= place && place <= 1);

  static Color contrastColorPrefer(
    Color baseColor,
    BuildContext ctx, [
    bool flip = false,
  ]) {
    final Color surface = ColorScheme.of(ctx).surface;
    final Color onSurface = ColorScheme.of(ctx).onSurface;
    final double l1 = baseColor.computeLuminance();
    final double l2 = surface.computeLuminance();
    double contrast = (l1 > l2)
        ? (l1 + 0.05) / (l2 + 0.05)
        : (l2 + 0.05) / (l1 + 0.05);
    final bool condition = contrast >= 1.6;
    return (flip ? !condition : condition) ? surface : onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final CalendarData? data = calendarData[date.year]?[date.month]?[date.date];
    final Color color = data?.color ?? Colors.purple;
    final String text = data?.text ?? 'N/A';
    final Color textColor = contrastColorPrefer(color, context);
    final Color dateColor = contrastColorPrefer(color, context, selected);
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: .circular(3)),
      child: Stack(
        children: [
          Align(
            alignment: .xy(0, -0.9),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    if (selected) Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(shape: .circle, color: contrastColorPrefer(color, context)),
                      ),
                    ),
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return Center(
                            child: Text(
                              date.date.toString(),
                              textAlign: .center,
                              style: DefaultTextStyle.of(
                                context,
                              ).style.copyWith(color: dateColor, height: 0, fontSize: constraint.maxHeight/1.8, fontWeight: .w800),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
                // child: ColoredBox(color: Colors.black)
              ),
            ),
          ),
          Center(
            child: Text(
              text,
              textAlign: .center,
              style: DefaultTextStyle.of(
                context,
              ).style.copyWith(color: textColor),
            ),
          ),
        ],
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
