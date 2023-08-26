import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';

import 'package:sidam_worker/repository/schedule_repository.dart';
import 'package:sidam_worker/model/schedule_model.dart';
import 'package:sidam_worker/model/store_model.dart';
import 'package:sidam_worker/repository/store_repository.dart';
import 'package:sidam_worker/utility/date_utility.dart';

class ScheduleViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  late final StoreRepository _storeRepository;

  List<Schedule> _weeklySchedule = []; // 날짜순으로 지난달-이번달 내가 포함된 스케줄
  List<Schedule> get scheduleList => _weeklySchedule;

  ScheduleViewModel() {
    _scheduleRepository = ScheduleRepository();
    _storeRepository = StoreRepository();
    _getScheduleList();
  }

  // 새로고침을 누르면 스케줄을 새로 가지고 올 메소드
  Future<void> renew() async {
    _weeklySchedule = [];
    await _getScheduleList();
  }

  // 화면에 그릴 스케줄을 가지고 오는 메소드
  Future<void> _getScheduleList() async {
    await _scheduleRepository.getWeeklySchedule(DateTime.now());
    List<Schedule> weeklySchedule = await _scheduleRepository.loadMySchedule(DateTime.now());
    _findThisWeekSchedule(weeklySchedule);
    notifyListeners();
  }

  // 가져온 데이터에서 이번주차를 찾아내는 메소드
  Future<void> _findThisWeekSchedule(List<Schedule> data) async {

    Store store = await _storeRepository.getStoreData();
    DateUtility dateUtility = DateUtility();

    // 이번 주차 시작일 찾기
    DateTime now = DateTime.now();
    DateTime beforeDay = dateUtility.findStartDay(DateTime(now.year, now.month, now.day), store.weekStartDay ?? 1);

    // 스케줄을 하나씩 확인해서, 이번 주차인 걸 찾아야됨
    for(Schedule schedule in data) {

      if (schedule.day.isAfter(beforeDay)
          || schedule.day.isBefore(beforeDay.add(const Duration(days: 8)))) {
        _weeklySchedule.add(schedule);
      }
    }

    _weeklySchedule.sort((a, b) => a.day.compareTo(b.day));
  }
}