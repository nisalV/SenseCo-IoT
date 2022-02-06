import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFAC7C6),
      child: Center(
        child: SpinKitPulse(
          color: Colors.redAccent,
          size: 50.0,
        ),
      )
    );
  }
}
