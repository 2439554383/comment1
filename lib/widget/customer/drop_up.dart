import 'package:flutter/material.dart';

class ArrowUpPainter extends CustomPainter {
  final Color color;
  final double width;
  final double height;

  ArrowUpPainter({
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
      ..lineTo(width / 2, -height)
      ..lineTo(width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowUpPainter oldDelegate) {
    return oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.color != color;
  }
}
