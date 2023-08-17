import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/login_web_view.dart';
import 'package:sidam_employee/view/login_web_view_page.dart';
import 'package:sidam_employee/view_model/login_view_model.dart';

class LoginScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: Text("\"앱이름\"에 오신 것을 환영합니다.\n "
                    "\"앱이름\"은 점주님의 아르바이트 스케줄\n "
                    "관리를 위한 앱입니다.")
            ),
            Flexible(
                child: Column(
                  children: [
                    Flexible(
                        child: ElevatedButton(onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder:
                                  (context) => LoginWebViewPage()
                              ) // (context) => WebViewWidget(controller: _webViewController,))
                          );
                        }, child: Text("카카오 로그인"),)
                    ),
                    Flexible(child: Container()),
                    Flexible(child: Container()),

                  ],
                )
            )
          ],
        ),
      ),
    );
  }

}

