import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/data/model/appColor.dart';
import 'package:sidam_employee/view_model/impossible_schedule_view_model.dart';


class SelectScheduleScreen extends StatelessWidget {
  const SelectScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), // AppBar의 높이 지정
          child: Consumer<SelectScheduleViewModel>(
            builder: (context, viewModel, _) {
              return AppBar(
                title: Text("Impossible Schedule"),
                actions: [
                    IconButton(
                      icon: Icon(Icons.check_box),
                      onPressed: () {
                        viewModel.saveData();
                        Navigator.pop(context);
                      }
                    ),
                ],
              );
            },
          ),
        ),
        body : Consumer<SelectScheduleViewModel>(
          builder: (context, viewModel, _) {
            return Container(
              padding: const EdgeInsets.all(10),
                child: Column(
                    children: [
                      Row(
                          children: viewModel.upcomingWeek!.dates
                              .map((dates) => Expanded(
                              flex: viewModel.upcomingWeek!.dates.indexOf(dates) == viewModel.selectedColumnIndex ? 4 : 1,
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.updateSelectedColumn(dates);
                                },

                                child:
                                AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color:viewModel.upcomingWeek!.dates.indexOf(dates) == viewModel.selectedColumnIndex ? AppColor().mainColor : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    duration: Duration(milliseconds: 500),
                                    child:
                                    Center(
                                        child : Text(
                                            '${dates.day}\n '
                                                '${viewModel.upcomingWeek!.days[viewModel.upcomingWeek!.dates.indexOf(dates)]}'
                                        )
                                    )
                                ),
                              )
                          )).toList()
                      ),
                      Flexible(
                        child: Container(
                          child: LayoutGrid(
                            columnSizes: viewModel.columnSizes,
                            rowSizes: List.filled(1, (1.fr)),
                            children: List.generate(7, (row) {
                              return Column(
                                children: List.generate(viewModel.openingHours!, (col) {
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
                                      if(viewModel.selectedColumnIndex != -1) {
                                        RenderBox box = context.findRenderObject() as RenderBox;
                                        var localPosition = box.globalToLocal(details.globalPosition);
                                        var cellSize = 45; // 셀 크기 계산

                                        int selectedColumn = (localPosition.dx / cellSize).floor();
                                        int selected = viewModel.selectedColumnIndex;

                                        final startCell = viewModel.grid[selected][col];
                                        final endCell = viewModel.grid[selected][selectedColumn];

                                        viewModel.updateDragSelection(startCell, endCell);
                                      }
                                    },
                                    child:  Container(
                                      padding: const EdgeInsets.all(5),
                                      width: cell.isSelectedColumn ? 200 : 50,
                                      height : 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: cell.isSelected ? AppColor().redColor : AppColor().lightGreyColor,
                                      ),
                                      child: Center(
                                          child: cell.isSelectedColumn ? Text('${col+viewModel.opening}:00') :Text('$row-$col')
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
            );
          },
        )
    );
  }
}
