import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../util/app_color.dart';
import '../view_model/local_login_view_model.dart';
import 'account_details.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _designWidth = 411;
  final _designHeight = 683;

  AppColor color = AppColor();

  bool check = true;
  bool idCheck = true;
  bool pwCheck = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _pwController;

  @override
  void initState() {
    super.initState();

    _idController = TextEditingController();
    _pwController = TextEditingController();
  }

  @override
  void dispose() {
    _pwController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double maxWidth = 280 * deviceWidth / _designWidth;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        surfaceTintColor: color.mainColor,
        //title: const Text('로그인'),
      ),
      body: SafeArea(child: Consumer<LocalLoginViewModel>(builder: (context, state, child) {
        if (!state.loading) {
          return SizedBox(
            height: deviceHeight - 50,
            width: deviceWidth,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("\"시담\"에 오신 것을 환영합니다.\n "
                      "\"시담\"은 근무자님의 아르바이트 스케줄\n "
                      "관리를 위한 앱입니다."),
                  const SizedBox(
                    height: 20,
                    width: 2,
                  ),
                  Form(
                      key: formKey,
                      child: Column(children: [
                        SizedBox(
                            width: 300,
                            height: 65,
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: color.mainColor),
                                ),
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                labelText: 'ID',
                                labelStyle:
                                const TextStyle(color: Colors.black26),
                              ),
                              controller: _idController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return 'ID를 입력해주세요!';
                                }
                                if (value!.length > 20) {
                                  return 'ID는 20자를 초과할 수 없습니다!';
                                }
                                if (value.length < 3) {
                                  return 'ID가 너무 짧습니다.';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-z0-9]'),
                                  allow: true,
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 300,
                            height: 65,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: color.mainColor),
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  labelText: '비밀번호',
                                  labelStyle:
                                  const TextStyle(color: Colors.black26)),
                              controller: _pwController,
                              obscureText: true,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return '비밀번호를 입력해주세요!';
                                }
                                if (value!.length > 50) {
                                  return '비밀번호는 50자를 초과할 수 없습니다!';
                                }
                                if (value.length < 8) {
                                  return '비밀번호가 너무 짧습니다.';
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'[a-zA-Z0-9.,!@#$%^&*=+-]'),
                                    allow: true),
                              ],
                            )),
                      ])),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      bool validationResult = true;
                      setState(() {
                        validationResult = formKey.currentState?.validate() ?? false;
                      });

                      if (validationResult) {
                        // 로그인 로직
                        state.fetchLogin(_idController.text, _pwController.text)
                            .then((value) {
                          // 로그인 성공/실패 여부 판별
                          if (state.success) {
                            // 로그인 성공시

                            // 회원 정보 등록 확인 로직 ?
                            if (state.init) { // 회원정보 등록이 되어 있고
                              // 회원 정보 받아서 json 저장 -> _helper에 등록 OK
                              // 등록 매장 정보 받아서 json 저장 -> _helper에 등록
                              state.getStoreData();

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')));

                            } else { // 회원 정보 등록으로 이동
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AccountDetailsScreen()));
                            }

                          } else {
                            // 로그인 실패시
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))
                                ),
                                backgroundColor: Colors.white,
                                content: Text(state.message),
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                    },
                                      child: Text('확인', style: TextStyle(color: color.mainColor),))
                                  ],
                                );
                              });
                            }
                        });

                      } else {
                        log('유효성 검사 실패');
                      }
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(200, 30),
                      backgroundColor: color.mainColor,
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: maxWidth,
                    child: const Text(
                      '위의 "로그인"을 선택하면, '
                          '시담의 이용약관 및 개인정보 보호정책을 읽고 이해했으며, '
                          '그에 동의하는 것으로 간주됩니다.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ]),
          );
        }
        else {
          return Container(width: double.infinity, height: double.infinity,
            color: Colors.white,
            child: Center(child: CircularProgressIndicator(color: color.mainColor,)),
          );
        }
      })
      ),
    );
  }
}