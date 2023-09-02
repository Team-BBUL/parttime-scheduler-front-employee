import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../util/app_toast.dart';
import '../view_model/login_view_model.dart';
import 'signup.dart';

class LoginWebView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
        builder:(context, viewModel,child) {
          return Scaffold(
              body: SafeArea(
                child: Column(children: [
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Center(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(Icons.close),
                              )
                          )
                      ),
                      Flexible(
                          flex: 6,
                          child: Center(
                            child:TextField(
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                // prefixIcon: Icon(Icons.lock, color: Colors.lightGreen),
                                hintText: viewModel.url,
                              ),
                              enabled: false,
                              controller: viewModel.urlController,
                              keyboardType: TextInputType.url,
                              onSubmitted: (value) {
                                var url = Uri.parse(value);
                                if (url.scheme.isEmpty) {
                                  url = Uri.parse("");
                                }
                                viewModel.webViewController?.loadUrl(
                                    urlRequest: URLRequest(url: url));
                              },
                            ),
                          )
                      ),
                      Flexible(
                          flex: 1,
                          child: Container()
                      )
                    ],
                  ),
                  Expanded(
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(
                            url: Uri.parse("http://10.0.2.2:8088/auth/authorize/kakao")
                        ),
                        pullToRefreshController: viewModel.pullToRefreshController,
                        onWebViewCreated: (controller) {
                          viewModel.webViewController = controller;
                        },
                        onUpdateVisitedHistory: (controller, url, androidIsReload) {

                          viewModel.url = url.toString();
                          viewModel.urlController.text = viewModel.url;
                        },
                        onProgressChanged: (controller, progress) {
                          if (viewModel.progress == 100) {
                            viewModel.pullToRefreshController.endRefreshing();
                          }
                          viewModel.urlController.text = viewModel.url;
                        },
                        onLoadStop: (controller, url) async {
                          var html = await controller.evaluateJavascript(
                              source: """
                              new XMLSerializer().serializeToString(document.body);
                                        """
                          );
                          viewModel.urlController.text = viewModel.url;
                          var isSuccess = await viewModel.saveToken(viewModel.url);
                          if(isSuccess){
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()
                                ),(route) => false
                            );
                            AppToast.showToast('로그인 성공');
                          }else{
                            AppToast.showToast('로그인 실패');
                          }


                          // var result = parse(html);
                          // print(result.runtimeType);
                          // print(result.querySelector('pre')!.innerHtml);
                          // var json = result.querySelector('pre')!.innerHtml;
                          // viewModel.saveTokenAsBody(json);
                          // if(viewModel.webViewToken.status == 200){
                          //   Navigator.pop(context);
                          //   Navigator.push(context,
                          //       MaterialPageRoute(
                          //       builder: (context) => UnderConstruction()
                          //       )
                          //   );
                          // }
                        },
                      )),
                  viewModel.progress < 1.0
                      ? CircularProgressIndicator(value: viewModel.progress)
                      : Container(),
                ]),
              )
          );
        }
    );
  }

}