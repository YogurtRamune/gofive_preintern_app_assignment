import 'package:flutter/material.dart';
import 'package:flutter_preintern_app/shared/data/app_theme.dart';

class PinPage extends StatelessWidget {
  const PinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 254, 255),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constrain) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('asset/img/deco/pin_bg.png'),
                SizedBox(
                  height: constrain.maxHeight / 3,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: Column(
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(child: _Button(child: Text('1'),)),
                              Flexible(child: _Button(child: Text('2'),)),
                              Flexible(child: _Button(child: Text('3'))),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(child: _Button(child: Text('4'))),
                              Flexible(child: _Button(child: Text('5'))),
                              Flexible(child: _Button(child: Text('6'))),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(child: _Button(child: Text('7'))),
                              Flexible(child: _Button(child: Text('8'))),
                              Flexible(child: _Button(child: Text('9'))),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(child: _Button(child: SizedBox.shrink(),)),
                              Flexible(child: _Button(child: Text('0'))),
                              Flexible(child: _Button(child: Icon(Icons.backspace_outlined))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;
  final TextStyle? _textStyle;
  const _Button({super.key, this.child, TextStyle? textStyle, this.onTap}): _textStyle = textStyle;

  @override
  Widget build(BuildContext context) {

    if (child == null) return const Placeholder();
    final TextStyle textStyle = _textStyle ?? Theme.of(context).extension<AppTextStyles>()!.sectionHeader;

    return InkWell(
      onTap: onTap,
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
    );
  }
}
