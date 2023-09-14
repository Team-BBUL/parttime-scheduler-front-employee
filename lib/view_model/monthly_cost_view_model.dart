import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:sidam_employee/model/schedule_model.dart';
import 'package:sidam_employee/model/user_model.dart';
import 'package:sidam_employee/repository/schedule_repository.dart';
import 'package:sidam_employee/repository/user_repository.dart';

class MonthlyCostViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  late final UserRepository _userRepository;
  int _sumCost = 0;
  int get monthlyPay => _sumCost;

  // Map<DateTime, int> _dailyCost = [];
  // Map<DateTime, int> get dailyCost => _dailyCost;

  MonthlyCostViewModel() {
    _scheduleRepository = ScheduleRepository();
    _userRepository = UserRepository();
    _getMonthlyPay(DateTime.now());
  }

  // schedule 객체의 근무 시간을 계산해 숫자로 변환하는 메소드
  int _calculateTime(Schedule schedule) {

    int time = 0;
    for (bool t in schedule.time) {
      if (t) {
        time++;
      }
    }
    return time;
  }

  // 새로고침
  Future<void> renew() async {
    _sumCost = 0;
    await _getMonthlyPay(DateTime.now());
  }

  Future<void> _getMonthlyPay(DateTime now) async {

    List<Schedule> weeklySchedule = await _scheduleRepository.loadMySchedule(now);
    User user = await _userRepository.getUserData();

    int pay = 0;

    // schedule을 하나씩 확인해서, '이번달 && 과거+오늘 && !더미 날짜'일 경우 합산
    for (Schedule schedule in weeklySchedule) {
      if(schedule.day.month == DateTime.now().month
          && schedule.day.isBefore(DateTime.now()) && schedule.id != 0) {
        pay += _calculateTime(schedule) * user.cost;
      }
    }

    _sumCost = pay;
    notifyListeners();
  }
}