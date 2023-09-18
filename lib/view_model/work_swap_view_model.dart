import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:sidam_employee/model/user_model.dart';
import 'package:sidam_employee/model/schedule_model.dart';
import 'package:sidam_employee/model/worker_model.dart';

import 'package:sidam_employee/repository/change_request_repository.dart';
import 'package:sidam_employee/repository/user_repository.dart';
import 'package:sidam_employee/repository/schedule_repository.dart';

import 'package:sidam_employee/util/date_utility.dart';
import 'package:sidam_employee/util/sp_helper.dart';

import '../data/repository/store_repository.dart';
import '../model/store.dart';

class WorkSwapViewModel extends ChangeNotifier {
  final _logger = Logger();

  late final ScheduleRepository _scheduleRepository;
  late final StoreRepositoryImpl _storeRepository;
  late final ChangeRequestRepository _changeRequestRepository;
  late final UserRepository _userRepository;
  late final SPHelper _helper;
  final DateUtility _dateUtility = DateUtility();

  List<Schedule> _myWeeklySchedule = []; // 내 주간 스케줄
  List<Schedule> _otherWeeklySchedule = []; // 다른 사람들의 주간 스케줄
  List<Schedule> _allWeeklySchedule = []; // 모든 직원의 주간 스케줄

  // 날짜 / 시각 / 근무자
  //List<List<List<Unit>>> _otherTime = [ [], [], [], [], [], [], [] ];
  //List<List<List<Unit>>> get otherSchedules => _otherTime;

  // 근무자 list
  List<Worker> workers = [];

  DateTime _week = DateTime.now(); // 화면에 그리고 있는 스케줄의 주차 시작일
  DateTime get week => _week;

  List<Schedule> get mySchedules => _myWeeklySchedule;
  List<Schedule> get otherSchedules => _otherWeeklySchedule;

  int otherId = 0; // 교환하려는 사람의 id
  String name = ''; // 교환하려는 사람의 이름
  //int _open = 0,
  //    _closed = 0; // 매장 여닫는 시간
  User? myData;

  Schedule? mySchedule; // 바꾸려는 내 스케줄
  Schedule? target; // 바꾸고 싶은 대상 스케줄

  bool _loading = false; // 현재 스케줄 교환 api를 전송하고 대기중인지 여부
  bool get loading => _loading;
  bool _result = false; // 스케줄 교환 api의 전송 결과
  bool get result => _result;
  bool _deon = false; // 모든 교환 절차가 완료되었는지 확인하는 메소드
  bool get deon => _deon;
  bool _targeting = false; // 비지정인지 지정인지 구분, 지정 = true, 비지정 = false
  bool get targeting => _targeting;

  WorkSwapViewModel() {
    _userRepository = UserRepository();
    _scheduleRepository = ScheduleRepository();
    _changeRequestRepository = ChangeRequestRepository();
    _storeRepository = StoreRepositoryImpl();
    _helper = SPHelper();
    _helper.init();
    getMyData();
    //getOpenClose();

    _week = _dateUtility.findStartDay(
        DateTime.now(), _helper.getWeekStartDay() ?? 1);

    _getScheduleList();
  }

  void getMyData() async {
    myData = await _userRepository.getUserData();
  }

  /*void getOpenClose() async {
    Store store = await _storeRepository.getStoreData();
    _open = store.open ?? 0;
    _closed = store.close ?? 24;
  }*/

  // 모든 선택을 초기화하는 메소드
  void init() {
    _result = false;
    _deon = false;
    mySchedule = null;
    target = null;
    _week = _dateUtility.findStartDay(
        DateTime.now(), _helper.getWeekStartDay() ?? 1);
  }

  // 근무자 버튼을 누르면 해당 근무자의 근무를 가져오는 버튼
  void getOtherWorkerSchedule() {
    _otherWeeklySchedule = _filterOtherSchedule();
  }

  // 스케줄의 시작 시각 찾기
  int findStartTime(Schedule schedule) {
    for (int i = 0; i < schedule.time.length; i++) {
      if (schedule.time[i]) {
        return i;
      }
    }

    return 0;
  }

  // schedule 객체의 근무 시간을 계산해 숫자로 변환하는 메소드
  int calculateTime(Schedule schedule) {
    int time = 0;
    for (bool t in schedule.time) {
      if (t) {
        time++;
      }
    }
    return time;
  }

  // now 날짜를 포함하는 주차의 시작일을 찾는 메소드
  DateTime findStartDay(DateTime now) {
    return _dateUtility.findStartDay(
        DateTime(now.year, now.month, now.day), _helper.getWeekStartDay() ?? 1);
  }

  // 화면에 그릴 스케줄의 날짜를 바꾸는 메소드
  Future<void> changeDate(DateTime date) async {
    _week = findStartDay(date);
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
    _logger
        .i('${DateFormat('yyyy년 MM월 dd일').format(_week)} 날짜의 스케줄 loading...');
    await _getSchedule(_week);
    _setScheduleDummy(_week);

    _logger.i('$_week에 ${_myWeeklySchedule.length}개의 스케줄 불러옴');
    for (var schedule in _myWeeklySchedule) {
      log('${schedule.day}');
    }

    notifyListeners();
  }

