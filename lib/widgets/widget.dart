import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFF0000) // Màu đường viền
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // Độ dày của đường viền

    const double dashWidth = 5; // Độ dài của mỗi đoạn nét đứt
    const double dashSpace = 5; // Khoảng cách giữa các đoạn nét đứt

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
