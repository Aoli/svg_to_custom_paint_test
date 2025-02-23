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
  bool isPlaying = true;

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

  void _toggleAnimation() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
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
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _toggleAnimation,
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30,
              ),
            ),
          ),
        ],
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

    // Make cylinder taller
    final cylinderHeight = size.height * 0.65; // Increased from 0.55
    final cylinderRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.05,
        size.width * 0.5, cylinderHeight);
    canvas.drawRect(cylinderRect, paint);

    // Calculate the crankshaft journal center and radius
    final crankshaftJournalCenter =
        Offset(size.width * 0.5, size.height * 0.85 + 60);
    final crankshaftJournalRadius =
        cylinderHeight / 3; // Adjusted for taller cylinder

    // Calculate the position of the yellow pin slightly inside the edge of the crankshaft journal
    final yellowPinX = crankshaftJournalCenter.dx +
        (crankshaftJournalRadius - 25) * math.cos(rotation);
    final yellowPinY = crankshaftJournalCenter.dy +
        (crankshaftJournalRadius - 25) * math.sin(rotation);
    final yellowPinPosition = Offset(yellowPinX, yellowPinY);

    // Fixed rod length - make it longer than the stroke
    final rodLength = size.height * 0.75; // Increased from 0.55

    // Calculate the actual piston position using proper geometric constraints
    final dx = yellowPinX - crankshaftJournalCenter.dx;
    final dy = yellowPinY - crankshaftJournalCenter.dy;

    // Calculate piston Y position maintaining fixed rod length
    final pistonX = size.width * 0.5; // Fixed X position
    final dxFromPin = yellowPinX - pistonX;
    final pistonY = yellowPinY -
        math.sqrt((rodLength * rodLength) - (dxFromPin * dxFromPin));

    final pistonPosition = pistonY.clamp(size.height * 0.05,
        size.height * 0.55 // Increased from 0.45 to match taller cylinder
        );

    // Draw the crankshaft journal as a green circle
    paint.color = Colors.green;
    canvas.drawCircle(crankshaftJournalCenter, crankshaftJournalRadius, paint);

    // Draw a bolt in the middle of the crankshaft journal
    paint.color = Colors.black;
    canvas.drawCircle(crankshaftJournalCenter, size.width * 0.02, paint);

    // Draw rotating cross in the bolt
    paint.color = Colors.white;
    paint.strokeWidth = size.width * 0.005;
    paint.style = PaintingStyle.stroke;

    canvas.save();
    canvas.translate(crankshaftJournalCenter.dx, crankshaftJournalCenter.dy);
    canvas.rotate(rotation);

    // Draw horizontal line of the cross
    canvas.drawLine(
        Offset(-size.width * 0.015, 0), Offset(size.width * 0.015, 0), paint);
    // Draw vertical line of the cross
    canvas.drawLine(
        Offset(0, -size.width * 0.015), Offset(0, size.width * 0.015), paint);

    canvas.restore();

    // Draw the round pin going through the piston
    final pinCenter =
        Offset(size.width * 0.5, pistonPosition + size.height * 0.1 + 30); // Moved down by 30

    // Draw the piston rod first (so it appears behind everything)
    final pistonRodPath = Path()
      ..moveTo(
          pinCenter.dx - size.width * 0.05, pinCenter.dy - size.height * 0.04)
      ..lineTo(yellowPinPosition.dx - size.width * 0.05, yellowPinPosition.dy)
      ..lineTo(yellowPinPosition.dx - size.width * 0.05,
          yellowPinPosition.dy + size.height * 0.04)
      ..lineTo(yellowPinPosition.dx + size.width * 0.05,
          yellowPinPosition.dy + size.height * 0.04)
      ..lineTo(yellowPinPosition.dx + size.width * 0.05, yellowPinPosition.dy)
      ..lineTo(
          pinCenter.dx + size.width * 0.05, pinCenter.dy - size.height * 0.04)
      ..close();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;
    canvas.drawPath(pistonRodPath, paint);

    // Draw the piston head on top of the rod
    final pistonHeadRect = Rect.fromLTWH(
        size.width * 0.3, pistonPosition, size.width * 0.4, size.height * 0.25);
    paint.color = Colors.red;
    canvas.drawRect(pistonHeadRect, paint);

    // Draw the black pin on top of everything
    final blackPinRadius = size.height * 0.025;
    paint.color = Colors.black;
    canvas.drawCircle(pinCenter, blackPinRadius, paint);

    // Draw the yellow pin last
    final crankshaftJournalHoleRadius = size.height * 0.025;
    paint.color = Colors.yellow;
    canvas.drawCircle(yellowPinPosition, crankshaftJournalHoleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
