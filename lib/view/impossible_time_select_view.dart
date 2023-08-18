import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImpossibleTime extends StatefulWidget {

  @override
  _ImpossibleTimeState createState() => _ImpossibleTimeState();
}

class _ImpossibleTimeState extends State<ImpossibleTime> {

  // design constant
  final _designWidth = 411;
  final _designHeight = 683;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '근무가 불가능한 시간을 선택해 주세요',
          style: TextStyle(
            fontSize: 18 * deviceWidth / _designWidth
          ),
        ),
      ),
    );
  }
}