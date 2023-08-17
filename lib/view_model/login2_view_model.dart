import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier{

  bool isLoggedIn = false;

  LoginViewModel(){
    _checkLoginStatus();

  }
  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }
}