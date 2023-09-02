import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidam_worker/util/app_future_builder.dart';
import 'package:sidam_worker/util/sp_helper.dart';
import 'package:sidam_worker/view/login.dart';
import 'package:sidam_worker/view/signup.dart';
import 'package:sidam_worker/view/store_list_page.dart';

import 'home.dart';
class CheckLoginScreen extends StatefulWidget{

  @override
  _CheckLoginScreenState createState() => _CheckLoginScreenState();
}

class _CheckLoginScreenState extends State<CheckLoginScreen> {
  SPHelper helper = SPHelper();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppFutureBuilder<void>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          return Container();
        },
      ),
    );
  }

  _checkLoginStatus() async {
    await helper.init();
    await Future.delayed(Duration(seconds: 1));
    bool isLoggedIn = helper.getIsLoggedIn();
    int? currentStoreId = helper.getStoreId();
    bool isRegistered = helper.getIsRegistered();
    String jwt = helper.getJWT();
    if(jwt.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
    log(isLoggedIn ? '로그인됨' : '로그인안됨');
    log(isRegistered ? '등록됨' : '등록안됨');
    log(currentStoreId != null ? '$currentStoreId' : '가게선택안됨');
    if(isLoggedIn && isRegistered && currentStoreId != null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }else if (isLoggedIn && isRegistered) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoreListPage(),
        ),
      );
    }else if(isLoggedIn){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignupScreen(),
        ),
      );
    }else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }
}