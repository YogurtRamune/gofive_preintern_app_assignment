import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {

  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Color iconColor;
  final void Function(BuildContext context)? onTap;
  const HelpButton({super.key, this.onTap, required this.color, required this.borderColor, required this.borderWidth, required this.iconColor});

  static const double size = 20;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: BoxBorder.all(
            color: borderColor,
            width: borderWidth
          )
        ),
        child: Icon(
          Icons.question_mark_rounded,
          color: iconColor,
          size: size - 5,
          fontWeight: .w900,
        ),
      ),
    );
  }
}
