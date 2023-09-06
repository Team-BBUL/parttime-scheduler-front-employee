import 'package:flutter/material.dart';
import 'package:sidam_worker/data/repository/schedule_repository.dart';

import '../model/cost.dart';
import '../model/schedule.dart';
//TODO json 추가 트리거 고안
//TODO json 파일 생성 : 백엔드 데이터 기반
//TODO json 파일 수정 : json deserialize -> add -> serialize
class CostViewModel extends ChangeNotifier{
  final ScheduleRepository _scheduleRepository = ScheduleRepository();
  late MonthSchedule monthSchedule;
  bool isExpanded = false;
  late List<String> dateList = [];
  String user = '성춘향';
  DateTime now = DateTime.now();
  List<Cost> monthCost = [];
  //TODO : 값 로딩 중 로딩 화면 표시
  // late String selectedDate = dateList[dateList.length -1];
  late String selectedDate = "${now.year}년 0${now.month}월";
  late int dateIndex = dateList.length -1;
  int costDay = 8;
  late int totalPay = 0;
  late int totalWorkTime = 0;
  late int pay = 0;
  bool isLastDayOfMonth = false;
  bool isCostByMonth = true;
  CostViewModel(){
    loadData();
  }

  Future<void> loadData() async {
    dateList = await _scheduleRepository.getDateList();
    dateList.add("${now.year}년 0${now.month}월");
    selectedDate = dateList[dateList.length -1];
    dateIndex = dateList.length -1;
    getCost(selectedDate);
    notifyListeners();
  }

  getCost(String selectedDate) async{
    String yearMonth = _scheduleRepository.convertCostScreenDateToYearMonth(selectedDate);

    if(isLastDayOfMonth){
      monthSchedule = await _scheduleRepository.getMonthSchedule(yearMonth);
    }else{
      monthSchedule = await _scheduleRepository.getPrevMonthAndCurMonthScheduleByDay(yearMonth, costDay);
    }

    calculateCost();
    notifyListeners();
  }

  bool isSameCurrentMonthAndPreviousMonth(String date, int costDay) {
    DateTime currentDate = DateTime(int.parse(date.substring(0,4)), int.parse(date.substring(4,6)), costDay);
    DateTime prevDate = DateTime(currentDate.year, currentDate.month-1, costDay+1);
    return isSameMonth(currentDate, prevDate);
  }

  bool isSameMonth(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month;
  }


  setDate(int selectedItem){
    selectedDate = dateList[selectedItem];
    dateIndex = selectedItem;
    notifyListeners();
  }

  //TODO 야간 근무 계산 로직 추가
  calculateCost(){
    monthCost = [];
    int cost = 0;
    bool isUserSchedule = false;
    int dayHour = 0;
    int nightHour = 0;
    totalPay = 0;
    totalWorkTime = 0;
    pay = 0;
    for (Date date in monthSchedule.date!) {
      dayHour = 0;
      nightHour = 0;
      for (var schedule in date.schedule!) {
        for (var worker in schedule.workers!) {
          if(user ==  worker.alias){
            isUserSchedule = true;
            cost = worker.cost!;
            break;
          }
        }
        if(isUserSchedule){
          for (var workTime in schedule.time!) {
            if(workTime == true){
              dayHour++;
            }
          }
        }
        isUserSchedule = false;
      }
      totalWorkTime += dayHour + nightHour;
      monthCost.add(Cost(date.day!, dayHour, nightHour, cost));
    }
    totalPay = totalWorkTime * cost;
    pay = cost;
  }

  toggleClicked(){
    isExpanded = !isExpanded;
    notifyListeners();
  }
}
