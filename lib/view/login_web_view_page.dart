import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/login_web_view.dart';
import 'package:sidam_employee/view_model/login_view_model.dart';


class LoginWebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: LoginWebView(),
    );
  }
}