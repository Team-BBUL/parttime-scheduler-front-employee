import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:sidam_worker/model/userModel.dart';

class Session {

  Session() {
    _accountRoleId = '7';//User.account.id.toString();
  }

  var logger = Logger();

  final String _server = "http://192.168.219.104:8088"; // 서버의 주소
  late String _accountRoleId; // 현재 클라이언트의 사용자 ID

  set setRoleId(String id) { _accountRoleId = id; }
  get roleId { return _accountRoleId; }
  get server { return _server; }

  Map<String, String> headers = {
    'Content_type': 'application/json',
    'Accept': 'application/json'
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