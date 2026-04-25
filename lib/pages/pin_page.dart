import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class _PinNotifier extends InheritedNotifier<ValueNotifier<List<int>>> {
  const _PinNotifier({
    // ignore: unused_element_parameter
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<List<int>> of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<_PinNotifier>()!.notifier!;
  }

   static ValueNotifier<List<int>> dependOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_PinNotifier>()!.notifier!;
  }

  static void addDigitOf(BuildContext context, int digit) {
    final notifier = of(context);
    if (notifier.value.length < 6) {
      notifier.value = [...notifier.value, digit];
    }
  }

  static void deleteDigitOf(BuildContext context) {
    final notifier = of(context);
    if (notifier.value.isNotEmpty) {
      notifier.value = notifier.value.sublist(0, notifier.value.length - 1);
    }
  }

  static double alphaOf(BuildContext context) {
    return of(context).value.length / 6.0;
  }

  static ({int filled, int empty}) filledOf(BuildContext context) {
    int filled = dependOf(context).value.length;
    return (empty: 6 - filled, filled: filled);
  }
}

class PinPage extends StatelessWidget {
  const PinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PinNotifier(
      notifier: ValueNotifier(<int>[]),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 251, 254, 255),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constrain) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Image.asset('asset/img/deco/pin_bg.png'),
                        ),
                        Align(
                          alignment: Alignment(0, -0.5),
                          child: Column(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                "Create your PIN",
                                style: Theme.of(context)
                                    .extension<AppTextStyles>()!
                                    .sectionHeader
                                    .copyWith(fontSize: 17),
                              ),
                              Text(
                                "To allow secure access to app and payslip information",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(letterSpacing: -0.2),
                              ),
                              SizedBox(height: 25),
                              SizedBox.square(
                                dimension: 80,
                                child: Stack(
                                  children: [
                                    SizedBox.expand(child: _PinIndicator()),
                                    SizedBox.expand(
                                      child: Padding(
                                        padding: .all(2),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            shape: .circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.lock,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Enter 6 digit pin code.",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(letterSpacing: -0.2),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 25,
                                child: FractionallySizedBox(
                                  widthFactor: 0.3,
                                  child: _PinCircles(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: constrain.maxHeight / 3,
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: Row(
                        children: [
                          Flexible(flex: 1, child: SizedBox.expand()),
                          Flexible(
                            flex: 3,
                            child: Column(
                              children: [
                                Flexible(flex: 1, child: SizedBox.expand()),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('1'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 1),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('4'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 4),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('7'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 7),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(child: SizedBox.shrink()),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Column(
                              children: [
                                Flexible(flex: 1, child: SizedBox.expand()),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('2'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 2),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('5'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 5),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('8'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 8),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('0'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Column(
                              children: [
                                Flexible(flex: 1, child: SizedBox.expand()),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('3'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 3),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('6'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 6),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('9'),
                                    onTap: (ctx) =>
                                        _PinNotifier.addDigitOf(ctx, 9),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Icon(Icons.backspace_outlined),
                                    onTap: (ctx) =>
                                        _PinNotifier.deleteDigitOf(ctx),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(flex: 1, child: SizedBox.expand()),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PinCircle extends StatelessWidget {
  final bool filled;
  const _PinCircle({
    // ignore: unused_element_parameter
    super.key,
    filled,
  }) : filled = filled ?? false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraint) {
        double heightBased = constraint.maxHeight / 2.5;
        double widthBased = constraint.maxWidth / 6;
        final size = min(heightBased, widthBased);
        return SizedBox.square(
          dimension: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: (filled)
                  ? null
                  : .all(color: theme.colorScheme.outline, width: 1.5),
              color: (filled) ? theme.primaryColor : null,
              shape: .circle,
            ),
          ),
        );
      },
    );
  }
}

class _PinCircles extends StatelessWidget {
  const _PinCircles({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming _PinNotifier.filledOf returns a record with {int filled, int empty}
    var (:filled, :empty) = _PinNotifier.filledOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Generate 'filled' number of circles
        ...List.generate(filled, (index) => const _PinCircle(filled: true)),

        // Generate 'empty' number of circles
        ...List.generate(empty, (index) => const _PinCircle(filled: false)),
      ],
    );
  }
}

class _PinIndicator extends StatelessWidget {
  const _PinIndicator({
    // ignore: unused_element_parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _PinNotifier.of(context),
      builder: (context, list, child) => TweenAnimationBuilder<double>(
        tween: Tween(end: _PinNotifier.alphaOf(context)),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutSine,
        builder: (context, value, child) =>
            CircularProgressIndicator(value: value, strokeWidth: 4),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Widget? child;
  final void Function(BuildContext)? onTap;
  final TextStyle? _textStyle;
  const _Button({
    // ignore: unused_element_parameter
    super.key,
    this.child,
    TextStyle? textStyle,
    this.onTap,
  }) : _textStyle = textStyle;

  @override
  Widget build(BuildContext context) {
    if (child == null) return const Placeholder();
    final TextStyle textStyle =
        _textStyle ?? Theme.of(context).extension<AppTextStyles>()!.pinText;

    return Material(
      child: InkWell(
        onTap: () => onTap?.call(context),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: Center(
              child: DefaultTextStyle.merge(
                style: textStyle,
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: textStyle.color,
                    size: textStyle.fontSize,
                  ),
                  child: child!,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
