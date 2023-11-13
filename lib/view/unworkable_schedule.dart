import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view_model/unworkable_schedule_view_model.dart';

import '../util/app_color.dart';


class UnworkableScheduleScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _UnworkableScheduleState();
}

class _UnworkableScheduleState extends State<UnworkableScheduleScreen> {

  @override
  Widget build(BuildContext context) {

    AppColor color = AppColor();

    return Consumer<UnworkableScheduleViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  // AppBar의 높이 지정
                  child: AppBar(
                    title: Text("근무가 불가능한 시간을 선택"),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.check_box),
                          onPressed: () {
                            viewModel.saveData().then((value) {
                              if (!viewModel.result){
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),),
                                    contentPadding: const EdgeInsets.all(25.0),
                                    content: Text('서버에 저장하는 것에 실패했습니다. 잠시 후 다시 시도해주세요.'),
                                    actions: [
                                      TextButton(onPressed: () {
                                        Navigator.of(context).pop();
                                      }, child: const Text('확인'))
                                    ],
                                  );
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            });
                          }
                      ),
                    ],
                  )
              ),
              body: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                    children: [
                      Text('1. 먼저 날짜를 선택해주세요.\n2. 그 다음 근무가 불가능한 시간을 선택해주세요.'),
                      SizedBox(height: 15, width: 1,),
                      Row(
                          children: viewModel.unscheduledDate!.dates
                              .map((dates) =>
                              unscheduledDate(context, viewModel, dates))
                              .toList()
                      ),
                      Flexible(
                        child: Container(
                          child: viewModel.isLoading ?
                              Center(child: CircularProgressIndicator(color: color.mainColor,),) :
                          LayoutGrid(
                            columnSizes: viewModel.columnSizes,
                            rowSizes: List.filled(1, (1.fr)),
                            children: List.generate(7, (row) {
                              return Column(
                                children: List.generate(viewModel.openingHours, (col) {
                                  // final cell = viewModel.getCell(row, col);
                                  final cell = viewModel.grid[row][col];
                                  return GestureDetector(
                                    onTap: () {
                                      viewModel.toggleCell(cell);
                                      log('시간 탭, cell = ${cell.isSelected}');
                                    },
                                    /*onPanStart: (_) {
                                      viewModel.toggleCell(cell);
                                      log('터치 시작');
                                    },*/
                                    onVerticalDragStart: (details) {
                                      int selectedRow = viewModel.selectedColumnIndex;
                                      viewModel.dragState = !viewModel.grid[selectedRow][col].isSelected;
                                    },
                                    onVerticalDragUpdate: (details) {

                                      var position = details.localPosition;
                                      var cellSize = 45; // 셀 높이

                                      int selectedRow = viewModel.selectedColumnIndex;
                                      int selectedColumnIdx = (position.dy / cellSize).floor() + col;
                                      if (selectedColumnIdx >= viewModel.grid[selectedRow].length) {
                                        selectedColumnIdx = viewModel.grid[selectedRow].length - 1;
                                      }
                                      if (selectedColumnIdx < 0) {
                                        selectedColumnIdx = 0;
                                      }

                                      viewModel.dragCells(viewModel.grid[selectedRow][col],
                                          viewModel.grid[selectedRow][selectedColumnIdx]);
                                    },
                                    /*onPanUpdate: (details) {
                                      if (viewModel.selectedColumnIndex != -1) {
                                        RenderBox box = context.findRenderObject() as RenderBox;
                                        var localPosition = box.globalToLocal(details.globalPosition);
                                        var cellSize = 45; // 셀 크기 계산

                                        log("${localPosition.dx} 움직임");

                                        int selectedColumn = (localPosition.dx / cellSize).floor();
                                        int selected = viewModel.selectedColumnIndex;

                                        final startCell = viewModel.grid[selected][col];
                                        final endCell = viewModel.grid[selected][selectedColumn];

                                        viewModel.updateDragSelection(
                                            startCell, endCell);
                                      }
                                      log('터치 후 움직임');
                                    },*/
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: cell.isSelectedColumn ? 200 : 50,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: cell.isSelected ? AppColor().redColor : AppColor().lightGreyColor,
                                      ),
                                      child: Center(
                                          child: cell.isSelectedColumn
                                              ? Text('${col + viewModel.opening}:00')
                                              : col == 0 || col == 6 || col == 12
                                              ? Text('${col + viewModel.opening}h')
                                              : Text('')
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                      ),
                    ]
                ),
              )

          );
        }
    );

  }
  Widget unscheduledDate(BuildContext context, UnworkableScheduleViewModel viewModel, dates) {
    int dateIndex = viewModel.unscheduledDate!.dates.indexOf(dates);
    return  Expanded(
        flex: dateIndex == viewModel.selectedColumnIndex ? 4 : 1,
        child: GestureDetector(
          onTap: () {
            viewModel.updateSelectedColumn(dates);
          },
          child: AnimatedContainer(
              decoration: BoxDecoration(
                color: dateIndex == viewModel.selectedColumnIndex ? AppColor().mainColor : Colors.white,
                shape: BoxShape.circle,
              ),
              duration: Duration(milliseconds: 500),
              child:
              Center(
                  child : Text(
                      '${dates.day}\n '
                          '${viewModel.unscheduledDate!.koreanWeekday(dateIndex)}'
                  )
              )
          ),
        )
    );
  }
}
