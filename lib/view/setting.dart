import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../util/appColor.dart';
import '../util/sp_helper.dart';
import 'notify_page.dart';
import 'account_withdrawal.dart';
import 'check_login.dart';
import 'help.dart';
import 'policy_terms.dart';

class SettingScreen extends StatelessWidget{

  AppColor color = AppColor();

  Future<String> loading() async {
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

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
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.black12)
                    ),
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifyPage(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child:  Text("알림 설정", style: TextStyle(fontSize: 16)
                        ),
                      )
                  )
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.black12)
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpView(),),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("도움말", style: TextStyle(fontSize: 16)),
                    ),
                  )
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.black12)
                    ),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PolicyTermsView())
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("약관 및 정책", style: TextStyle(fontSize: 16)),
                    ),
                  )
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.black12)
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("앱 버전 정보", style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          child: FutureBuilder(
                            future: loading(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(color: color.mainColor,);
                              }
                              else if (snapshot.hasError) {
                                return const Text('버전 정보 불러오기 실패');
                              }
                              else {
                                return Text('v ${snapshot.data.toString()}');
                              }},
                          )
                      ),
                    ],
                  )
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.black12)
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () => _showMyDialog(context),
                          child: const Text('로그아웃', style: TextStyle(fontSize: 16, color: Colors.red)),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => AccountWithdrawalScreen()
                              )),
                          child: const Text('회원 탈퇴', style: TextStyle(fontSize: 16, color: Colors.red)),),
                      ),
                    ],
                  )
              ),
              kDebugMode ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.black12)
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async {await helper.init(); helper.clear(); },
                            child: const Text('shared_preferences 초기화 버튼(개발용)', style: TextStyle(fontSize: 18, color: Colors.red)),),
                        ),
                      ),
                    ],
                  )
              ) : const SizedBox(),
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