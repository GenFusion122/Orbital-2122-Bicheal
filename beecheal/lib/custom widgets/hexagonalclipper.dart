import 'package:flutter/cupertino.dart';

class HexagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path
      ..moveTo(0, size.width * 0.433 + ((size.height - size.width) / 2))
      ..lineTo(size.width * 0.25, (size.height - size.width) / 2)
      ..lineTo(size.width * 0.75, (size.height - size.width) / 2)
      ..lineTo(size.width, size.width * 0.433 + (size.height - size.width) / 2)
      ..lineTo(size.width * 0.75,
          size.width * 0.866 + (size.height - size.width) / 2)
      ..lineTo(size.width * 0.25,
          size.width * 0.866 + (size.height - size.width) / 2)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
