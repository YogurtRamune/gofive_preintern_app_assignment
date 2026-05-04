import 'package:flutter/material.dart';

class _CellBlockedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    debugPrint(size.toString());
    double s = size.height > size.width ? size.height : size.width;
    final paint = Paint()
      ..color = Colors.red.withAlpha(127)
      ..style = .stroke
      ..strokeWidth = s * 0.1;

    void offset(double offset) {
      canvas.drawLine(
        Offset(0, s + (s * offset)),
        Offset(s + (s * offset), 0),
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

class TestPainter extends StatelessWidget {
  const TestPainter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 20,
              child: CustomPaint(
                painter: _CellBlockedPainter(),
                child: SizedBox.expand(
                  child: Container(color: Colors.black.withAlpha(100)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
