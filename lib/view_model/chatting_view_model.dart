import 'package:flutter/material.dart';
import 'package:sidam_employee/data/repository/user_repository.dart';

import '../model/user_role.dart';

class ChattingViewModel extends ChangeNotifier{
  UserRepository userRepository;
  List<UserRole> userRole =[];

  ChattingViewModel(this.userRepository){
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result = await userRepository.getUsers();
      userRole = result.map((json) => UserRole.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
      print(e);
    }
  }
}