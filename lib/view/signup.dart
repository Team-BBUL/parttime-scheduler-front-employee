import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidam_employee/view/store_list_page.dart';

import '../data/repository/user_repository.dart';
import '../main.dart';
import '../model/account.dart';
import '../util/appColor.dart';

class SignupScreen extends StatefulWidget{

  @override
  _SignupState createState() => _SignupState();

}

class _SignupState extends State<SignupScreen>{
  final UserRepository _userRepository = UserRepositoryImpl();

  Future<Account>? _accountFuture;
  Account? _account;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextField'),
      ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: const Text('확인되는 회원이 없습니다. 가입하시겠어요?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '별명을 입력해주세요',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                          BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                    child: FilledButton(onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder:
                              (context) => StoreListPage()
                          ),
                          (route) => false
                      );
                    },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColor().mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text("다음",
                        style: TextStyle(fontSize: 17,color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}