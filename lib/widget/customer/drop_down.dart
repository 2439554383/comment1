import 'package:flutter/material.dart';

class ArrowDownPainter extends CustomPainter {
  final Color color;
  final double width;
  final double height;

  ArrowDownPainter({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width / 2, height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowDownPainter oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.color != color;
  }
}
