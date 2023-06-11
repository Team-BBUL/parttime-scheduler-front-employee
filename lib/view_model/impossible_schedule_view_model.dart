import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sidam_employee/data/model/cell.dart';
import 'package:sidam_employee/data/model/upcoming_week.dart';

import '../data/model/impossible_schedule.dart';
import '../data/repository/impossible_schedule_repository.dart';

/*
  근무 불가능 시간 지정 시나리오
  1. 점주는 근무 불가능 시간 등록 마감일을 지정한다.
  2. 사용자는 마감일 전까지 다음 주의 근무 불가능 시간을 선택한다.
 */
// Finished 1. 근무표 날짜 변경 deadline 로직 세우기 => UpcomingWeek의 start 지정
// TODO 2. deadline 로직에 따른 UI 변경
// TODO 3. deadline 로직에 따른 DB(JSON) 변경
// TODO 4. Store의 opening, closed 시간 로직 세우기

// Cell Model 재사용을 위해 Cell Model에는 DATE이나 시간과 같은 속성을 추가하지 않았다.
// 하지만 이 ViewModel에서는 DATE이나 시간과 같은 속성을 추가해야 한다.
//
class SelectScheduleViewModel extends ChangeNotifier {
  late final ImpossibleScheduleRepository _impossibleScheduleRepository;
  UpcomingWeek? upcomingWeek;
  List<List<Cell>> grid = [];
  List<TrackSize> columnSizes = [];
  ImpossibleTime? impossibleTime;
  int selectedColumnIndex = -1;
  int opening = 10;
  int closed = 23;
  int? openingHours;
  bool dragType = false;
  int deadLine = DateTime.sunday;
  SelectScheduleViewModel(this._impossibleScheduleRepository){
    loadData();
  }

  void loadData() async {
    upcomingWeek = UpcomingWeek.deadLine(deadLine);
    openingHours = closed - opening ;
    grid = List.generate(7, (row) {
      return List.generate(openingHours!, (col) {
        return Cell(row, col);
      });
    });
    columnSizes = List<TrackSize>.filled(7,1.fr);
    await convertTimeToGrid();
    notifyListeners();
  }

  saveData(){
    convertGridToTime();
    _impossibleScheduleRepository.saveJson(impossibleTime!)
        .then((_) {
      // 저장 완료 후의 처리 로직
    })
        .catchError((error) {
      // 저장 실패 시의 처리 로직
    });
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
      selectedColumnIndex = upcomingWeek!.dates.indexOf(date);
      selectColumnIndexAndExpandColumnSize();

    }else if(selectedColumnIndex != upcomingWeek!.dates.indexOf(date)) {
      clearCell();
      selectedColumnIndex = upcomingWeek!.dates.indexOf(date);
      selectColumnIndexAndExpandColumnSize();

    }else if(selectedColumnIndex == upcomingWeek!.dates.indexOf(date)){
      clearCell();
      selectedColumnIndex = -1;
    }
    notifyListeners();
  }

  selectColumnIndexAndExpandColumnSize(){
    for (int j = 0; j < openingHours!; j++) {
      getCell(selectedColumnIndex, j).isSelectedColumn = true;
      // grid[selectedColumnIndex][j].isSelectedColumn = true;
    }
    for (int i = 0; i < 7; i++) {
      if (i == selectedColumnIndex) {
        // 선택된 열의 크기를 늘린다.
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
    List<Data> data = [];
    int dayIndex = 0;
    for (var o in grid) {
      String yearMonthDay = upcomingWeek!.dates[dayIndex].year.toString()+"-"+upcomingWeek!.dates[dayIndex].month.toString()+"-" + upcomingWeek!.dates[dayIndex].day.toString();
      data.add(Data(date: yearMonthDay, time: o.map((element) => element.isSelected).toList()));
      dayIndex++;
    }
    impossibleTime = ImpossibleTime(data: data);
  }
  convertTimeToGrid() async {
    impossibleTime = await _impossibleScheduleRepository.loadJson();
    int dayIndex = 0;
    for (var o in impossibleTime!.data!) {
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
/*
  void convertGridToTimes() {
    int dayIndex = 0;
    String yearMonthDay;
    List<Data> data = [];
    for (var o in grid) {
      yearMonthDay = upcomingWeek!.dates[dayIndex].year.toString()+upcomingWeek!.dates[dayIndex].month.toString() + upcomingWeek!.dates[dayIndex].day.toString();
      int hour = opening;
      List<Time> times = [];
      for (var cell in o) {
        if(cell.isSelected){
          print('yearMonthDay: $yearMonthDay, time: $hour');
          times.add(Time( hour : hour));
        }
        hour++;
      }
      if(times.isNotEmpty){
        data.add(Data(day: yearMonthDay, time: times));
      }
      dayIndex++;
    }
    impossibleTime = ImpossibleTime(data: data);
  }

  Future<void> convertTimeToGrid () async{
    try {
      int dataIndex = 0;
      int timeIndex;
      impossibleTime = await _impossibleScheduleRepository.loadJson();
      print('${impossibleTime!.data!.length}');
      for (int i = 0; i < upcomingWeek!.days.length; i++) {
        if (impossibleTime!.data!.length == dataIndex) {
          break;
        }
        if (impossibleTime!.data![dataIndex].day == upcomingWeek!.dates[i].year.toString()+upcomingWeek!.dates[i].month.toString() + upcomingWeek!.dates[i].day.toString()) {
          timeIndex = 0;
          for (int j = 0; j < openingHours!; j++) {
            if (impossibleTime!.data![dataIndex].time!.length == timeIndex) {
              break;
            }
            if (opening + j ==
                impossibleTime!.data![dataIndex].time![timeIndex].hour) {
                getCell(i, j).isSelected = true;
              // grid[i][j].isSelected = true;
              timeIndex++;
            }
          }
          dataIndex++;
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
*/
}