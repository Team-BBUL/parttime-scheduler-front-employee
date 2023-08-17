import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view_model/unworkable_schedule_view_model.dart';

import '../util/appColor.dart';


class UnworkableScheduleScreen extends StatelessWidget {
  const UnworkableScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UnworkableScheduleViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  // AppBar의 높이 지정
                  child: AppBar(
                    title: Text("Unworkable Schedule"),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.check_box),
                          onPressed: () {
                            viewModel.saveData();
                            Navigator.pop(context);
                          }
                      ),
                    ],
                  )
              ),
              body: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                    children: [
                      Row(
                          children: viewModel.unscheduledDate!.dates
                              .map((dates) =>
                              unscheduledDate(context, viewModel, dates))
                              .toList()
                      ),
                      Flexible(
                        child: Container(
                          child: LayoutGrid(
                            columnSizes: viewModel.columnSizes,
                            rowSizes: List.filled(1, (1.fr)),
                            children: List.generate(7, (row) {
                              return Column(
                                children: List.generate(
                                    viewModel.openingHours!, (col) {
                                  // final cell = viewModel.getCell(row, col);
                                  final cell = viewModel.grid[row][col];
                                  return GestureDetector(
                                    onTap: () {
                                      viewModel.toggleCell(cell);
                                    },
                                    onPanStart: (_) {
                                      viewModel.toggleCell(cell);
                                    },
                                    onPanUpdate: (details) {
                                      if (viewModel.selectedColumnIndex != -1) {
                                        RenderBox box = context
                                            .findRenderObject() as RenderBox;
                                        var localPosition = box.globalToLocal(
                                            details.globalPosition);
                                        var cellSize = 45; // 셀 크기 계산

                                        int selectedColumn = (localPosition.dx /
                                            cellSize).floor();
                                        int selected = viewModel
                                            .selectedColumnIndex;

                                        final startCell = viewModel
                                            .grid[selected][col];
                                        final endCell = viewModel
                                            .grid[selected][selectedColumn];

                                        viewModel.updateDragSelection(
                                            startCell, endCell);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: cell.isSelectedColumn ? 200 : 50,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: cell.isSelected ? AppColor()
                                            .redColor : AppColor()
                                            .lightGreyColor,
                                      ),
                                      child: Center(
                                          child: cell.isSelectedColumn
                                              ? Text(
                                              '${col + viewModel.opening}:00')
                                              : col == 0 || col == 6 ||
                                              col == 12
                                              ? Text(
                                              '${col + viewModel.opening}h')
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
