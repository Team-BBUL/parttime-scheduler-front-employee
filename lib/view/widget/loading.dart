import 'package:flutter/material.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      width: deviceWidth,
      height: deviceHeight,
      color: Colors.black26,
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF89B3),
        ),
      ),
    );
  }
}