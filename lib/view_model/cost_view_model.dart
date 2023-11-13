import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidam_employee/data/repository/schedule_repository.dart';
import 'package:sidam_employee/util/sp_helper.dart';

import '../data/repository/incentive_repository.dart';
import '../data/repository/schedule_local_repository.dart';
import '../model/Incentive.dart';
import '../model/employee_cost.dart';
import '../model/schedule.dart';

class CostViewModel extends ChangeNotifier{
  final ScheduleLocalRepository _scheduleLocalRepository = ScheduleLocalRepository();
  final ScheduleRepository _scheduleRemoteRepository;
  final IncentiveRepository _incentiveRepository;

  MonthSchedule? monthSchedule;
  MonthSchedule? thisWeekSchedule;
  List<MonthIncentive>? monthIncentives;

  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  NumberFormat moneyFormat = NumberFormat('###,###,###,###');

  bool isExpanded = false;
  List<EmployeeCost>? employeesCost;
  String? selectedDate;
  int? dateIndex;
  int costDay = 1;
  int totalWorkTime = 0;
  int totalPay = 0;
  int? ownerId;
  int prevMonthTotalPay = 0;
  bool customTileExpanded = false;
  get pickerYear => _pickerYear;
  get selectedMonth => _selectedMonth;

  CostViewModel(this._scheduleRemoteRepository, this._incentiveRepository){
    loadData();
  }

  Future<void> loadData() async {
    SPHelper helper = SPHelper();
    ownerId = helper.getRoleId();
    // String yearMonth = DateFormat('yyyyMM').format(_selectedMonth);
    employeesCost = [];
    monthSchedule = null;
    try {
      log("----------------------------------------loadData-----------------------");
      // await loadDateList();
      // await fetchRemoteSchedule();
      await fetchLocalSchedule(_selectedMonth);

      // await loadDateList();
      await getMonthIncentive();
      await getCost();
      await sortEmployeeCostToDate();
      await calculateTotalCost();
    }catch(e){
      log("loadData $e");
    }
    notifyListeners();
  }

  getCost() async {
    log("getCost processing");
    await calculateCost();
    // await calculateTotalCost();
    prevMonthTotalPay = await _scheduleLocalRepository.getPrevMonthCost(
        selectedMonth, costDay);
    notifyListeners();
  }

  getMonthIncentive() async{
    try {
      monthIncentives = await _incentiveRepository.fetchOnesMonthIncentive(_selectedMonth);
      log("getMonthIncentive success");
    }catch(e){
      monthIncentives = [];
      log("getMonthIncentive error : $e");
    }
  }

  Future<String> fetchLocalSchedule(DateTime dateTime) async {

    monthSchedule = null;
    if(costDay > 28){
      monthSchedule = await _scheduleLocalRepository.fetchSchedule(dateTime);
    }else{
      monthSchedule = await _scheduleLocalRepository.fetchScheduleByPaycheck(dateTime, costDay);
    }
    return monthSchedule?.timeStamp ?? '';
  }


  void mergeData() {
    if(monthSchedule?.date != null && thisWeekSchedule?.date != null){
      monthSchedule?.date!.addAll(thisWeekSchedule!.date!);
    }else {
      monthSchedule?.date ??= thisWeekSchedule?.date;
    }
  }

  calculateCost(){
    log("calculateCost processing");
    totalPay = 0;
    employeesCost = [];
    int bonusDayPay;
    int holidayPay;
    int monthIncentivePay;
    int workTime;
    bool isAdditionalPayOccurred;
    // log("${monthSchedule!.toJson()   }");

    for (Date date in monthSchedule!.date!) {
      log("monthSchedule processing");
      holidayPay = 0;
      bonusDayPay = 0;
      monthIncentivePay = 0;
      workTime = 0;
      isAdditionalPayOccurred = false;
      for (Schedule schedule in date.schedule!) {
        log("Schedule processing");

        workTime = calculateWorkTime(schedule);

        for (Workers worker in schedule.workers!) {

          if(monthIncentives!.isNotEmpty) {
            monthIncentivePay = calculateMonthIncentivePay(worker);
          }

          if(worker.id == ownerId) {
            DateTime realDate = convertStringToDate(date);
            if(bonusDayPay != 0 && holidayPay != 0 && monthIncentivePay != 0)
              isAdditionalPayOccurred = true;
            employeesCost!.add(EmployeeCost(realDate, workTime, 0, worker.cost!, 0, 0, isAdditionalPayOccurred));
          }
        }
      }
    }
    notifyListeners();
  }

  int calculateMonthIncentivePay(Workers worker) {
    int monthIncentivePay = 0;
    for (MonthIncentive monthIncentive in monthIncentives!) {
      if(monthIncentive.id == worker.id){
        for (Incentive item in monthIncentive.incentives!) {
          monthIncentivePay += item.cost!;
          log('monthincentive $monthIncentivePay');
        }
      }
    }
    return monthIncentivePay;
  }

  DateTime convertStringToDate(Date date) {
    List<String> s_date = date.day!.split('-');
    return  DateTime(int.parse(s_date[0]),int.parse(s_date[1]),int.parse(s_date[2]));
  }

  //TODO calculateTotalCost 코드 중복 => CostViewModel
  calculateTotalCost() {
    if(employeesCost != null) {
      for (EmployeeCost employeeCost in employeesCost!) {
        totalPay = totalPay + employeeCost.workingHour * employeeCost.hourlyPay +
            employeeCost.holidayPay * (employeeCost.hourlyPay * 1.5).round() +
            employeeCost.bonusDayPay * employeeCost.hourlyPay * 2 +
            employeeCost.incentive;
      }
    }
  }

  calculateWorkTime(Schedule schedule) {
    int workHour = 0;
    log('workTime processing... schedule time is null? : ${schedule.time != null}');
    for (var workTime in schedule.time!) {

      if(workTime == true){
        workHour++;
      }
    }
    return workHour;
  }

  sortEmployeeCostToDate() {
    if(employeesCost != null) {
      employeesCost!.sort((a, b) => a.date.compareTo(b.date));
    }
  }

  getEmployeeCost(int index){
    return employeesCost![index];
  }

  void setCustomTileExpanded(bool value) {
    customTileExpanded = value;
    notifyListeners();
  }

  void changeMonth(DateTime dateTime) {
    _selectedMonth = dateTime;
    log("changeMonth $dateTime");
    loadData();
    notifyListeners();
  }

  void setPickerYear(param0) {
    _pickerYear = param0;
    _selectedMonth = DateTime(_pickerYear, _selectedMonth.month, 1);
    loadData();
    log("serPickerYear $_selectedMonth");

    notifyListeners();
  }

  void toggleClicked() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

}
