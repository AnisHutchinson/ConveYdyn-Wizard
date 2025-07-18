import 'package:flutter/material.dart';

class RectangularSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(12.0, 24.0); // Taille du pouce rectangulaire
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) async {
    final Canvas canvas = context.canvas;
    final Paint paint =
        Paint()
          ..color = sliderTheme.thumbColor!
          ..style = PaintingStyle.fill;
    final Rect rect = Rect.fromCenter(
      center: center,
      width: 12.0,
      height: 24.0,
    );
    canvas.drawRect(rect, paint);
  }
}

class CustomTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint paint =
        Paint()
          ..color = sliderTheme.activeTrackColor!
          ..style = PaintingStyle.fill;

    context.canvas.drawRect(trackRect, paint);
  }
}

class ArrowDownTriangle extends StatelessWidget {
  final Color color;

  const ArrowDownTriangle({super.key, this.color = const Color(0xFF142559)});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DownTriangleClipper(),
      child: Container(width: 20, height: 10, color: color),
    );
  }
}

class DownTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0); // coin haut gauche
    path.lineTo(size.width, 0); // coin haut droit
    path.lineTo(size.width / 2, size.height); // pointe en bas
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ArrowUpTriangle extends StatelessWidget {
  final Color color;

  const ArrowUpTriangle({super.key, this.color = const Color(0xFF142559)});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: UpTriangleClipper(),
      child: Container(width: 20, height: 10, color: color),
    );
  }
}

class UpTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);             // pointe en haut
    path.lineTo(size.width, size.height);       // coin bas droit
    path.lineTo(0, size.height);                // coin bas gauche
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
