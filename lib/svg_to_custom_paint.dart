import 'package:flutter/material.dart';
import 'dart:math' as math;

class SvgToCustomPaintExample extends StatefulWidget {
  const SvgToCustomPaintExample({super.key});

  @override
  _SvgToCustomPaintExampleState createState() =>
      _SvgToCustomPaintExampleState();
}

class _SvgToCustomPaintExampleState extends State<SvgToCustomPaintExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(400, 400),
              painter: PistonPainter(_animation.value),
            );
          },
        ),
      ),
    );
  }
}

class PistonPainter extends CustomPainter {
  final double rotation;

  PistonPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    // Draw the cylinder (covering upper part and half of the rod)
    final cylinderHeight = size.height * 0.55;
    final cylinderRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.05,
        size.width * 0.5, cylinderHeight);
    canvas.drawRect(cylinderRect, paint);

    // Calculate the crankshaft journal center and radius
    final crankshaftJournalCenter =
        Offset(size.width * 0.5, size.height * 0.85 + 50);
    final crankshaftJournalRadius = cylinderHeight / 2;

    // Calculate the position of the yellow pin on the edge of the crankshaft journal
    final yellowPinX = crankshaftJournalCenter.dx +
        crankshaftJournalRadius * math.cos(rotation);
    final yellowPinY = crankshaftJournalCenter.dy +
        crankshaftJournalRadius * math.sin(rotation);
    final yellowPinPosition = Offset(yellowPinX, yellowPinY);

    // Calculate the piston position based on the yellow pin's vertical position
    final pistonPosition = (yellowPinY - size.height * 0.2)
        .clamp(size.height * 0.05, size.height * 0.35);

    // Draw the piston head
    final pistonHeadRect = Rect.fromLTWH(
        size.width * 0.3, pistonPosition, size.width * 0.4, size.height * 0.2);
    paint.color = Colors.red;
    canvas.drawRect(pistonHeadRect, paint);

    // Draw the crankshaft journal as a green circle
    paint.color = Colors.green;
    canvas.drawCircle(crankshaftJournalCenter, crankshaftJournalRadius, paint);

    // Draw the crankshaft journal hole
    final crankshaftJournalHoleRadius = size.height * 0.025;
    paint.color = Colors.yellow;
    canvas.drawCircle(yellowPinPosition, crankshaftJournalHoleRadius, paint);

    // Draw the round pin going through the piston and rod
    final pinCenter =
        Offset(size.width * 0.5, pistonPosition + size.height * 0.1);
    final pinRadius = size.width * 0.03;
    paint.color = Colors.black;
    canvas.drawCircle(pinCenter, pinRadius, paint);

    // Draw the piston rod between the yellow pin and the black pin
    final pistonRodPath = Path()
      ..moveTo(size.width * 0.5, pistonPosition + size.height * 0.1)
      ..lineTo(yellowPinX, yellowPinY)
      ..lineTo(yellowPinX + size.width * 0.1, yellowPinY)
      ..lineTo(size.width * 0.5 + size.width * 0.1,
          pistonPosition + size.height * 0.1)
      ..close();
    paint.color = Colors.blue;
    canvas.drawPath(pistonRodPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
