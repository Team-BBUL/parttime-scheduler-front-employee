import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:sidam_employee/model/store.dart';

import '../data/repository/store_repository.dart';
import '../repository/schedule_repository.dart';
import '../util/date_utility.dart';
import '../util/sp_helper.dart';
import '../model/schedule_model.dart';

class WeeklyScheduleViewModel extends ChangeNotifier{

  late final SPHelper _helper;
  late final ScheduleRepository _scheduleRepository;
  late final StoreRepositoryImpl _storeRepository;
  late final DateUtility _dateUtility;
  Map<DateTime, List<ViewSchedule>> _weeklySchedule = {}; // 화면에 그릴 주간 모든 근무자 스케줄
  Map<DateTime, List<ViewSchedule>> get weekly => _weeklySchedule;
  late DateTime _now; // 오늘
  late DateTime _weekStart; // 주 시작일
  DateTime get thisWeek => _weekStart;
  bool _loading = false; // 데이터 로딩중인지 확인
  bool get loading => _loading;
  Store _store = Store();
  Store get store => _store;
  final Logger _logger = Logger();

  WeeklyScheduleViewModel() {
    _helper = SPHelper();
    _scheduleRepository = ScheduleRepository();
    _storeRepository = StoreRepositoryImpl();
    _dateUtility = DateUtility();
    _now = DateTime.now();
    _weekStart = _dateUtility.findStartDay(_now, _helper.getWeekStartDay() ?? 1);

    _init();
    getStore();
    _getData();
  }

  Future<void> _init() async {
    await _helper.init();
    _weekStart = _dateUtility.findStartDay(_now, _helper.getWeekStartDay() ?? 1);
  }

  // 주간 전체 스케줄 가져오는 핵심 메소드
  Future<void> _getData() async {
    _weeklySchedule = {};
    await _fetchSchedule();
    notifyListeners();
  }

  // 새로고침 버튼
  Future<void> renew() async {
    _getData();
    notifyListeners();
  }

  // 하루씩 가져와서 일주일 만들기
  Future<void> _fetchSchedule() async {
    if (!_loading){
      _loading = true;

      for (int i = 0; i < 7; i++) {
        List<ViewSchedule> tmp = await _scheduleRepository
            .loadTodaySchedule(_weekStart.add(Duration(days: i)));

        log('${_weekStart.add(Duration(days: i)).toIso8601String()} 날짜에 ${tmp.length}개 json에서 불러옴');
        _weeklySchedule[_weekStart.add(Duration(days: i))] = tmp;
      }

      _logger.w('가져온 스케줄 개수 = ${_weeklySchedule.length} 개');

      Future.delayed(const Duration(milliseconds: 300), () {
        _loading = false;
        notifyListeners();
      });
    }
  }

  // 가져올 데이터를 저번 주차로 변경하기
  void before() async {

    _weekStart = _weekStart.subtract(const Duration(days: 7));
    _getData();
    notifyListeners();
  }

  // 가져올 데이터를 다음 주차로 변경하기
  void after() async {

    _weekStart = _weekStart.add(const Duration(days: 7));
    _getData();
    notifyListeners();
  }

  Future getStore() async {
    _store = await _storeRepository.loadStore();
  }
}