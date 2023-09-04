import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/data/local_data_source.dart';
import 'package:sidam_worker/data/remote_data_source.dart';

import 'package:sidam_worker/model/schedule_model.dart';
import 'package:sidam_worker/model/user_model.dart';
import 'package:sidam_worker/model/store.dart';

import 'package:sidam_worker/data/repository/store_repository.dart';

import 'package:sidam_worker/util/date_utility.dart';
import 'package:sidam_worker/util/sp_helper.dart';

class ScheduleRepository {
  final LocalDataSource _dataSource = LocalDataSource();
  final Session _session = Session();
  final StoreRepositoryImpl _storeRepository = StoreRepositoryImpl();
  final _logger = Logger();
  final _helper = SPHelper();

  ScheduleRepository() {
    _helper.init();
    _session.init();
  }

  // 서버에서 데이터를 불러와서 로컬에 저장하는 메소드
  Future<void> getWeeklySchedule(DateTime now) async {

    DateUtility dateUtility = DateUtility();
    Store store = await _storeRepository.getStoreData();
    DateTime getDate = dateUtility.findStartDay(now, store.weekStartDay?? 1);

    _logger.i('${getDate.month}월 ${getDate.day}일 데이터 요청');

    // 서버에 요청
    var url = '/api/schedule/${_helper.getStoreId()}'
        '?id=${_helper.getRoleId()}&version=${DateFormat("yyyy-MM-ddThh:mm:ss").format(DateTime(2023, 01, 01))}'
        '&year=${getDate.year}&month=${getDate.month}&day=${getDate.day}';

    var res = await _session.get(url);

    // json 저장 형식으로 변환해서 객체로 돌려받음
    var saveData = _restructureSchedule(jsonDecode(res.body), getDate);

    // 받아온 스케줄 정보가 없을 경우 저장하지 않고 종료
    if (saveData.isEmpty) {
      _logger.w('${getDate.month}월 ${getDate.day}일에 스케줄이 존재하지 않습니다.');
      return ;
    }
    /*
    _logger.i('${_dataSource.path}에 json 저장');

    _dataSource.saveModels({
      "date": saveData.map<Map<String, dynamic>>((value) => value.toJson()).toList()
    }, 'schedules/scheduleDataSaveTest.json'); // -> 정상 동작, 제대로 파일 불러와서 저장됨
    */
    // 이미 저장된 파일이 있는 경우 -> 불러와서 합치는 과정을 거치고 저장
    _getSave(saveData, getDate);
  }

  // 만약 다음달/이전달과 이번달이 한 주로 받아와졌다면 둘로 쪼개서 저장
  Future<void> _getSave(List<ScheduleList> data, DateTime base) async {

    DateFormat nameFormat = DateFormat("yyyyMM");
    DateTime thisDate = DateTime(base.year, base.month, 1); // 이번달 1일
    DateTime lastDate = DateTime(thisDate.year, thisDate.month - 1, 1).subtract(const Duration(days: 1)); // 저번달 1일
    DateTime nextDate = DateTime(thisDate.year, thisDate.month + 1, 1); // 다음달 1일

    List<ScheduleList> thisMonthSchedule = [];
    List<ScheduleList> lastMonthSchedule = [];
    List<ScheduleList> nextMonthSchedule = [];

    for (var schedule in data) {
      if (schedule.day.month == thisDate.month) {
        thisMonthSchedule.add(schedule);
      }
      else if (schedule.day.month == lastDate.month){
        lastMonthSchedule.add(schedule);
      }
      else {
        nextMonthSchedule.add(schedule);
      }
    }

    // 이번달 데이터 저장 - json -> ScheduleList로 변환해서 전달하기
    if (thisMonthSchedule.isNotEmpty) {
      _combineAndSaveSchedule(
          _localToScheduleList(
              await _dataSource.getSchedule(thisDate)),
          thisMonthSchedule,
          nameFormat.format(thisDate)
      );
    }

    // 지난달 데이터 저장
    if(lastMonthSchedule.isNotEmpty) {
      _combineAndSaveSchedule(
          _localToScheduleList(await _dataSource.getSchedule(lastDate)),
          lastMonthSchedule,
          nameFormat.format(lastDate)
      );
    }

    // 다음달 데이터 저장
    if(nextMonthSchedule.isNotEmpty) {
      _combineAndSaveSchedule(
          _localToScheduleList(await _dataSource.getSchedule(nextDate)),
          nextMonthSchedule,
          nameFormat.format(nextDate)
      );
    }
  }

