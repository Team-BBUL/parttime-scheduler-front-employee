import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import '../data/repository/unworkable_schedule_repository.dart';
import '../model/cell.dart';
import '../model/unworkable_schedule.dart';
import '../model/unscheduled_date.dart';


class UnworkableScheduleViewModel extends ChangeNotifier {
  late final ImpossibleScheduleRepository _impossibleScheduleRepository;
  UnscheduledDate? unscheduledDate;
  List<List<Cell>> grid = [];
  List<TrackSize> columnSizes = [];
  UnWorkableSchedule? unWorkableSchedule;
  int selectedColumnIndex = -1;
  int opening = 10;
  int closed = 23;
  int? openingHours;
  bool dragType = false;
  bool isOpeningHourChanged = false;
  bool isStartDayChanged = false;
  bool isDaysBeforeEndChanged = false;
  int scheduleStartDay = DateTime.saturday;
  int daysBeforeLimited = 10;

  UnworkableScheduleViewModel(this._impossibleScheduleRepository){
    loadData();
  }

  void loadData() async {
    unscheduledDate = UnscheduledDate.getRecentWeekOnUnscheduled(scheduleStartDay, daysBeforeLimited);
    openingHours = closed - opening ;
    grid = List.generate(7, (row) {
      return List.generate(openingHours!, (col) {
        return Cell(row, col);
      });
    });
    columnSizes = List<TrackSize>.filled(7,1.fr);
    unWorkableSchedule = await _impossibleScheduleRepository.loadJson();
    log(unWorkableSchedule!.toJson().toString());
    validateData();
    convertTimeToGrid();
    notifyListeners();
  }

  saveData(){
    convertGridToTime();
    _impossibleScheduleRepository.saveJson(unWorkableSchedule!);
  }

  void toggleCell(Cell cell) {
    if(cell.isSelectedColumn) {
      cell.isSelected = !cell.isSelected;
      dragType = cell.isSelected;
    }else{
      clearCell();
    }
    notifyListeners();
  }

  void toggleGrid(int row, int col) {
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

    // 1. 기존에 선택된 열이 없고, 새로운 열을 선택했을 때
    //     => 새로운 열의 크기를 늘린다.
    // 2. 기존에 선택된 열이 있고, 새로운 열을 선택했을 때
    //     => 기존에 선택된 열을 새로운 열로 바꾼다.
    // 3. 기존에 선택된 열이 있고, 기존에 선택된 열을 다시 선택했을 때
    //     => 기존에 선택된 열을 취소한다.

  updateSelectedColumn(DateTime date){

    if(selectedColumnIndex == -1){
      selectedColumnIndex = unscheduledDate!.dates.indexOf(date);
      expandSelectedColumnSize();
    }else if(selectedColumnIndex != unscheduledDate!.dates.indexOf(date)) {
      clearCell();
      selectedColumnIndex = unscheduledDate!.dates.indexOf(date);
      expandSelectedColumnSize();
    }else if(selectedColumnIndex == unscheduledDate!.dates.indexOf(date)){
      clearCell();
      selectedColumnIndex = -1;
    }
    notifyListeners();
  }

  expandSelectedColumnSize(){
    for (int j = 0; j < openingHours!; j++) {
      getCell(selectedColumnIndex, j).isSelectedColumn = true;
    }
    for (int i = 0; i < 7; i++) {
      if (i == selectedColumnIndex) {
        columnSizes[i] = 4.0.fr;
      }
    }
  }

  clearCell(){
    for (var cell in grid.expand((element) => element)) {
      cell.isSelectedColumn = false;
    }
    columnSizes = columnSizes.map((e) => 1.0.fr).toList();
    selectedColumnIndex = -1;

  }

  convertGridToTime(){
    List<Unworkable> unWorkable = [];
    int dayIndex = 0;
    for (var o in grid) {
      String yearMonthDay = "${unscheduledDate!.dates[dayIndex].year}-${unscheduledDate!.dates[dayIndex].month}-${unscheduledDate!.dates[dayIndex].day}";
      unWorkable.add(Unworkable(date: yearMonthDay, time: o.map((element) => element.isSelected).toList()));
      dayIndex++;
    }
    unWorkableSchedule = UnWorkableSchedule(unWorkable : unWorkable);
  }

  convertTimeToGrid() {
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

  void validateData() {
    String data ="";
    List<int> date = [];
    for(int i = 0; i < unWorkableSchedule!.unWorkable![0].date!.length; i++){
      if(unWorkableSchedule!.unWorkable![0].date![i] == "-" || i == unWorkableSchedule!.unWorkable![0].date!.length-1){
        date.add(int.parse(data));
        continue;
      }
      data += unWorkableSchedule!.unWorkable![0].date![i];
    }
    DateTime jsonDateTime = DateTime(date[0], date[1], date[2]);
    int result = unscheduledDate!.dates[0].compareTo(jsonDateTime);

    if(result < 0){

    }else{

    }
  }
}