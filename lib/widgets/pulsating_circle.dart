import 'package:flutter/material.dart';

class PulsatingCircle extends StatelessWidget {
  final Animation<double> animation;

  const PulsatingCircle({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: CirclePainter(animation.value),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final double scale;

  CirclePainter(this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * scale;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
