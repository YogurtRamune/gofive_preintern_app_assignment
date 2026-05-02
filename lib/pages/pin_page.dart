import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preintern_app/bloc/pin_bloc.dart';
import 'package:flutter_preintern_app/core/app_theme.dart';

class PinPage extends StatelessWidget {
  const PinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PinBloc(),
      child: Scaffold(
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
                                style: Theme.of(
                                  context,
                                ).extension<AppTextStyles>()!.pinHeader,
                              ),
                              Text(
                                "To allow secure access to app and payslip information",
                                style: Theme.of(
                                  context,
                                ).extension<AppTextStyles>()!.pinBody,
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
                                            color: AppTheme.surface,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'asset/img/icon/lock.png',
                                              fit: .contain,
                                              isAntiAlias: true,
                                              filterQuality: .high,
                                              width: 35,
                                              height: 35,
                                            ),
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
                                style: Theme.of(
                                  context,
                                ).extension<AppTextStyles>()!.pinBody,
                              ),
                              SizedBox(height: 7),
                              SizedBox(
                                height: 25,
                                child: FractionallySizedBox(
                                  widthFactor: 0.27,
                                  child: Expanded(child: _PinCircles()),
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
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(1),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('4'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(4),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('7'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(7),
                                    ),
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
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(2),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('5'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(5),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('8'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(8),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('0'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(0),
                                    ),
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
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(3),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('6'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(6),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Text('9'),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitAdded(9),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 10,
                                  child: _Button(
                                    child: Icon(Icons.backspace_outlined),
                                    onTap: (ctx) => ctx.read<PinBloc>().add(
                                      PinDigitDeleted(),
                                    ),
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
  const _PinCircles();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PinBloc>().state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...List.generate(
          state.filledCount,
          (index) => const _PinCircle(filled: true),
        ),
        ...List.generate(
          state.emptyCount,
          (index) => const _PinCircle(filled: false),
        ),
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
    return BlocBuilder<PinBloc, PinState>(
      builder: (context, state) => TweenAnimationBuilder<double>(
        tween: Tween(end: state.alpha),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutSine,
        builder: (context, value, child) =>
            CircularProgressIndicator(value: value),
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
        _textStyle ?? Theme.of(context).extension<AppTextStyles>()!.pinNumber;

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
