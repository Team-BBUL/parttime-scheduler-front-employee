import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../model/web_view_token.dart';
import '../util/sp_helper.dart';

class LoginViewModel extends ChangeNotifier{
  InAppWebViewController? webViewController;
  late WebViewToken webViewToken;
  ValueNotifier<String> newUrl = ValueNotifier<String>("");
  SPHelper helper = SPHelper();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  // TODO: 실제 서버 주소로 바꾸기
  late PullToRefreshController pullToRefreshController;
  String url = "http://192.168.219.105:8088/auth/authorize/kakao";
  double progress = 0;
  final urlController = TextEditingController();

  LoginViewModel() {
    helper.init();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    notifyListeners();
  }

  Future<bool> saveToken(String url) async{
    final Uri parsedUri= Uri.parse(url);
    final Map<String, String> queryParams = parsedUri.queryParameters;
    if (queryParams.isNotEmpty) {
      if(queryParams['token']!.isNotEmpty){
        String? jwt = queryParams['token'];
        helper.writeIsLoggedIn(true);
        helper.writeJWT(jwt!);
        print(helper.getJWT());
        print("token: ${jwt}");
        return true;
      }
    }
    return false;
  }

}
