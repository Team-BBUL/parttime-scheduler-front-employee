import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/util/app_color.dart';
import 'package:sidam_employee/view_model/local_login_view_model.dart';

import '../main.dart';

class AccountDetailsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailsState();
}

class _DetailsState extends State<AccountDetailsScreen> {

  AppColor color = AppColor();

  bool check = true;
  bool idCheck = true;
  bool pwCheck = true;

  GlobalKey<FormState> idKey = GlobalKey<FormState>();
  GlobalKey<FormState> pwKey = GlobalKey<FormState>();
  GlobalKey<FormState> pwCheckKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _pwController;
  late TextEditingController _pwChController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _pwController = TextEditingController();
    _pwChController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwChController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: color.mainColor,
        title: const Text(
          '회원 정보 등록',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: Consumer<LocalLoginViewModel>(builder: (context, state, child) {
        if (!state.updateLoading) {
          return SizedBox(
            height: deviceHeight - 50,
            width: deviceWidth,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('ID와 비밀번호를 변경해주세요'),
                  Form(
                      key: idKey,
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
                                labelText: '바꿀 ID',
                                labelStyle:
                                const TextStyle(color: Colors.black26),
                              ),
                              controller: _idController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return 'ID를 입력해주세요';
                                }
                                if (value!.length > 20) {
                                  return 'ID는 20자를 초과할 수 없습니다!';
                                }
                                if (value.length < 3) {
                                  return 'ID가 너무 짧습니다';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9]'),
                                  allow: true,
                                )
                              ],
                            )),
                      ])),

                  Form(
                      key: pwKey,
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
                                labelText: '바꿀 비밀번호',
                                labelStyle:
                                const TextStyle(color: Colors.black26),
                              ),
                              controller: _pwController,
                              obscureText: true,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return '비밀번호를 입력해주세요';
                                }
                                if (value!.length > 30) {
                                  return '비밀번호는 20자를 초과할 수 없습니다!';
                                }
                                if (value.length < 8) {
                                  return '비밀번호가 너무 짧습니다';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9.,!@#$%^&*=+-]'),
                                  allow: true,
                                )
                              ],
                            )),
                      ])),

                  Form(
                      key: pwCheckKey,
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
                                labelText: '비밀번호 확인',
                                labelStyle:
                                const TextStyle(color: Colors.black26),
                              ),
                              controller: _pwChController,
                              obscureText: true,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return '비밀번호를 입력해주세요';
                                }
                                if (value! != _pwController.text) {
                                  return '비밀번호가 같지 않습니다';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp(r'[a-zA-Z0-9.,!@#$%^&*=+-]'),
                                  allow: true,
                                )
                              ],
                            )),
                      ])),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    onPressed: () async {
                      bool idValidationResult = false;
                      bool pwValidationResult = false;
                      bool pwCheckValidationResult = false;

                      setState(() {
                        idValidationResult = idKey.currentState?.validate() ?? false;
                        pwValidationResult = pwKey.currentState?.validate() ?? false;
                        pwCheckValidationResult = pwCheckKey.currentState?.validate() ?? false;
                      });

                      if (idValidationResult && pwValidationResult && pwCheckValidationResult) {
                        log('유효성 검사 통과');

                        state.setAccountData(_idController.text, _pwController.text, _pwChController.text)
                            .then((value) {
                          if (state.message.contains('성공')){
                            state.init = true;
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')));
                          } else {
                            // 등록 실패시
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))
                                ),
                                backgroundColor: Colors.white,
                                content: Text(state.message == '' ? "알 수 없는 오류로 실패했습니다. 잠시 후 다시 시도해주세요." : state.message),
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
                      '저장',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(color: color.mainColor,),
            ),
          );
        }
      })),
    );
  }
}
