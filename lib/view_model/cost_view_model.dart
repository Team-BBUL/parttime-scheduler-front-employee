import 'package:flutter/material.dart';
import 'package:sidam_employee/data/model/schedule.dart';
import 'package:sidam_employee/data/repository/local_repository.dart';

class CostViewModel extends ChangeNotifier{
  final ScheduleRepository _scheduleRepository = ScheduleRepository();

  List<Schedule> _schedule = [];
  List<Schedule> get schedule => _schedule;

  CostViewModel(){
    loadData();
  }

  Future<void> loadData() async {
    _schedule = await _scheduleRepository.getItemsFromJsonAssets();
    notifyListeners();
  }
}