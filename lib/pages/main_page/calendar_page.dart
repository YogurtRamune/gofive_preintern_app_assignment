import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/calendar_bloc.dart';
import 'package:flutter_preintern_app/component/help_button.dart';
import 'package:flutter_preintern_app/core/lang_text.dart';
import 'package:flutter_preintern_app/mock/calendar_data.dart'
    show
        CalendarActivity,
        CalendarActivityEnum,
        CalendarData,
        CalendarRepository,
        CalendarRequest;
import 'package:jiffy/jiffy.dart';

class CalendarPage extends StatelessWidget {
  final int month, year;
  const CalendarPage({super.key, this.month = 2, this.year = 2026});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CalendarRepository(),
      child: BlocProvider(
        create: (context) => CalendarBloc(
          month: month,
          year: year,
          repo: context.read<CalendarRepository>(),
        )..add(CalendarLoadData()),
        child: const _CalendarView(),
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              _Header(),
              Flexible(flex: 10, child: _Body()),
              const Flexible(flex: 3, child: SizedBox.expand()),
            ],
          ),
          Positioned.fill(child: _BottomSheet()),
        ],
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
              child: BlocBuilder<CalendarBloc, CalendarState>(
                buildWhen: (previous, current) =>
                    previous.isDiffPicked(current) ||
                    previous.visibleMonthData != current.visibleMonthData ||
                    previous.isLoading != current.isLoading,
                builder: (context, state) {
                  final CalendarData? dayData = state.dataFor(
                    state.pickedYear,
                    state.pickedMonth,
                    state.pickedDate,
                  );
                  final List<CalendarActivity> activities =
                      [...(dayData?.acitivies ?? const <CalendarActivity>[])]
                        ..sort(
                          (a, b) => a.time
                              .format(pattern: 'HH:mm')
                              .compareTo(b.time.format(pattern: 'HH:mm')),
                        );
                  final Set<CalendarRequest> requests = dayData?.requests ?? {};

                  return CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      _BottomSheetHeader(),
                      SliverToBoxAdapter(child: SizedBox(height: 15)),
                      if (state.isLoading)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else ...[
                        if (activities.isNotEmpty)
                          SliverFixedExtentList(
                            itemExtent: 40,
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final act = activities[i];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 20,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: ColorScheme.of(context).surface,
                                    borderRadius: .circular(7),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: .max,
                                      children: [
                                        Text(act.time.format(pattern: 'HH:mm')),
                                        SizedBox(width: 50),
                                        act.type.icon,
                                        SizedBox(width: 10),
                                        Text(act.text),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: activities.length),
                          ),
                        if (requests.isNotEmpty)
                          SliverFixedExtentList(
                            itemExtent: 40,
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final req = requests.elementAt(i);
                              final lang = LangText.of(context);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 20,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: ColorScheme.of(context).surface,
                                    borderRadius: .circular(7),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: .max,
                                      children: [
                                        SizedBox(width: 90),
                                        req.icon.withColor(
                                          ColorScheme.of(context).primary,
                                        ),
                                        SizedBox(width: 10),
                                        Text(lang[req.langKey]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: requests.length),
                          ),
                      ],
                    ],
                  );
                },
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
                            onTap: () => (),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Icon(
                                  Icons.open_in_new,
                                  color: ColorScheme.of(context).outlineVariant,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 0),
                                      color: ColorScheme.of(
                                        context,
                                      ).outlineVariant,
                                    ),
                                    Shadow(
                                      offset: Offset(0, 1),
                                      color: ColorScheme.of(
                                        context,
                                      ).outlineVariant,
                                    ),
                                    Shadow(
                                      offset: Offset(1, 0),
                                      color: ColorScheme.of(
                                        context,
                                      ).outlineVariant,
                                    ),
                                    Shadow(
                                      offset: Offset(1, 1),
                                      color: ColorScheme.of(
                                        context,
                                      ).outlineVariant,
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
  // Mon→Sun maps to dayNum 2,3,4,5,6,7,1 in getDayByNumber
  static const _weekOrder = [2, 3, 4, 5, 6, 7, 1];

  @override
  Widget build(BuildContext context) {
    final lang = LangText.of(context);

    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Row(
            children: _weekOrder
                .map(
                  (dayNum) => Expanded(
                    child: Center(
                      child: Text(
                        lang.getDayByNumber(dayNum, format: DayFormat.short),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ColoredBox(
            color: ColorScheme.of(context).surfaceContainerHigh,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
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
                BlocBuilder<CalendarBloc, CalendarState>(
                  buildWhen: (previous, current) =>
                      previous.isLoading != current.isLoading,
                  builder: (context, state) => state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink(),
                ),
              ],
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
    bool blockedSelected,
  ) {
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
    required CalendarState state,
    required Jiffy date,
    required Color color,
    required int alpha,
    required bool blocked,
  }) {
    final bool selected = state.isSelected(date);
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

  Widget _buildIcons(
    BuildContext context,
    CalendarData? data, [
    bool blockedSelected = false,
    Color? color,
    bool hasAbnormal = false,
  ]) {
    final double borderPadding = _CellBlockedPainter.borderWidth(
      blockedSelected,
    );
    return Align(
      alignment: .bottomCenter,
      widthFactor: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: .bottomCenter,
            child: Padding(
              padding: .only(
                left: borderPadding,
                right: borderPadding,
              ),
              child: Container(
                height: constraints.maxHeight / 4.5,
                decoration: BoxDecoration(
                  // Red background from theme when any abnormal activity exists
                  color: hasAbnormal
                      ? ColorScheme.of(context).errorContainer
                      : Colors.transparent,
                  borderRadius: .vertical(
                    bottom: Radius.circular(5 - borderPadding),
                  ),
                ),
                child: Padding(
                  padding: .only(bottom: _CellBlockedPainter.thickBorder),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: (data?.icons(color) ?? [])
                        .map((e) => Expanded(child: e))
                        .toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (previous, current) =>
          previous.isDiffPicked(current) ||
          previous.isDiffMonth(current) ||
          previous.visibleMonthData != current.visibleMonthData ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) return const SizedBox.expand();

        final (date, place) = state.dateAtIndex(index);
        final CalendarData? data = state.dataFor(
          date.year,
          date.month,
          date.date,
        );

        final int alpha = place == 0 ? 255 : 127;
        final Color color = (data?.color ?? Colors.purple).withAlpha(alpha);
        final Color textColor = contrastColorPrefer(
          color,
          context,
        ).withAlpha(alpha);
        final bool blocked = data?.blocked ?? false;
        final String text = data?.text ?? 'N/A';
        final blockSelected = state.isSelected(date) && blocked;

        // True when at least one activity on this day is of type abnormal
        final bool hasAbnormal =
            data?.acitivies.any(
              (a) => a.type == CalendarActivityEnum.abnormal,
            ) ??
            false;

        return GestureDetector(
          onTap: () => context.read<CalendarBloc>().add(
            CalendarPickDate(
              year: date.year,
              month: date.month,
              date: date.date,
            ),
          ),
          child: DecoratedBox(
            decoration: _cellDecoration(context, color, blockSelected),
            child: Stack(
              children: [
                if (blocked)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CellBlockedPainter(
                        isThickBorder: blocked && state.isSelected(date),
                        diffMonth: place != 0,
                      ),
                    ),
                  ),
                _buildDateCircle(
                  context,
                  state: state,
                  date: date,
                  color: color,
                  alpha: alpha,
                  blocked: blocked,
                ),
                _buildIcons(
                  context,
                  data,
                  blockSelected,
                  textColor,
                  hasAbnormal,
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
                          onTap: (context) => showModalBottomSheet(
                            context: context,
                            builder: (context) => _SymbolDescriptionSheet(),
                          ),
                          color: Colors.transparent,
                          borderColor: scheme.onSurface,
                          borderWidth: 2,
                          iconColor: scheme.onSurface,
                        );
                      },
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.add, size: 30),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (modalContext) => _CalendarRequestSheet(
                            calendarBloc: context.read<CalendarBloc>(),
                          ),
                        );
                      },
                    ),
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

class _CalendarRequestSheet extends StatelessWidget {
  final CalendarBloc calendarBloc;

  const _CalendarRequestSheet({required this.calendarBloc});

  @override
  Widget build(BuildContext context) {
    final lang = LangText.of(context);
    final textTheme = TextTheme.of(context);
    final scheme = ColorScheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: CalendarRequest.values.map((request) {
            return ListTile(
              leading: SizedBox(
                width: 20,
                height: 20,
                child: request.icon.withColor(scheme.primary),
              ),
              title: Text(lang[request.langKey], style: textTheme.bodyLarge),
              onTap: () {
                calendarBloc.add(CalendarAddRequest(request));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SymbolDescriptionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lang = LangText.of(context);
    final scheme = ColorScheme.of(context);
    final textTheme = TextTheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang['symbol_description'],
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...CalendarActivityEnum.values.expand(
              (activity) => [
                const Spacer(),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: activity.icon.withColor(scheme.onSurface),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      lang[activity.localizationKey],
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
