import 'package:flutter/material.dart';
import 'package:svg_to_custom_paint_test/svg_to_custom_paint_copy.dart';
import 'svg_to_custom_paint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PageViewExample(),
    );
  }
}

class PageViewExample extends StatelessWidget {
  const PageViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          SvgToCustomPaintExample(),
          SvgToCustomPaintExampleCopy(),
        ],
      ),
    );
  }
}