  // 화면을 그리는 데 필요한 데이터를 가져올 메소드
  Future<void> _getSchedule(DateTime now) async {
    _allWeeklySchedule = await _findNowWeekSchedule(
        await _scheduleRepository.loadAllSchedule(now), now); // ok
    _myWeeklySchedule = await _findNowWeekSchedule(
        await _scheduleRepository.loadMySchedule(now), now);

    workers = await getWorkerList();
  }

  // 가져온 데이터(data)에서 특정 날짜(now)가 포함된 주차의 데이터를 찾아서 스케줄 목록에 저장하는 메소드
  Future<List<Schedule>> _findNowWeekSchedule(List<Schedule> data, DateTime now) async {
    List<Schedule> result = [];

    // 이번 주차 시작일 찾기
    DateTime beforeDay = findStartDay(now);

    _logger.w('가져온 데이터 확인 ${data.length}개');

    // 스케줄을 하나씩 확인해서, 이번 주차인 걸 찾아야 됨
    for (Schedule schedule in data) {
      log('${DateFormat('yyyy년 MM월 dd일').format(_week)} : ${schedule.day}일자');
      if (schedule.day.isAfter(beforeDay
              .subtract(const Duration(days: 1))) // schedule의 day가 시작일 이후고
          &&
          schedule.day.isBefore(beforeDay.add(const Duration(days: 7)))) {
        // 시작일 + 7일 이전인
        result.add(schedule);
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));
    return result;
  }

  // 근무가 있는 근무자 list 반환
  Future<List<Worker>> getWorkerList() async {
    List<Worker> result = [];

    for (var s in _allWeeklySchedule) {
      for (var w in s.workers) {
        if (w.id != (_helper.getRoleId() ?? 0)) {
          Worker tmp = Worker(id: w.id, name: w.name, color: w.color);
          result.add(tmp);
        }
      }
    }

    result.removeWhere((element) =>
        element != result.firstWhere((entity) => entity.id == element.id));

    return result;
  }

  /*
  // 스케줄 시간 버튼 처리기, 조건에 맞게 mySchedule 혹은 target에 저장
  void chooseSchedule(Schedule ob, bool sw) {
    if (sw) {
      mySchedule = ob;
      _logger.i('${ob.id}가 mySchedule에 저장됨');
    } else {
      target = ob;
      _logger.i('${ob.id}가 target에 저장됨');
    }
  }
  */

  // 전체 스케줄 중 선택된 근무자의 스케줄만 추려 가지고 오는 메소드
  List<Schedule> _filterOtherSchedule() {
    List<Schedule> result = [];

    // otherId가 0이면 선택에 오류가 있거나, 아직 선택되지 않았다는 뜻이라 빈칸 반환
    if (otherId == 0) {
      return [];
    }

    // 전체 스케줄을 하나씩 확인해서 otherId를 가진 근무자가 포함된 것만 거름
    for (var s in _allWeeklySchedule) {
      for (var worker in s.workers) {
        if (worker.id == otherId) {
          result.add(s);
        }
      }
    }

    // 근무가 없는 날짜에 더미 넣어주기
    for (int i = 0; i < 7; i++) {
      bool check = true;
      for (var s in result) {
        if (s.day.day == week.add(Duration(days: i)).day) {
          check = false;
        }
      }

      if (check) {
        result.add(Schedule(
            id: 0, day: week.add(Duration(days: i)), time: [], workers: []));
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));

    return result;
  }

  // 근무 교환 요청을 서버에 전송하는 api
  Future<void> postChangeReq(bool exist) async {
    bool tmp = false;

    if (!loading) {
      _loading = true;
      _result = false;
      _deon = false;
      notifyListeners();

      if (mySchedule != null) {
        // 비지정 요청이면
        if (!exist || target == null) {
          _targeting = false;
          tmp = await _changeRequestRepository.nonTargetChange(
              _helper.getStoreId() ?? 0,
              _helper.getRoleId() ?? 0,
              mySchedule!.id);
        } else {
          _targeting = true;
          tmp = await _changeRequestRepository.targetingChange(
              _helper.getStoreId() ?? 0,
              _helper.getRoleId() ?? 0,
              otherId,
              mySchedule!.id,
              target!.id);
        }
      }

      Future.delayed(const Duration(milliseconds: 1000), () {

        _logger.i('교환 요청 전송 결과 = $tmp');

        _result = tmp;
        _loading = false;
        _deon = true;
        notifyListeners();
      });
    }
  }

  // 없는 날짜에 더미 추가
  void _setScheduleDummy(DateTime start) async {

    Store store = await _storeRepository.getStoreData();

    bool check;
    for (int i = 0; i < 7; i++){

      check = false;
      for (var schedule in _myWeeklySchedule) {
        if (schedule.day == start.add(Duration(days: i))) {
          log('데이터 있음, ${DateFormat('MM월 dd일').format(start.add(Duration(days: i)))}');
          check = true;
        }
      }

      if (!check) {
        log('더미 추가, ${DateFormat('MM월 dd일').format(start.add(Duration(days: i)))}');
        _myWeeklySchedule.add(
            Schedule.dummy(
                start.add(Duration(days: i)),
                ((store.close ?? 0) - (store.open ?? 0))
            )
        );
      }
    }
  }
}
/*
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
   */
