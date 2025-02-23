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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
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

  void _goToTDC() {
    _controller.stop();
    _controller
        .animateTo(
      0.75, // 270 degrees (top position)
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    )
        .then((_) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  void _goToBDC() {
    _controller.stop();
    _controller
        .animateTo(
      0.25, // 90 degrees (bottom position)
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    )
        .then((_) {
      setState(() {
        isPlaying = false;
      });
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _goToTDC,
                  child: const Text('TDC'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _goToBDC,
                  child: const Text('BDC'),
                ),
              ],
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
      ..color = Colors.grey[300]! // Changed from Colors.grey to a lighter shade
      ..style = PaintingStyle.fill;

    // Make cylinder taller
    final cylinderHeight = size.height * 0.65;

    // Create gradient for metallic effect
    final cylinderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.grey[200]!, // Mid-dark grey on edges
          Colors.grey[300]!, // Mid-dark grey on edges
          Colors.grey[400]!, // Mid-dark grey on edges
          Colors.grey[500]!, // Very dark grey in middle
          Colors.grey[400]!, // Mid-dark grey on edges
          Colors.grey[300]!, // Mid-dark grey on edges

          Colors.grey[200]!, // Mid-dark grey on edges
        ],
        stops: const [0.0, 0.1, 0.30, 0.5, 0.70, 0.9, 1.0],
      ).createShader(Rect.fromLTWH(size.width * 0.25, size.height * 0.05,
          size.width * 0.5, cylinderHeight));

    final cylinderRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.05,
        size.width * 0.5, cylinderHeight);
    canvas.drawRect(cylinderRect, cylinderPaint);

    // Draw dark grey border inside cylinder (sides and top only)
    final borderWidth = 20.0; // Increased from 10.0
    final borderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey[900]!, // Very dark grey
          Colors.grey[700]!, // Dark grey
          Colors.grey[500]!, // Medium grey (highlight)
          Colors.grey[700]!, // Dark grey
          Colors.grey[900]!, // Very dark grey
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(size.width * 0.25, size.height * 0.05,
          size.width * 0.5, cylinderHeight));

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = borderWidth;

    // Left side
    canvas.drawLine(
        Offset(size.width * 0.25, size.height * 0.05),
        Offset(size.width * 0.25, size.height * 0.05 + cylinderHeight),
        borderPaint);

    // Right side
    canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.05),
        Offset(size.width * 0.75, size.height * 0.05 + cylinderHeight),
        borderPaint);

    // Top
    canvas.drawLine(Offset(size.width * 0.22475, size.height * 0.05),
        Offset(size.width * 0.77525, size.height * 0.05), borderPaint);

    // Reset paint for next drawing
    paint.style = PaintingStyle.fill;

    // Calculate the crankshaft journal center and radius
    final crankshaftJournalCenter =
        Offset(size.width * 0.5, size.height * 0.85 + 60);
    final crankshaftJournalRadius =
        cylinderHeight / 3; // Adjusted for taller cylinder
    final crankshaftJournalHoleRadius =
        size.height * 0.025; // Added definition for pin radius
    final blackPinRadius =
        size.height * 0.025; // Added definition for black piston pin radius

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

    // Define pinCenter before using it in the piston rod path
    final pinCenter = Offset(size.width * 0.5,
        pistonPosition + size.height * 0.1 + 20); // Moved down by 30

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

    // Create gradient for rod's metallic effect
    final rodPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, // Changed from centerLeft
        end: Alignment.bottomCenter, // Changed from centerRight
        colors: [
          Colors.red[900]!, // Darkest blue at top
          Colors.red[700]!,
          Colors.red[500]!, // Lighter blue in middle
          Colors.red[700]!,
          Colors.red[900]!, // Darkest blue at bottom
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(
          yellowPinPosition.dx - size.width * 0.05, // Left edge of rod
          yellowPinPosition.dy, // Top of rod
          size.width * 0.1, // Width of rod
          pinCenter.dy - yellowPinPosition.dy)); // Height of rod

    // Draw the piston rod with gradient
    canvas.drawPath(pistonRodPath, rodPaint);

    // Draw the crankshaft journal with gradient
    final crankshaftPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 120 * math.pi / 180,
        endAngle: 2 * math.pi,
        transform: GradientRotation(rotation),
        colors: [
          Colors.grey[900]!, // Very dark grey
          Colors.grey[700]!, // Dark grey
          Colors.grey[500]!, // Medium grey (highlight)
          Colors.grey[700]!, // Dark grey
          Colors.grey[900]!, // Very dark grey
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(
        center: crankshaftJournalCenter,
        radius: crankshaftJournalRadius,
      ));

    canvas.drawCircle(
        crankshaftJournalCenter, crankshaftJournalRadius, crankshaftPaint);

    // Draw a larger bolt in the middle of the crankshaft journal with metallic gradient
    final boltRadius = size.width * 0.04; // Increased from 0.02 to 0.04
    final boltPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.7,
        colors: [
          Colors.grey[900]!, // Darkest grey in center
          Colors.grey[700]!,
          Colors.grey[500]!, // Lighter towards edge
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(
        center: crankshaftJournalCenter,
        radius: boltRadius,
      ));

    // Draw the main bolt body
    canvas.drawCircle(crankshaftJournalCenter, boltRadius, boltPaint);

    // Add a thin border around the bolt
    final boltBorderPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.003;

    canvas.drawCircle(crankshaftJournalCenter, boltRadius, boltBorderPaint);

    // Draw the piston head on top of the rod
    final pistonHeadPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.red[900]!,

          Colors.red[700]!, // Lighter red on edges
          Colors.red[400]!, // Mid red
          Colors.red[200]!, // Dark red in middle
          Colors.red[400]!, // Mid red
          Colors.red[700]!, // Lighter red on edges
          Colors.red[900]!,
        ],
        stops: const [0.0, 0.1, 0.30, 0.5, 0.70, 0.9, 1.0],
      ).createShader(Rect.fromLTWH(size.width * 0.28, pistonPosition,
          size.width * 0.44, size.height * 0.25));

    final pistonHeadRect = Rect.fromLTWH(size.width * 0.28, pistonPosition,
        size.width * 0.44, size.height * 0.25);
    canvas.drawRect(pistonHeadRect, pistonHeadPaint);

    // Draw two gradient lines near top of piston
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black, // Dark on edges
          Colors.grey[600]!, // Lighter in middle
          Colors.black, // Dark on edges
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(
          size.width * 0.273,
          pistonPosition,
          size.width * 0.454, // Width of lines (0.727 - 0.273)
          25)) // Height enough to cover both lines
      ..strokeWidth = size.width * 0.008 // Changed from 0.015 to 0.008
      ..style = PaintingStyle.stroke;

    // First line with gradient
    canvas.drawLine(Offset(size.width * 0.273, pistonPosition + 10),
        Offset(size.width * 0.727, pistonPosition + 10), linePaint);

    // Second line with same gradient
    canvas.drawLine(Offset(size.width * 0.273, pistonPosition + 20),
        Offset(size.width * 0.727, pistonPosition + 20), linePaint);

    // Reset paint style for next drawings
    paint.style = PaintingStyle.fill;

    // Draw the black pin on top of everything with metallic gradient
    final blackPinPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.7,
        colors: [
          Colors.grey[900]!, // Darkest grey in center
          Colors.grey[700]!,
          Colors.grey[600]!, // Lighter towards edge
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(
        center: pinCenter,
        radius: blackPinRadius,
      ));

    // Draw the main pin body
    canvas.drawCircle(pinCenter, blackPinRadius, blackPinPaint);

    // Add a thin border around the pin
    final blackPinBorderPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.003;

    canvas.drawCircle(pinCenter, blackPinRadius, blackPinBorderPaint);

    // Draw the pin with metallic gradient instead of solid yellow
    final pinPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center, // Changed to match black pin
        radius: 0.7, // Changed to match black pin
        colors: [
          Colors.grey[900]!, // Darkest grey in center
          Colors.grey[700]!,
          Colors.grey[600]!, // Lighter towards edge
        ],
        stops: const [0.0, 0.6, 1.0], // Changed to match black pin
      ).createShader(Rect.fromCircle(
        center: yellowPinPosition,
        radius: crankshaftJournalHoleRadius,
      ));

    // Draw the main pin body
    canvas.drawCircle(yellowPinPosition, crankshaftJournalHoleRadius, pinPaint);

    // Add a thin border around the pin
    final connectingPinBorderPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.003; // Changed to match black pin border

    canvas.drawCircle(yellowPinPosition, crankshaftJournalHoleRadius,
        connectingPinBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
