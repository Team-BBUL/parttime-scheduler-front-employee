import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:sidam_worker/utility/sp_helper.dart';

class Session {

  Session() {
    init();
  }

  void init() async {
    await helper.init();

    int? role = helper.getRoleId();
    _accountRoleId = role ?? 0;
    headers['token'] = helper.getJWT();
  }

  var logger = Logger();
  SPHelper helper = SPHelper();

  final String _server = "http://192.168.219.104:8088"; // 서버의 주소
  int _accountRoleId = 0; // 현재 클라이언트의 사용자 ID

  set setRoleId(int id) { _accountRoleId = id; }
  get roleId { return _accountRoleId; }
  get server { return _server; }

  Map<String, String> headers = {
    'Content_type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> cookies = {};

  Future<http.Response> get(String url) async {
    logger.i("get - $url");
    http.Response response =
        await http.get(Uri.parse('$server$url'), headers: headers);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      logger.w('get warning\n${response.body}');
    }
    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    logger.i("post - $url, ${data.toString()}");
    http.Response response =
        await http.post(Uri.parse('$server/$url'),
            body: jsonEncode(data), headers: headers);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      logger.w('post warning\n${response.body}');
    }

    return response;
  }

  Future<http.Response> delete(String url) async {
    logger.i("delete - $url");
    http.Response response =
    await http.delete(Uri.parse('$server/$url'));

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 400) {
      logger.w('delete warning\n${response.body}');
    }

    return response;
  }
}