  // 로컬에 저장되어있던 json을 ScheduleList 형으로 변환
  List<ScheduleList> _localToScheduleList(Map<String, dynamic> json) {

    List<ScheduleList> result = [];

    if (json['date'] == null || json['date'] == 'NON') {
      return [];
    }

    // 날짜별 스케줄 블록들을 확인
    for (var date in json['date']) {
      List<Schedule> schedules = [];
      List<String> stringDay = date['day'].split('-');
      DateTime day = DateTime(int.parse(stringDay[0]), int.parse(stringDay[1]), int.parse(stringDay[2]));

      // 날짜 하나에 붙어있는 블록을 각각 쪼개서 Schedule 객체화
      for (var schedule in date['schedule']) {
        Schedule tmp = Schedule.fromJson(schedule, day);
        schedules.add(tmp);
      }

      ScheduleList temp = ScheduleList(id: date['id'], day: day, schedule: schedules);
      result.add(temp);
    }

    return result;
  }

  // 이미 저장되어있던 파일(saved)을 읽어와서 서버에서 새로 get한 데이터(bring)와 합치고 fileName이란 이름으로 저장
  void _combineAndSaveSchedule(List<ScheduleList> saved, List<ScheduleList> bring, String fileName) {

    bring.sort((a, b) => a.day.compareTo(b.day));

    int last = (bring.length - 1) < 0 ? 0 : bring.length - 1;
    DateTime start = bring[0].day; // 스케줄 시작일
    DateTime next = DateTime(start.year, start.month + 1, 1); // 다음달의 첫날
    DateTime end = bring[last].day.isBefore(next)
        ? bring[last].day : next.subtract(const Duration(days: 1)); // 스케줄 마지막날

    // 스케줄 시작일보다 이전이거나 스케줄 마지막날 이후인 경우 삭제
    saved.removeWhere((element) => start.isBefore(element.day) || end.isAfter(element.day));
    saved.addAll(bring);

    _dataSource.saveModels({
      "date": saved.map<Map<String, dynamic>>((value) => value.toJson()).toList()
    }, 'schedules/$fileName.json');
  }

  // 서버에서 받은 json을 ScheduleList 형으로 변환
  List<ScheduleList> _restructureSchedule(Map<String, dynamic> json, DateTime startDay) {

    List<ScheduleList> list = [];
    List<DateTime> date = [];
    List<Schedule> scheduleList = [];

    if (json['date'] == null) {
      return list;
    }

    for(var schedule in json['date']) {
      List<String> parseDay = '${schedule['day']}'.split('-');
      DateTime day = DateTime(int.parse(parseDay[0]), int.parse(parseDay[1]), int.parse(parseDay[2]));
      Schedule tmp = Schedule.fromJson(schedule, day);

      // day가 시작일자 -1 이후이면 리스트에 추가
      if (day.isAfter(startDay.subtract(const Duration(days: 1))) ){
          // && day.isBefore(startDay.subtract(const Duration(days: 7)))){
        scheduleList.add(tmp);
      }

      if (!date.contains(day)) {
        date.add(day);
      }
    }

    int i = 1;
    for (DateTime time in date) {
      list.add(_combineSameDay(scheduleList, i, time));
      i++;
    }

    return list;
  }

  // 날짜별로 합치기
  ScheduleList _combineSameDay(List<Schedule> data, int idx, DateTime base) {

    List<Schedule> schedules = [];

    for (Schedule schedule in data) {
      if (schedule.day == base) {
        schedules.add(schedule);
      }
    }

    return ScheduleList(id: idx, day: base, schedule: schedules);
  }

