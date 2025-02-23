import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:svg_to_custom_paint_test/svg_to_custom_paint.dart';

class SvgToCustomPaintExampleCopy extends StatefulWidget {
  const SvgToCustomPaintExampleCopy({super.key});

  @override
  _SvgToCustomPaintExampleCopyState createState() =>
      _SvgToCustomPaintExampleCopyState();
}

class _SvgToCustomPaintExampleCopyState
    extends State<SvgToCustomPaintExampleCopy>
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
