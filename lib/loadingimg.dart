import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loadingimg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
       color: Colors.white,
      child: Center(
        child:SpinKitFadingCircle(
          color: Colors.orange,
          size: 40,
        ) ,
        ),
    );
  }
}