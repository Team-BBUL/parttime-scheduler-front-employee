import 'package:flutter/material.dart';
import 'package:sidam_employee/view/notify.dart';

class SettingScreen extends StatelessWidget{
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Screen'),

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
                              builder: (context) => const NotifyScreen(),
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
                child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                        child: Text("회원 탈퇴", style: TextStyle(fontSize: 16, color: Colors.red)),
                    ),
                )
            ),
          ]
      )
    );
  }


}