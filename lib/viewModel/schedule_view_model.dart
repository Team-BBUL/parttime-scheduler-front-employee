import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';

import 'package:sidam_worker/repository/schedule_repository.dart';
import 'package:sidam_worker/model/schedule_model.dart';

class ScheduleViewModel extends ChangeNotifier {
  var logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  List<Schedule> _weeklySchedule = [];
  List<Schedule> get scheduleList => _weeklySchedule;

  ScheduleViewModel() {
    _scheduleRepository = ScheduleRepository();
    _getScheduleList();
  }

  Future<void> _getScheduleList() async {
    _weeklySchedule = await _scheduleRepository.loadMySchedule(DateTime.now());
    notifyListeners();
  }
}