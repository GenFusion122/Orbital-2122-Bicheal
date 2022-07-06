import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(
      color: Color(0xFFFFE0B2),
      size: MediaQuery.of(context).size.width * 0.5,
    );
  }
}
