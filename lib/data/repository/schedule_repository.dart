import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import '../../model/schedule.dart';


class ScheduleRepository{

  String yearMonth = '';
  String prevYearMonth = '';
  int costDay = 0;

  Future<MonthSchedule> getPrevMonthAndCurMonthScheduleByDay(String date, int costDay) async{
    initData(date, costDay);
    Map<String,dynamic> data = await loadJsonWithPrevAndCurMonth();
    return MonthSchedule.fromJson(data);
  }

  initData(String date, int day){
    yearMonth = date;
    costDay = day;
    prevYearMonth = getPrevYearMonth(date, day);
  }

  String getPrevYearMonth(String yearMonth, int costDay) {
    DateTime currentDate = DateTime(int.parse(yearMonth.substring(0,4)), int.parse(yearMonth.substring(4,6)), costDay);
    DateTime prevDate = DateTime(currentDate.year, currentDate.month-1, costDay+1);
    if( 9 < currentDate.month - 1 ) {
      return '${prevDate.year}${prevDate.month}';
    } else {
      return '${prevDate.year}${prevDate.month.toString().padLeft(2, '0')}';
    }
  }

  Future<MonthSchedule> getMonthSchedule(String yearMonth) async {
    try {
      String jsonData = await rootBundle.loadString('asset/json/$yearMonth.json');
      final decodedData = json.decode(jsonData);
      return MonthSchedule.fromJson(decodedData);
    } catch (e) {
      print('Error loading cells from JSON: $e');
    }
    return MonthSchedule();
  }

  Future<Map<String, dynamic>> loadJsonWithPrevAndCurMonth() async {
    List<dynamic> prevMonthData = [];
    List<dynamic> monthData = [];

    prevMonthData = await loadJson(prevYearMonth);
    monthData = await loadJson(yearMonth);

    if(prevMonthData.isNotEmpty && monthData.isNotEmpty) {
      prevMonthData.addAll(monthData);
    } else if( prevMonthData.isNotEmpty) {
      prevMonthData = prevMonthData;
    } else if( monthData.isNotEmpty) {
      prevMonthData = monthData;
    }
    return {'date':prevMonthData};
  }

  Future<List<dynamic>> loadJson(String date) async {
    List<dynamic> data = [];
    try {
      String jsonData = await rootBundle.loadString('asset/json/$date.json');
      final decodedData = json.decode(jsonData);
      data = filterDate(decodedData, date);
    } catch (e) {
      print('Error loading cells from JSON: $e');
    }
    return data;
  }

  List filterDate(decodedData, String date) {
    List<dynamic> filteredData = [];

    List<Map<String, dynamic>> dateList = (decodedData['date'] as List<dynamic>?)
        ?.where((item) => item != null)
        .cast<Map<String, dynamic>>()
        .toList() ?? [];

    if(int.parse(date) < int.parse(yearMonth)){
      List<dynamic> filteredDays = dateList
          .where((item) => int.parse(item['day'].substring(8,10)) > costDay)
          .toList();

      filteredData = filteredDays;
    }else{
      List<dynamic> filteredDays = dateList
          .where((item) => int.parse(item['day'].substring(8,10)) <= costDay)
          .toList();

      filteredData = filteredDays;
    }
    return filteredData;
  }



  Future<List<String>> getDateList() async {
    List<String> fileNames = await getFileNames();
    List<String> dateList = fileToDate(fileNames);
    return dateList;
  }

  List<String> fileToDate(List<String> fileList) {
    List<String> dateList = [];
    for (String input in fileList) {
      String yearMonth = input.substring(11, 17);
      int year = int.parse(yearMonth.substring(0, 4));
      int month = int.parse(yearMonth.substring(4, 6));
      String parsedString = '$year년 ${month.toString().padLeft(2, '0')}월';
      dateList.add(parsedString);
    }
    return dateList;
  }

  Future<List<String>> getFileNames() async {
    String directory = 'asset/json/';

    List<String> assetList = await rootBundle.loadString('AssetManifest.json')
        .then((jsonStr) => json.decode(jsonStr) as Map<String, dynamic>)
        .then((map) => map.keys.toList());

    List<String> jsonFiles = assetList
        .where((file) => file.startsWith(directory) && file.endsWith('.json'))
        .toList();

    return jsonFiles;
  }

  String convertCostScreenDateToYearMonth(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(6, 8);
    return year + month;
  }
}