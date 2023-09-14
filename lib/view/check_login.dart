import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sidam_employee/util/app_future_builder.dart';
import 'package:sidam_employee/util/sp_helper.dart';
import 'package:sidam_employee/view/login.dart';

import '../main.dart';
import 'account_details.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    bool isLoggedIn = helper.getIsLoggedIn();
    int? currentStoreId = helper.getStoreId();
    bool isRegistered = helper.getIsRegistered();
    String jwt = helper.getJWT();
    if(jwt.isEmpty) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    log('jwt: $jwt');
    log(isLoggedIn ? '로그인됨' : '로그인안됨');
    log(isRegistered ? '등록됨' : '등록안됨');
    log(currentStoreId != null ? '가게 id = $currentStoreId' : '가게선택안됨');

    if(isLoggedIn && isRegistered && currentStoreId != null){
      log('홈으로 이동');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)));

    } else if(isLoggedIn) {
      log('회원 정보 등록으로 이동');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AccountDetailsScreen()));

    } else {
      log('로그인으로 이동');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}