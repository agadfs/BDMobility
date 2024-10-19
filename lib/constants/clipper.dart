import 'package:flutter/material.dart';

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);

    path.arcToPoint(
      Offset(0, size.height),
      radius: Radius.circular(size.width * 1.5), // Adjust the circular radius as needed
      clockwise: false,
    );

    // Close the path
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}