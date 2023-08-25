import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/data/local_data_source.dart';
import 'package:sidam_worker/data/remote_data_source.dart';
import 'package:sidam_worker/model/schedule_model.dart';
import 'package:sidam_worker/model/user_model.dart';
import 'package:sidam_worker/model/store_model.dart';
import 'package:sidam_worker/repository/store_repository.dart';
import 'package:sidam_worker/utility/date_utility.dart';
import 'package:sidam_worker/utility/sp_helper.dart';

class ScheduleRepository {
  final LocalDataSource _dataSource = LocalDataSource();
  final Session _session = Session();
  final StoreRepository _storeRepository = StoreRepository();
  final _logger = Logger();
  final _helper = SPHelper();

  ScheduleRepository() {
    _helper.init();
    _session.init();
  }

  Future<void> getThisWeekSchedule(DateTime now) async {

    DateUtility dateUtility = DateUtility();
    Store store = await _storeRepository.getStoreData();
    DateTime getDate = DateTime(2023, 08, 28); //dateUtility.findStartDay(now, store.weekStartDay?? 1);

    _logger.i('${getDate.month}월 ${getDate.day}일 데이터 요청');

    //디버깅용 store id 및 user role id 하드코딩
    _helper.writeRoleId(1);
    _helper.writeStoreId(1);

    // 서버에 요청
    var url = '/api/schedule/${_helper.getStoreId()}'
        '?id=${_helper.getRoleId()}&version=${DateFormat("yyyy-MM-ddThh:mm:ss").format(DateTime(2023, 01, 01))}'
        '&year=${getDate.year}&month=${getDate.month}&day=${getDate.day}';

    var res = await _session.get(url);

    // json 저장 형식으로 변환해서 객체로 돌려받음
    var saveData = _restructureSchedule(jsonDecode(res.body), getDate);

    _logger.i('${_dataSource.path}에 json 저장');



    // 이미 저장된 파일이 있는 경우 -> 불러와서 합치는 과정을 거치고 저장
  }

  // 만약 다음달과 이번달이 한 주로 받아와졌다면 둘로 쪼개서 저장
  Future<void> _getSave(List<ScheduleList> data) async {

    DateFormat nameFormat = DateFormat("yyyyMM");
    DateTime thisDate = DateTime.now();
    DateTime nextDate = DateTime(thisDate.year, thisDate.month, 1).subtract(const Duration(days: 1));

    List<ScheduleList> thisMonthSchedule = [];
    List<ScheduleList> nextMonthSchedule = [];

    for (var schedule in data) {
      if (schedule.day.month == thisDate.month) {
        thisMonthSchedule.add(schedule);
      }
      else {
        nextMonthSchedule.add(schedule);
      }
    }

    // 이번달 데이터 저장 - json -> ScheduleList로 변환해서 전달하기
    //_combineAndSaveSchedule(, thisMonthSchedule, nameFormat.format(thisDate));

    // 다음달 데이터 저장
    await _dataSource.saveModels({
      "date": nextMonthSchedule.map<Map<String, dynamic>>((value) => value.toJson()).toList()
    }, 'schedules/${nameFormat.format(nextDate)}');
  }

  // 이미 저장되어있던 파일을 읽어와서 서버에서 새로 get한 데이터와 합치고 저장
  void _combineAndSaveSchedule(List<ScheduleList> saved, List<ScheduleList> bring, String fileName) {

    bring.sort((a, b) => a.day.compareTo(b.day));

    int last = (bring.length - 1) < 0 ? 0 : bring.length - 1;
    DateTime start = bring[0].day; // 스케줄 시작일
    DateTime next = DateTime(start.year, start.month + 1, 1); // 다음달의 첫날
    DateTime end = bring[last].day.isBefore(next)
        ? bring[last].day : next.subtract(const Duration(days: 1)); // 스케줄 마지막날

    // 스케줄 시작일보다 이전이거나 스케줄 마지막날 이후인 경우 삭제
    saved.removeWhere((element) => start.isBefore(element.day) || end.isAfter(element.day));

    _dataSource.saveModels({
      "date": saved.map<Map<String, dynamic>>((value) => value.toJson()).toList()
    }, 'schedules/$fileName');
  }

  // json을 저장 형식으로 변환
  List<ScheduleList> _restructureSchedule(Map<String, dynamic> json, DateTime startDay) {

    List<ScheduleList> list = [];
    List<DateTime> date = [];
    List<Schedule> scheduleList = [];

    if (json['date'] == null) {
      return list;
    }

    for(var schedule in json['date']) {
      DateTime day = DateTime.parse(schedule['day']);
      Schedule tmp = Schedule.fromJson(schedule, day);

      // day가 시작일자 -1 이후이면 리스트에 추가
      if (day.isAfter(startDay.subtract(const Duration(days: 1)))){
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

  // 이번달, 저번달 스케줄 전부 읽어오기
  Future<List<Schedule>> loadMySchedule(DateTime now) async {

    Map<String, dynamic> thisTime = await _dataSource.getSchedule(now);
    Map<String, dynamic> pass = await _dataSource.getSchedule(DateTime(now.year, now.month - 1, now.day));
    List<Schedule> result = [];

    result.addAll(fromJsonSchedule(thisTime, true));
    result.addAll(fromJsonSchedule(pass, true));

    return result;
  }

  // json을 fromJsonSchedule을 이용해서 ScheduleList로 변환하기
  List<ScheduleList> fromJsonScheduleList(List<Schedule> schedule) {
    return [];
  }

  // 읽어온 data 에서 (my = true 내가 있는 / my = false 모두) 스케줄 변환
  List<Schedule> fromJsonSchedule(Map<String, dynamic> data, bool my) {

    List<Schedule> result = [];
    bool insert;

    // json이 없을 경우 처리
    if (data['data'] == null || data['data'] == 'NON') {
      return [];
    }

    // 이번달 내 스케줄 찾기
    for (var day in data['date']) {

      insert = false;
      // 스케줄이 없는 날짜면 스킵
      if (day == null) {
        result.add(Schedule(id: 0, day: DateTime.parse(day['day']), time: [], workers: []));
        continue;
      }

      for (var daily in day['schedule']) {

        Schedule schedule = Schedule.fromJson(daily, DateTime.parse(day['day']));

        // 근무자 목록 중에서 사용자를 찾음
        for (User u in schedule.workers) {
          if (!my || u.id == 7) { //_helper.getRoleId()) {
            result.add(schedule);
            insert = true;
          }
        }
      }

      // add가 안 일어났으면 (= 내 스케줄이 없는 날이었으면) 날짜 더미 추가
      if (!insert) {
        result.add(Schedule(id: 0, day: DateTime.parse(day['day']), time: [], workers: []));
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));

    return result;
  }
}