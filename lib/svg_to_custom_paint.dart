import 'package:flutter/material.dart';

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
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.1, end: 0.4).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPaint Example'),
      ),
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
  final double pistonPosition;

  PistonPainter(this.pistonPosition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    // Draw the cylinder (covering upper part and half of the rod)
    final cylinderRect = Rect.fromLTWH(size.width * 0.25, size.height * 0.05,
        size.width * 0.5, size.height * 0.55);
    canvas.drawRect(cylinderRect, paint);

    // Draw the piston head
    final pistonHeadRect = Rect.fromLTWH(size.width * 0.3,
        size.height * pistonPosition, size.width * 0.4, size.height * 0.2);
    paint.color = Colors.red;
    canvas.drawRect(pistonHeadRect, paint);

    // Draw the piston rod
    final pistonRodRect = Rect.fromLTWH(
        size.width * 0.45,
        size.height * (pistonPosition + 0.2),
        size.width * 0.1,
        size.height * 0.5);
    paint.color = Colors.blue;
    canvas.drawRect(pistonRodRect, paint);

    // Draw the piston pin
    final pistonPinRect = Rect.fromLTWH(
        size.width * 0.35,
        size.height * (pistonPosition + 0.7),
        size.width * 0.3,
        size.height * 0.05);
    paint.color = Colors.green;
    canvas.drawRect(pistonPinRect, paint);

    // Draw the piston pin hole
    final pistonPinHole =
        Offset(size.width * 0.5, size.height * (pistonPosition + 0.725));
    final pistonPinHoleRadius = size.height * 0.025;
    paint.color = Colors.yellow;
    canvas.drawCircle(pistonPinHole, pistonPinHoleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
