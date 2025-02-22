import 'package:flutter/material.dart';
import 'package:svg_to_custom_paint_test/svg_to_custom_paint.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SVG to CustomPaint Example'),
        ),
        body: Center(
          child: SvgToCustomPaintExample(),
        ),
      ),
    );
  }
}
