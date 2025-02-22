import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class SvgToCustomPaintExample extends StatefulWidget {
  const SvgToCustomPaintExample({super.key});

  @override
  State<SvgToCustomPaintExample> createState() =>
      _SvgToCustomPaintExampleState();
}

class _SvgToCustomPaintExampleState extends State<SvgToCustomPaintExample> {
  late Future<PictureInfo> svgPicture;

  @override
  void initState() {
    super.initState();
    svgPicture = _loadSVG();
  }

  Future<PictureInfo> _loadSVG() async {
    final String svgString =
        await rootBundle.loadString('lib/assets/images/piston.svg');
    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(svgString), null);
    return pictureInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG to CustomPaint'),
      ),
      body: Center(
        child: FutureBuilder<PictureInfo>(
          future: svgPicture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomPaint(
                size: const Size(400, 400),
                painter: SVGPainter(snapshot.data!),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class SVGPainter extends CustomPainter {
  final PictureInfo pictureInfo;

  SVGPainter(this.pictureInfo);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final ratio = size.width / pictureInfo.size.width;
    canvas.scale(ratio);
    canvas.drawPicture(pictureInfo.picture);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
