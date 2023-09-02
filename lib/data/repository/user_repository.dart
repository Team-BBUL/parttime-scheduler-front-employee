import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/account.dart';
import '../../util/sp_helper.dart';


abstract class UserRepository{
  Future<List<dynamic>> getUsers();
  Future<Account> getUser();
  Future<dynamic> createUser(String name);
  Future<dynamic> updateUser(Map<String, dynamic> user);
  Future<dynamic> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  SPHelper helper = SPHelper();

  @override
  Future<void> createUser(String name) async{
    print(helper.getJWT());
    const String apiUrl = 'http://10.0.2.2:8088/member/regist';
    final headers = {'Authorization': 'Bearer '+helper.getJWT(),
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(<String, Object>{
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        helper.writeIsRegistered(true);
        print('User created successfully.');
      } else {
        throw Exception('Failed to create user.');
      }
    } catch (e) {
      throw Exception('Failed to create user. Error: $e');
    }
  }

  @override
  Future deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Account> getUser() async {
    const String apiUrl = 'http://10.0.2.2:8088/member';
    final headers = {'Authorization': 'Bearer '+helper.getJWT(),
      'Content-Type': 'application/json; charset=utf-8'};
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        log("response = ${response.body}");
        Map<String, dynamic> decodedData = json.decode(response.body);
        print('User got successfully.');
        return Account.fromJson(decodedData['data']);
      } else {
        log("response = ${response.body}");
        if(response.body == "UNAUTHORIZED"){
          log("UNAUTHORIZED");
          helper.writeJWT("");
          helper.writeIsLoggedIn(false);
        }
        helper.writeIsLoggedIn(false);
        throw Exception('Failed to get user.');
      }
    } catch (e){
      throw Exception('Failed to get user. Error: $e');
    }
  }

  @override
  Future<List> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future updateUser(Map<String, dynamic> user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
