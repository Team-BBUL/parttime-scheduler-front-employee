import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:sidam_employee/util/sp_helper.dart';

import '../../model/schedule.dart';
import '../local_data_source.dart';


class ScheduleLocalRepository{

  DateTime? _curDate;
  DateTime? _prevDate;
  int? _costDay;
  String? _recentTimeStamp;
  int? _roleId;

  Future<MonthSchedule> fetchSchedule(DateTime date) async {
    try {
      dynamic decodedData = await getFileData(date);
      return MonthSchedule.fromJson(decodedData);
    } catch (e) {
      log('fetchSchedule : Error loading cells from JSON: $e');
    }
    log("fetchSchedule");
    return MonthSchedule();
  }

  Future<MonthSchedule> fetchScheduleByPaycheck(DateTime date, int costDay) async {
    initData(date, costDay);
    try {
      Map<String, dynamic> data = await getScheduleBasedOnCostDay();
      return MonthSchedule.fromJson(data);
    }catch(e){
      return MonthSchedule();
    }
  }

  initData(DateTime date, int day){
    SPHelper helper = SPHelper();
    _curDate = date;
    _costDay = day;
    _prevDate = getPrevYearMonth(date, day);
    _roleId = helper.getRoleId();
    _recentTimeStamp = null;
  }

  Future<int> getPrevMonthCost(DateTime date, int costDay) async{
    DateTime prevYearMonth = getPrevYearMonth(date, costDay);
    initData(prevYearMonth, costDay);
    Map<String,dynamic> data = await getScheduleBasedOnCostDay();
    return calculateTotalCostWithJson(data);
  }

  //TODO calculateTotalCost 코드 중복 => ScheduleRepository
  int calculateTotalCostWithJson(Map<String, dynamic> data) {
    int totalCost = 0;

    List<dynamic> dates = data['date'];
    for (var date in dates) {
      List<dynamic> schedules = date['schedule'];
      for (var schedule in schedules) {
        List<dynamic> time = schedule['time'];
        int times = 0;
        for (var i = 0; i < time.length; i++) {
          if (time[i] == true) {
            times++;
          }
        }
        List<dynamic> workers = schedule['workers'];
        for (var i = 0; i < workers.length; i++) {
          if(_roleId != workers[i]['id'])
            continue;
          int cost = workers[i]['cost'];
          totalCost += cost * times;
        }
      }
    }
    print("calculateTotalCostWithJson$totalCost");

    return totalCost;
  }


  DateTime getPrevYearMonth(DateTime nowDate, int costDay) {
    DateTime prevDate = DateTime(nowDate.year, nowDate.month-1, costDay+1);
    return prevDate;
  }

  Future<Map<String, dynamic>> getScheduleBasedOnCostDay() async {
    List<dynamic> prevMonthData = [];
    List<dynamic> curMonthData = [];

    try {
      prevMonthData = await getMonthData(_prevDate!);
      log("prevMonth $prevMonthData");
      curMonthData = await getMonthData(_curDate!);
      log("curmonth");
      for (var item in curMonthData) {
        log('${item['day']}');
      }
      if (prevMonthData.isNotEmpty && curMonthData.isNotEmpty) {
        prevMonthData.addAll(curMonthData);
      } else if (prevMonthData.isNotEmpty) {
        prevMonthData = prevMonthData;
      } else if (curMonthData.isNotEmpty) {
        prevMonthData = curMonthData;
      }

      // for (var item in prevMonthData) {
      //   log('${item['day']}');
      // }
      // log("getScheduleBasedOnCostDay $prevMonthData");

      return {'date': prevMonthData, 'time_stamp': _recentTimeStamp};
    }catch(e){
      log("getScheduleBasedOnCostDay $e");
      rethrow;
    }
  }

  Future<List<dynamic>> getMonthData(DateTime date) async{
    try {
      dynamic decodedData = await getFileData(date);
      setRecentTimeStamp(decodedData);
      decodedData = filterData(decodedData, date);
      return decodedData;
    }catch(e){
      log("getMonthData $e");
    }
    return [];
  }

  Future<dynamic> getFileData(DateTime date) async {
    LocalDataSource localDataSource = LocalDataSource();
    try {

      final decodedData = await localDataSource.loadJson("schedules/${DateFormat('yyyyMM').format(date)}");
      if(decodedData["message"] != null){
        throw("no data");
      }
      return decodedData;
    } catch (e) {
      log('getFileData : Error loading cells from JSON: $e');
      rethrow;
    }
  }

  void setRecentTimeStamp(decodedData) {
    if(_recentTimeStamp == null) {
      _recentTimeStamp = decodedData['time_stamp'];
    } else {
      if(convertTimeStampToDateTime(_recentTimeStamp).isBefore
        (convertTimeStampToDateTime(decodedData['time_stamp']))){
        _recentTimeStamp = decodedData['time_stamp'];
      }
    }
  }


  DateTime convertTimeStampToDateTime(String? timeStamp){
    String year = timeStamp!.substring(0,4);
    String month = timeStamp.substring(5,7);
    String day = timeStamp.substring(8,10);
    String hour = timeStamp.substring(11,13);
    String minute = timeStamp.substring(14,16);
    String second = timeStamp.substring(17,19);
    DateTime recentTimeStamp = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
        int.parse(hour),
        int.parse(minute),
        int.parse(second));
    return recentTimeStamp;
  }

  List filterData(decodedData, DateTime date) {
    log("$date, $_curDate");
    log("${date.isAtSameMomentAs(_curDate!)}");
    List<Map<String, dynamic>> filteredData = deleteDateBodyAndNull(decodedData);

    if(date.isAtSameMomentAs(_curDate!)){
      for (var o in filteredData) {
        log("removeOverCostDay ${o['day']}");

      }
      filteredData = removeOverCostDay(filteredData);
    }else{
      for (var o in filteredData) {
        log("removeUnderCostDay ${o['day']}");

      }
      filteredData = removeUnderCostDay(filteredData);

    }

    return filteredData;
  }

  List<Map<String, dynamic>> deleteDateBodyAndNull(decodedData) {
    return (decodedData['date'] as List<dynamic>?)
        ?.where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList() ?? [];
  }

  List<Map<String, dynamic>> removeUnderCostDay(List<Map<String, dynamic>> dateList) {


    return dateList.where((item) => int.parse(item['day'].split('-')[2]) > _costDay!).toList();
  }

  List<Map<String, dynamic>> removeOverCostDay(List<Map<String, dynamic>> dateList) {

    // for (var item in dateList) {
    //   print('removeOverCostDay ${item['day']}');
    // }
    // print(_costDay);
    return dateList.where((item) => int.parse(item['day'].split('-')[2]) <= _costDay!).toList();
  }


  String convertTimeStampToYearMonth(String date){
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    return year + month;
  }
}