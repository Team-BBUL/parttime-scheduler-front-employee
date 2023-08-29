import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/model/user_model.dart';
import 'package:sidam_worker/model/schedule_model.dart';
import 'package:sidam_worker/model/store_model.dart';
import 'package:sidam_worker/repository/store_repository.dart';
import 'package:sidam_worker/repository/user_repository.dart';
import 'package:sidam_worker/repository/schedule_repository.dart';

import 'package:sidam_worker/utility/date_utility.dart';
import 'package:sidam_worker/utility/sp_helper.dart';

class WorkSwapViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  late final StoreRepository _storeRepository;
  late final UserRepository _userRepository;
  late final SPHelper _helper;
  final DateUtility _dateUtility = DateUtility();

  List<Schedule> _myWeeklySchedule = []; // 내 주간 스케줄
  List<Schedule> _otherWeeklySchedule = []; // 다른 사람들의 주간 스케줄
  List<Schedule> _allWeeklySchedule = []; // 모든 직원의 주간 스케줄

  // 날짜 / 시각 / 근무자
  List<List<List<Unit>>> _otherTime = [ [], [], [], [], [], [], [] ];
  DateTime _week = DateTime.now(); // 화면에 그리고 있는 스케줄의 주차 시작일

  DateTime get week => _week;
  List<Schedule> get mySchedules => _myWeeklySchedule;
  List<Schedule> get schedules => _allWeeklySchedule;
  List<List<List<Unit>>> get otherSchedules => _otherTime;
  int _open = 0, _closed = 0; // 매장 여닫는 시간
  User? myData;

  Schedule? mySchedule; // 바꾸려는 내 스케줄
  Schedule? target; // 바꾸고 싶은 대상 스케줄

  WorkSwapViewModel() {
    _userRepository = UserRepository();
    _scheduleRepository = ScheduleRepository();
    _storeRepository = StoreRepository();
    _helper = SPHelper();
    _helper.init();
    getMyData();
    getOpenClose();

    _week = _dateUtility.findStartDay(DateTime.now(), _helper.getWeekStartDay() ?? 1);

    _getScheduleList();
  }

  void getMyData() async {
    myData = await _userRepository.getUserData();
  }

  void getOpenClose() async {
    Store store = await _storeRepository.getStoreData();
    _open = store.open ?? 0;
    _closed = store.close ?? 24;
  }

  // 모든 선택을 초기화하는 메소드
  void init() {
    mySchedule = null;
    target = null;
    _week = _dateUtility.findStartDay(DateTime.now(), _helper.getWeekStartDay() ?? 1);
  }

  // now 날짜를 포함하는 주차의 시작일을 찾는 메소드
  DateTime _findStartDay(DateTime now) {

    return _dateUtility.findStartDay(DateTime(now.year, now.month, now.day), _helper.getWeekStartDay() ?? 1);
  }

  // 화면에 그릴 스케줄의 날짜를 바꾸는 메소드
  Future<void> changeDate(DateTime date) async {
    _week = _findStartDay(date);
    await renew();
  }

  // 새로고침을 누르면 스케줄을 새로 가지고 올 메소드
  Future<void> renew() async {
    _myWeeklySchedule = [];
    _otherWeeklySchedule = [];
    _allWeeklySchedule = [];
    await _getScheduleList();
  }

  // 화면에 그릴 스케줄을 가지고 오고 변화를 기다리는 provider의 핵심 메소드
  Future<void> _getScheduleList() async {
    _logger.i('${DateFormat('yyyy년 MM월 dd일').format(_week)} 날짜의 스케줄 loading...');
    await _getSchedule(_week);

    notifyListeners();
  }
  
  // 근무표 데이터를 가져올 메소드
  Future<void> _getSchedule(DateTime now) async {

    _allWeeklySchedule = await _findNowWeekSchedule(await _scheduleRepository.loadAllSchedule(now), now); // ok
    _myWeeklySchedule = await _findNowWeekSchedule(await _scheduleRepository.loadMySchedule(now), now);
    _otherWeeklySchedule = await _findNowWeekSchedule(await _scheduleRepository.loadOtherSchedule(now), now);

    _otherTime = otherDrawer(_otherWeeklySchedule);
  }

  // 가져온 데이터(data)에서 특정 날짜(now)가 포함된 주차의 데이터를 찾아서 스케줄 목록에 저장하는 메소드
  Future<List<Schedule>> _findNowWeekSchedule(List<Schedule> data, DateTime now) async {

    List<Schedule> result = [];

    // 이번 주차 시작일 찾기
    DateTime beforeDay = _findStartDay(now);

    // 스케줄을 하나씩 확인해서, 이번 주차인 걸 찾아야 됨
    for(Schedule schedule in data) {

      if (schedule.day.isAfter(beforeDay.subtract(const Duration(days: 1))) // schedule의 day가 시작일 이후고
          && schedule.day.isBefore(beforeDay.add(const Duration(days: 7)))) { // 시작일 + 7일 이전인
        result.add(schedule);
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));
    return result;
  }

  // 스케줄 시간 버튼 처리기, 조건에 맞게 mySchedule 혹은 target에 저장
  void chooseSchedule(Schedule ob, bool sw) {

    if(sw) {
      mySchedule = ob;
      _logger.i('${ob.id}가 mySchedule에 저장됨');
    } else {
      target = ob;
      _logger.i('${ob.id}가 target에 저장됨');
    }
  }

  // 다른 근무자들의 스케줄을 화면에 그릴 형태로 변형하는 메소드
  List<List<List<Unit>>> otherDrawer(List<Schedule> schedules) {

    List<List<List<Unit>>> result = [[], [], [], [], [], [], []];

    for (int i = 0; i < _closed - _open; i++) {
      result[0].add([]); // 주 시작일
      result[1].add([]);
      result[2].add([]);
      result[3].add([]);
      result[4].add([]);
      result[5].add([]);
      result[6].add([]); // 주 마지막날
    }

    int idx;
    for (var schedule in schedules) {
      idx = schedule.day.day - _week.day < 0 ?
      schedule.day.day - _week.day + DateTime(_week.year, _week.month + 1, 1).subtract(const Duration(days: 1)).day
          : schedule.day.day - _week.day;

      for (int i = 0; i < _closed - _open; i++) {

        for (var worker in schedule.workers){

          if (schedule.time[i]) {
            result[idx][i].add(Unit(
                id: worker.id, alias: worker.name, scheduleId: schedule.id, color: worker.color)
            );
          }
        }
      }
    }

    return result;
  }
}

class Unit {
  int id;
  String alias;
  int scheduleId;
  String color;

  Unit({
    required this.id,
    required this.alias,
    required this.scheduleId,
    required this.color,
  });
}