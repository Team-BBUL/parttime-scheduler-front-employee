import 'package:flutter/cupertino.dart';

import 'package:logger/logger.dart';
import 'package:sidam_employee/data/repository/store_repository.dart';

import 'package:sidam_employee/repository/schedule_repository.dart';
import 'package:sidam_employee/model/schedule_model.dart';
import 'package:sidam_employee/model/store.dart';
import 'package:sidam_employee/util/date_utility.dart';
import 'package:sidam_employee/util/sp_helper.dart';

class ScheduleViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  late final StoreRepositoryImpl _storeRepository;
  late final SPHelper _helper;
  late final DateUtility _dateUtility;

  List<Schedule> _weeklySchedule = []; // 날짜순으로 지난달-이번달 내가 포함된 스케줄
  List<Schedule> get scheduleList => _weeklySchedule;

  DateTime _week = DateTime.now();
  DateTime get week => _week;

  bool _monthly = false;

  ScheduleViewModel() {
    _scheduleRepository = ScheduleRepository();
    _storeRepository = StoreRepositoryImpl();
    _dateUtility = DateUtility();
    _helper = SPHelper();
    _helper.init();

    init();
    _getScheduleList();
  }

  void init() async {
    await _helper.init();
    _week = _dateUtility.findStartDay(DateTime.now(), _helper.getWeekStartDay() ?? 1);
  }

  // 새로고침을 누르면 스케줄을 새로 가지고 올 메소드
  Future<void> renew() async {
    _weeklySchedule = [];
    await _getScheduleList();
    notifyListeners();
  }

  // 화면에 그릴 스케줄을 가지고 오는 메소드
  Future<void> _getScheduleList() async {

    try{
      List<Schedule> weeklySchedule =
          await _scheduleRepository.loadMySchedule(DateTime.now());
      _findThisWeekSchedule(weeklySchedule);

      if (!_monthly) {
        _getMonthSchedule();
      }
      _scheduleRepository.getWeeklySchedule(DateTime.now()); // 서버에서 데이터 가져옴

      _setScheduleDummy(_dateUtility.findStartDay(DateTime.now(), _helper.getWeekStartDay() ?? 1));

    } catch(error) {
      _logger.e('$error');
      _setScheduleDummy(_dateUtility.findStartDay(DateTime.now(), _helper.getWeekStartDay() ?? 1));
    }

    notifyListeners();
  }

  // 가져온 데이터에서 이번주차를 찾아내는 메소드
  Future<void> _findThisWeekSchedule(List<Schedule> data) async {
    // 이번 주차 시작일 찾기
    DateTime startDay = _dateUtility.findStartDay(
        DateTime.now(), _helper.getWeekStartDay() ?? 1);

    // 스케줄을 하나씩 확인해서, 이번 주차인 걸 찾아야됨
    for (Schedule schedule in data) {
      if (schedule.day.isAfter(startDay.subtract(const Duration(days: 1)))
          && schedule.day.isBefore(startDay.add(const Duration(days: 7)))) {
        _weeklySchedule.add(schedule);
      }
    }

    _setScheduleDummy(startDay);
    _weeklySchedule.sort((a, b) => a.day.compareTo(b.day));
  }

  // 이번 주로부터 4주차 이전까지의 데이터를 가지고 오는 메소드
  Future<void> _getMonthSchedule() async {
    _logger.i('4주 치 데이터 요청');

    DateUtility dateUtility = DateUtility();

    DateTime now = DateTime.now();
    DateTime start = dateUtility.findStartDay(now, _helper.getWeekStartDay() ?? 1);
    DateTime thisWeek = start;

    for (int i = 1; i <= 4; i++) {
      thisWeek = thisWeek.subtract(const Duration(days: 7));
      await _scheduleRepository.getWeeklySchedule(thisWeek);
    }
    _monthly = true;
  }

  // 없는 날짜에 더미 추가
  void _setScheduleDummy(DateTime start) async {

    Store store = await _storeRepository.getStoreData();

    bool check;
    for (int i = 0; i < 7; i++){

      check = false;
      for (var schedule in _weeklySchedule) {
        if (schedule.day == start.add(Duration(days: i))) {
          check = true;
        }
      }

      if (!check) {
        _weeklySchedule.add(
            Schedule.dummy(
                start.add(Duration(days: i)),
                ((store.close ?? 0) - (store.open ?? 0))
            )
        );
      }
    }
  }
}