import 'dart:math';

import 'package:flutter/material.dart';

class HexagonProfileImage extends StatelessWidget {
  const HexagonProfileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: HexagonShape(),
          ),
          child: Image.asset(
            'assets/ape.jpg', // Replace this with your own image asset
          ),
        ),
      ),
    );
  }
}

class HexagonShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0.0);

  @override
  ShapeBorder scale(double t) {
    return HexagonShape();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    final width = rect.width;
    final height = rect.height;
    final centerX = rect.center.dx;
    final centerY = rect.center.dy;

    final radius = width / 2.0;
    final apothem = radius * (sqrt(3) / 2.0);
    final side = 2 * radius * (sqrt(3) / 2.0);

    path.moveTo(centerX, centerY - radius);
    path.lineTo(centerX + apothem, centerY - radius / 2);
    path.lineTo(centerX + apothem, centerY + radius / 2);
    path.lineTo(centerX, centerY + radius);
    path.lineTo(centerX - apothem, centerY + radius / 2);
    path.lineTo(centerX - apothem, centerY - radius / 2);
    path.close();

    final clipPath = Path.combine(
      PathOperation.intersect,
      path,
      Path()..addRect(rect),
    );

    return clipPath;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No implementation needed
  }
}

