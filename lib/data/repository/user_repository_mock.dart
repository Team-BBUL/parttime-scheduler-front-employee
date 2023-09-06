import 'package:sidam_employee/data/repository/user_repository.dart';
import 'package:sidam_employee/model/account.dart';


class MockUserRepository extends UserRepository{
  @override
  Future<List<dynamic>> getUsers() async {
    List<dynamic> testData = [
      {
        "user_role_id" : "1",
        "kakao_id" : "test1",
        "alias" : "홍길동",
        'level': "매니저",
        "cost": "9600",
        "color" : "red",
        "isSalary" : false,
        'valid': false,
      },
      {
        "user_role_id" : "2",
        "kakao_id" : "test2",
        "alias" : "성춘향",
        'level': "직원",
        "cost": "9600",
        "color" : "red",
        "isSalary" : false,
        'valid': false,

      },
      {
        "user_role_id" : "3",
        "kakao_id" : "test3",
        "alias" : "이아무개",
        'level': "아르바이트",
        "cost": "9600",
        "color" : "red",
        "isSalary" : false,
        'valid': false,
      }
    ];

    return testData;
  }


  @override
  Future updateUser(Map<String, dynamic> user) {
    throw UnimplementedError();
  }

  @override
  Future deleteUser(String id) {
    throw UnimplementedError();
  }

  @override
  Future createUser(String name) {
    throw UnimplementedError();
  }

  @override
  Future<Account> getUser() {
    throw UnimplementedError();
  }

  @override
  Future<Account> fetchUser() {
    // TODO: implement fetchUser
    throw UnimplementedError();
  }

}