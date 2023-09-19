import 'package:sidam_employee/data/local_data_source.dart';
import 'package:sidam_employee/model/user_model.dart';

class UserRepository {
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<User> getUserData() async {

    Map<String, dynamic>? data = await _localDataSource.loadJson('userData');

    if (data == null) {
      return User(alias: 'NON', id: 0, color: '0xFFFFFFFF`', cost: 0);
    }

    return User.fromJson(data);
  }
}