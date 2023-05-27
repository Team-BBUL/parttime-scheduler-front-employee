import '../model/user_role.dart';

abstract class UserRepository{
  Future<List<dynamic>> getUsers();
  Future<dynamic> getUser(String id);
  // Future<dynamic> createUser(String kakaoId);
  Future<dynamic> updateUser(Map<String, dynamic> user);
  Future<dynamic> deleteUser(String id);
}