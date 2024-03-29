import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sidam_employee/util/sp_helper.dart';
import '../data/repository/unworkable_schedule_repository.dart';
import '../model/cell.dart';
import '../model/unworkable_schedule.dart';
import '../model/unscheduled_date.dart';


class UnworkableScheduleViewModel extends ChangeNotifier {

  late final SPHelper _helper;
  GlobalKey gridKey = new GlobalKey();
  late final ImpossibleScheduleRepository _impossibleScheduleRepository;
  UnscheduledDate? unscheduledDate = UnscheduledDate();
  UnWorkableSchedule? unWorkableSchedule = UnWorkableSchedule();

  List<List<Cell>> grid = [];
  List<TrackSize> _columnSizes = [];

  late int selectedColumnIndex;
  int opening = 10;
  int closed = 23;
  int openingHours = 0;
  bool dragType = false;
  bool isOpeningHourChanged = false;
  bool isStartDayChanged = false;
  bool isDaysBeforeEndChanged = false;
  int scheduleStartDay = DateTime.saturday;
  int daysBeforeLimited = 10;
  bool isLoading = false; // json 데이터를 읽어오는 중인지 확인하는 변수
  bool first = false; // 처음 데이터를 입력하는 것인지 확인하는 변수
  bool result = false; // 서버 전송 실패/성공 여부

  bool dragState = false; // drag가 선택인건지 취소인건지 저장

  get columnSizes => _columnSizes;
  UnworkableScheduleViewModel(this._impossibleScheduleRepository){

    _helper = SPHelper();
    loadData();
  }


  void loadData() async {
    if (!isLoading){
      isLoading = true;
      await _helper.init();

      selectedColumnIndex = -1;
      unscheduledDate = UnscheduledDate.getRecentWeekOnUnscheduled(
          scheduleStartDay, daysBeforeLimited);
      openingHours = closed - opening;

      grid = List.generate(7, (row) {
        return List.generate(openingHours, (col) {
          return Cell(row, col);
        });
      });

      _columnSizes = List<TrackSize>.filled(7, 1.fr);

      unWorkableSchedule = await _impossibleScheduleRepository.loadJson();
      if (unWorkableSchedule == null || unWorkableSchedule!.unWorkable == null) {
        first = true;
      }
      log(unWorkableSchedule!.toJson().toString());

      //validateData();
      convertTimeToGrid();

      Future.delayed(const Duration(milliseconds: 100), () {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  Future saveData() async {
    convertGridToTime();
    _impossibleScheduleRepository.saveJson(unWorkableSchedule!);

    if (unWorkableSchedule == null || unWorkableSchedule!.unWorkable == null) {
      result = true;
      return ;
    }

    // server에 전송
    if (first) { // 첫 전송이면 작성
      result = await _impossibleScheduleRepository.postData(unWorkableSchedule!);
    } else { // 첫 전송 아니면 수정
      result = await _impossibleScheduleRepository.updateData(unWorkableSchedule!);
    }
  }

  void toggleCell(Cell cell) async {
    if(cell.isSelectedColumn) {
      cell.isSelected = !cell.isSelected;
      dragType = cell.isSelected;
    }else{
      clearCell();
    }
    notifyListeners();
  }

  void toggleGrid(int row, int col) async {
    if(grid[row][col].isSelectedColumn) {
      grid[row][col].isSelected = !grid[row][col].isSelected;
      dragType = grid[row][col].isSelected;
    }else{
      clearCell();
    }
    notifyListeners();
  }

  Cell getCell(int row, int col) {
    return grid[row][col];
  }

  void updateDragSelection(Cell startCell, Cell endCell) {
    int startRow = startCell.row;
    int endRow = endCell.row;
    if (startRow > endRow) {
      final temp = startRow;
      startRow = endRow;
      endRow = temp;
    }

    int startColumn = startCell.col;
    int endColumn = endCell.col;
    if (startColumn > endColumn) {
      final temp = startColumn;
      startColumn = endColumn;
      endColumn = temp;
    }

    for (int column = startColumn; column <= endColumn; column++) {
      final cell = grid[selectedColumnIndex][column];
      cell.isSelected = dragType;
    }

    notifyListeners();
  }

  void dragCell(Cell selectedCell) {
    for (var cell in grid[selectedCell.row]) {
      if (cell.row == selectedCell.row) {
        cell.isSelected = !cell.isSelected;
      }
    }
    notifyListeners();
  }

  void dragCells(Cell startCell, Cell selected) async {
    if(selected.isSelectedColumn) {
      selected.isSelected = dragState;
      dragType = selected.isSelected;
    }else{
      clearCell();
    }
    notifyListeners();
  }


  updateSelectedColumn(DateTime date) async {
    if(selectedColumnIndex == -1 || selectedColumnIndex != unscheduledDate!.dates.indexOf(date)) {
      await clearCell();
      selectedColumnIndex = unscheduledDate!.dates.indexOf(date);
      await expandSelectedColumnSize();
    }else if(selectedColumnIndex == unscheduledDate!.dates.indexOf(date)){
      await clearCell();
      selectedColumnIndex = -1;
    }
    notifyListeners();
  }

  Future<void> expandSelectedColumnSize() async {
    for (int j = 0; j < openingHours; j++) {
      getCell(selectedColumnIndex, j).isSelectedColumn = true;
    }
    _columnSizes[selectedColumnIndex] = 4.0.fr;
  }

  Future<void> clearCell() async {
    for (var cell in grid.expand((element) => element)) {
      cell.isSelectedColumn = false;
    }
    _columnSizes = _columnSizes.map((e) => 1.0.fr).toList();
    selectedColumnIndex = -1;
  }

  convertGridToTime(){
    List<Unworkable> unWorkable = [];
    int dayIndex = 0;
    for (var o in grid) {
      unWorkable.add(Unworkable(date: unscheduledDate!.dates[dayIndex], time: o.map((element) => element.isSelected).toList()));
      dayIndex++;
    }
    unWorkableSchedule = UnWorkableSchedule(unWorkable : unWorkable);
  }

  convertTimeToGrid() {

    if (unWorkableSchedule == null || unWorkableSchedule!.unWorkable == null) {
      return ;
    }

    int dayIndex = 0;
    for (var o in unWorkableSchedule!.unWorkable!) {
      int timeIndex = 0;
      for (var cell in o.time!) {
        if (cell) {
          getCell(dayIndex, timeIndex).isSelected = true;
        }
        timeIndex++;
      }
      dayIndex++;
    }
    notifyListeners();
  }

  void validateData(int idx) {

    DateTime date = unWorkableSchedule!.unWorkable![idx].date;
    int result = unscheduledDate!.dates[0].compareTo(date);

    if(result < 0){

    } else {

    }
  }
}