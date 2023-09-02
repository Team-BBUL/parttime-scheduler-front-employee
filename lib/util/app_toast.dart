import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast{
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      fontSize: 18,
      textColor: Colors.white,
    );
  }
}