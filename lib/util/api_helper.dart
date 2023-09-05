import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sidam_employee/util/sp_helper.dart';

class APiHelper{
  static String baseUrl = 'https://10.0.2.2:8088/';
  static SPHelper helper = SPHelper();
  final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
    'Content-Type': 'application/json'};

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse(baseUrl + endpoint));

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return jsonDecode(response.body);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return jsonDecode(response.body);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return jsonDecode(response.body);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }

  static Future<dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return jsonDecode(response.body);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized');
    } else if (statusCode == 403) {
      throw Exception('Forbidden');
    } else {
      throw Exception('Unexpected error occurred');
    }
  }
}