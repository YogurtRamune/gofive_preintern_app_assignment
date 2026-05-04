import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/calendar_bloc.dart';
import 'package:flutter_preintern_app/component/help_button.dart';
import 'package:flutter_preintern_app/core/lang_text.dart';
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
        final double realSheetMin =
            (constraint.maxHeight - _Header.height) *
            (3 / 13) /
            constraint.maxHeight;
        final double sheetMinSize = realSheetMin - (7 / constraint.maxHeight);
        final double sheetMidSize =
            1 / 6 * (1 - realSheetMin) +
            realSheetMin -
            (14 / constraint.maxHeight);
        const double sheetMaxSize = 0.85;

        return DraggableScrollableSheet(
          initialChildSize: sheetMinSize,
          minChildSize: sheetMinSize,
          maxChildSize: sheetMaxSize,
          snap: true,
          snapSizes: [sheetMinSize, sheetMidSize, sheetMaxSize],
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
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: BlocBuilder<CalendarBloc, CalendarState>(
                buildWhen: (previous, current) =>
                    previous.isDiffPicked(current),
                builder: (context, state) {
                  final Jiffy jdate = state.pickedJiffy;
                  final langText = LangText.of(context);
                  return Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: .center,
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            '${langText.getDayByNumber(jdate.dayOfWeek, format: .mid)} ${jdate.date} ${langText.getMonthByNumber(jdate.month)}',
                            style: DefaultTextStyle.of(
                              context,
                            ).style.copyWith(fontWeight: .w400, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: ()=>(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Icon(
                                  Icons.open_in_new,
                                  color: ColorScheme.of(context).outlineVariant,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0,0),
                                      color: ColorScheme.of(context).outlineVariant,
                                    ),
                                    Shadow(
                                      offset: Offset(0,1),
                                      color: ColorScheme.of(context).outlineVariant,
                                    ),
                                    Shadow(
                                      offset: Offset(1,0),
                                      color: ColorScheme.of(context).outlineVariant,
                                    ),
                                    Shadow(
                                      offset: Offset(1,1),
                                      color: ColorScheme.of(context).outlineVariant,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: List<Expanded>.generate(6, (row) {
                  return Expanded(
                    child: Row(
                      children: List<Widget>.generate(7, (col) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: _DateCell(index: row * 7 + col),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CellBlockedPainter extends CustomPainter {
  static const double thinBorder = 1;
  static const double thickBorder = 3;
  static const double radius = 5;

  final bool isThickBorder;
  final bool diffMonth;

  const _CellBlockedPainter({
    // ignore: unused_element_parameter
    this.isThickBorder = false,
    this.diffMonth = false,
  });

  static double borderWidth(bool isThickBorder) {
    return isThickBorder ? thickBorder : thinBorder;
  }

  static void clip({
    required Canvas canvas,
    required bool isThickBorder,
    required Size size,
  }) {
    final bsize = borderWidth(isThickBorder);
    canvas.clipRRect(
      RRect.fromLTRBR(
        0 + bsize,
        0 + bsize,
        size.width - bsize,
        size.height - bsize,
        Radius.circular(radius),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    clip(canvas: canvas, isThickBorder: isThickBorder, size: size);

    final double s = size.height > size.width ? size.height : size.width;
    final double sw = s * 0.1;
    final paint = Paint()
      ..color = Colors.red.withAlpha(diffMonth ? 64 : 127)
      ..style = .stroke
      ..strokeWidth = sw;

    void offset(double offset) {
      canvas.drawLine(
        Offset(0 - sw, s + (s * offset) + sw),
        Offset(s + (s * offset) + sw, -sw),
        paint,
      );
    }

    offset(0);
    offset(0.25);
    offset(0.5);
    offset(0.75);
    offset(-0.25);
    offset(-0.5);
    offset(-0.75);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DateCell extends StatelessWidget {
  final int index;

  const _DateCell({required this.index});

  static Color contrastColorPrefer(
    Color baseColor,
    BuildContext ctx, [
    bool flip = false,
  ]) {
    final Color surface = ColorScheme.of(ctx).surface;
    final Color onSurface = ColorScheme.of(ctx).onSurface;
    final double l1 = baseColor.computeLuminance();
    final double l2 = surface.computeLuminance();
    final double contrast = (l1 > l2)
        ? (l1 + 0.05) / (l2 + 0.05)
        : (l2 + 0.05) / (l1 + 0.05);
    final bool condition = contrast >= 1.6;
    return (flip ? !condition : condition) ? surface : onSurface;
  }

  BoxDecoration _cellDecoration(
    BuildContext context,
    Color color,
    bool isThickBorder,
    CalendarState state,
    Jiffy date,
    bool blocked,
  ) {
    final bool blockedSelected = state.isSelected(date) && blocked;
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(_CellBlockedPainter.radius),
      border: Border.all(
        color: blockedSelected
            ? ColorScheme.of(context).primary
            : ColorScheme.of(context).outline,
        width: _CellBlockedPainter.borderWidth(blockedSelected),
      ),
    );
  }

  Widget _buildDateCircle(
    BuildContext context, {
    required CalendarState state, // added
    required Jiffy date,
    required Color color,
    required int alpha,
    required bool blocked,
  }) {
    final bool selected = state.isSelected(date); // moved out of BlocBuilder
    final Color contrastColor = contrastColorPrefer(
      color,
      context,
    ).withAlpha(alpha);

    return Align(
      alignment: const Alignment(0, -0.85),
      child: FractionallySizedBox(
        widthFactor: 0.35,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            // BlocBuilder removed, Stack is now the direct child
            children: [
              if (selected & !blocked)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: contrastColor,
                    ),
                  ),
                ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraint) => Center(
                    child: Text(
                      date.date.toString(),
                      textAlign: TextAlign.center,
                      style: DefaultTextStyle.of(context).style.copyWith(
                        color: contrastColorPrefer(
                          color,
                          context,
                          selected && !blocked,
                        ).withAlpha(alpha),
                        height: 0,
                        fontSize: constraint.maxHeight / 1.8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(
    BuildContext context, {
    required String text,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Center(
        child: AutoSizeText(
          text.replaceFirst(' ', '\n'),
          textAlign: TextAlign.center,
          style: DefaultTextStyle.of(
            context,
          ).style.copyWith(color: textColor, height: 0),
          minFontSize: 8,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (previous, current) =>
          previous.isDiffPicked(current), // updated
      builder: (context, state) {
        final (date, place) = state.dateAtIndex(index);
        final CalendarData? data =
            calendarData[date.year]?[date.month]?[date.date];

        const bool isThickBorder = false;
        final int alpha = place == 0 ? 255 : 127;
        final Color color = (data?.color ?? Colors.purple).withAlpha(alpha);
        final Color textColor = contrastColorPrefer(
          color,
          context,
        ).withAlpha(alpha);
        final bool blocked = data?.blocked ?? false;
        final String text = data?.text ?? 'N/A';

        return GestureDetector(
          onTap: () => context.read<CalendarBloc>().add(
            CalendarPickDate(
              year: date.year,
              month: date.month,
              date: date.date,
            ),
          ),
          child: DecoratedBox(
            decoration: _cellDecoration(
              context,
              color,
              isThickBorder,
              state,
              date,
              blocked,
            ),
            child: Stack(
              children: [
                if (blocked)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CellBlockedPainter(
                        isThickBorder: isThickBorder,
                        diffMonth: place != 0,
                      ),
                    ),
                  ),
                _buildDateCircle(
                  context,
                  state: state, // passed down
                  date: date,
                  color: color,
                  alpha: alpha,
                  blocked: blocked,
                ),
                _buildLabel(context, text: text, textColor: textColor),
              ],
            ),
          ),
        );
      },
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
                buildWhen: (previous, current) => previous.isDiffMonth(current),
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
