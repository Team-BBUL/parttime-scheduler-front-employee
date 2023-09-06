import 'package:flutter/material.dart';
import 'package:sidam_worker/view/notify.dart';
import 'package:sidam_worker/view/notify_page.dart';

import '../main.dart';
import '../util/sp_helper.dart';
import 'account_withdrawal.dart';
import 'check_login.dart';

class SettingScreen extends StatelessWidget{
  SettingScreen({super.key});
  final SPHelper helper = SPHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotifyPage(),
                            ),
                          );
                        },
                        child: Text("알림 설정", style: TextStyle(fontSize: 16)),
                      )
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("도움말", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("약관 및 정책", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("앱 버전 정보", style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () => _showMyDialog(context),
                          child: Text('로그아웃', style: TextStyle(fontSize: 16, color: Colors.red)),),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => AccountWithdrawalScreen()
                              )),
                          child: Text('회원 탈퇴', style: TextStyle(fontSize: 16, color: Colors.red)),),
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {await helper.init(); helper.clear(); },
                            child: Text('shared_preferences 초기화 버튼(개발용)', style: TextStyle(fontSize: 18, color: Colors.red)),),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ]
      )
    );
  }

  Future<void> _showMyDialog(context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('로그아웃 하시겠습니까?'),
        content: const Text('확인버튼을 누르시면 로그인 페이지로 이동합니다.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              helper.remove('jwt');
              helper.remove('isLoggedIn');
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                      builder: (context) => CheckLoginScreen()
                  ), (route) => false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}