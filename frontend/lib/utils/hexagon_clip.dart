import 'package:flutter/material.dart';
import 'dart:math' as math;

class RoundedHexagonClipper extends CustomClipper<Path> {
  final double cornerRadius;

  RoundedHexagonClipper({this.cornerRadius = 10});

  @override
  Path getClip(Size size) {
    Path path = Path();

    // Calculate the coordinates of the hexagon vertices
    double w = size.width;
    double h = size.height;
    double r = math.min(w, h) / 2;
    double a = r * math.sqrt(3);
    double cx = w / 2;
    double cy = h / 2;
    double x = cx - r;
    double y = cy - a / 2;

    // Define the hexagon path with rounded corners
    path.moveTo(x + cornerRadius, y);
    path.lineTo(x + r * 2 - cornerRadius, y);
    path.arcToPoint(
      Offset(x + r * 2, y + cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(x + r * 3 - cornerRadius, y + a);
    path.arcToPoint(
      Offset(x + r * 2, y + a * 2 - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(x + cornerRadius, y + a * 2);
    path.arcToPoint(
      Offset(x, y + a - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(x + cornerRadius, y + cornerRadius * 2);
    path.arcToPoint(
      Offset(x, y + a / 2 + cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(x + cornerRadius, y + a / 2 - cornerRadius);
    path.arcToPoint(
      Offset(x, y + a / 2 - cornerRadius * 2),
      radius: Radius.circular(cornerRadius),
      clockwise: false,
    );
    path.lineTo(x + cornerRadius, y);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}