  // now를 기준으로 이번달, 저번달/다음달 내 스케줄 전부 읽어오기
  Future<List<Schedule>> loadMySchedule(DateTime now) async {

    Map<String, dynamic> thisTime = await _dataSource.getSchedule(now);
    Map<String, dynamic> pass = {};
    if (now.day < 6) { // 이전달의 데이터가 포함되는 경우
       pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month - 1, 1));
    } else if (now.day > 22) { // 다음달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month + 1, 1));
    }
    List<Schedule> result = [];

    result.addAll(fromJsonSchedule(thisTime, _helper.getRoleId() ?? 0));
    if (pass.isNotEmpty){
      result.addAll(fromJsonSchedule(pass, _helper.getRoleId() ?? 0));
    }
    return result;
  }

  // now를 기준으로 이번달, 저번달/다음달 다른 근무자의 스케줄 전부 읽어오기
  Future<List<Schedule>> loadOtherSchedule(DateTime now, int id) async {

    Map<String, dynamic> thisTime = await _dataSource.getSchedule(now);
    Map<String, dynamic> pass = {};
    if (now.day < 6) { // 이전달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month - 1, 1));
    } else if (now.day > 22) { // 다음달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month + 1, 1));
    }
    List<Schedule> result = [];

    result.addAll(fromJsonSchedule(thisTime, id));
    if (pass.isNotEmpty){
      result.addAll(fromJsonSchedule(pass, id));
    }
    return result;
  }

  /*
  // now를 기준으로 이번달, 저번달/다음달 다른 근무자 스케줄 전부 읽어오기
  Future<List<Schedule>> loadOtherSchedule(DateTime now) async {

    Map<String, dynamic> thisTime = await _dataSource.getSchedule(now);
    Map<String, dynamic> pass = {};
    if (now.day < 6) { // 이전달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month - 1, 1));
    } else if (now.day > 20) { // 다음달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month + 1, 1));
    }
    List<Schedule> result = [];

    await _helper.init();
    result.addAll(fromJsonSchedule(thisTime, false, true));
    if (pass.isNotEmpty) {
      result.addAll(fromJsonSchedule(pass, false, true));
    }

    return result;
  }*/

  // now를 기준으로 이번달, 저번달/다음달 모든 근무자의 스케줄 읽어오기
  Future<List<Schedule>> loadAllSchedule(DateTime now) async {

    Map<String, dynamic> thisTime = await _dataSource.getSchedule(now);
    Map<String, dynamic> pass = {};
    if (now.day < 6) { // 이전달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month - 1, 1));
    } else if (now.day > 20) { // 다음달의 데이터가 포함되는 경우
      pass = await _dataSource
          .getSchedule(DateTime(now.year, now.month + 1, 1));
    }
    List<Schedule> result = [];

    await _helper.init();
    result.addAll(toSchedule(thisTime));
    if (pass.isNotEmpty) {
      result.addAll(toSchedule(pass));
    }

    return result;
  }

  // 읽어온 data 에서 (my = true 나 / false 다른 사용자) 스케줄 변환
  List<Schedule> fromJsonSchedule(Map<String, dynamic> data, int id) {

    List<Schedule> result = [];
    bool insert;

    // json이 없을 경우 처리
    if (data['date'] == null || data['date'] == 'NON') {
      _logger.w('데이터가 존재하지 않음');
      return [];
    }

    for (var day in data['date']) {

      List<String> days = day['day'].split('-');
      DateTime thisDay = DateTime(int.parse(days[0]), int.parse(days[1]), int.parse(days[2]));

      insert = false;
      // 스케줄이 없는 날짜면 더미 추가하고 스킵
      if (day == null) {
        result.add(Schedule(id: 0, day: thisDay, time: [], workers: []));
        continue;
      }

      for (var daily in day['schedule']) {

        Schedule schedule = Schedule.fromJson(daily, thisDay);

        // 근무자 목록 중에서 사용자를 찾음
        for (User u in schedule.workers) {
          if (!result.contains(schedule) && (u.id == id)) {
            result.add(schedule);
            insert = true;
          }
        }
      }

      // add가 안 일어났으면 (= 내 스케줄이 없는 날이었으면) 날짜 더미 추가
      if (!insert) {
        result.add(Schedule(id: 0, day: thisDay, time: [], workers: []));
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));

    return result;
  }

  List<Schedule> toSchedule(Map<String, dynamic> data) {

    List<Schedule> result = [];
    bool insert;

    // json이 없을 경우 처리
    if (data['date'] == null || data['date'] == 'NON') {
      _logger.w('데이터가 존재하지 않음');
      return [];
    }

    for (var day in data['date']) {

      List<String> days = day['day'].split('-');
      DateTime thisDay = DateTime(int.parse(days[0]), int.parse(days[1]), int.parse(days[2]));

      insert = false;
      // 스케줄이 없는 날짜면 더미 추가하고 스킵
      if (day == null) {
        result.add(Schedule(id: 0, day: thisDay, time: [], workers: []));
        continue;
      }

      for (var daily in day['schedule']) {

        Schedule schedule = Schedule.fromJson(daily, thisDay);
        result.add(schedule);
        insert = true;
      }

      // add가 안 일어났으면 (= 내 스케줄이 없는 날이었으면) 날짜 더미 추가
      if (!insert) {
        result.add(Schedule(id: 0, day: thisDay, time: [], workers: []));
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));

    return result;
  }
}