import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view_model/cost_view_model.dart';

import '../model/employee_cost.dart';
import '../util/app_color.dart';
import '../util/app_future_builder.dart';
import '../util/custom_expansion_tile.dart';
class CostScreen extends StatelessWidget {
  const CostScreen({super.key});

  List<Widget> generateRowOfMonths(from, to, CostViewModel viewModel) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(viewModel.pickerYear, i, 1);
      final selectedColor = dateTime.isAtSameMomentAs(viewModel.selectedMonth)
          ? AppColor().mainColor
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(selectedColor),
            onPressed: () {
              viewModel.changeMonth(dateTime);
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedColor,
              side: BorderSide(
                color: selectedColor,
                width: 1,
              ),
              shape: CircleBorder(),
            ),
            child: Text(
              '${DateFormat('M').format(dateTime)}월',style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths(CostViewModel viewModel) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6, viewModel),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12, viewModel),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mainContext = context;
    final viewModel = Provider.of<CostViewModel>(context,listen: false );
    return AppFutureBuilder(
        future: viewModel.loadData(),
        builder: (builder, context){
          return Scaffold(
              body: SafeArea(
                child : Consumer<CostViewModel>(
                    builder:(context, viewModel, child){
                      return Container(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            monthPicker(viewModel),
                            Expanded(
                                child:
                                 Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                          child: Row(
                                            children:  [
                                              Expanded(
                                                  child:
                                                  Text("총 지급 급여 (급여일 기준 : ${viewModel.costDay}일 )")
                                              ),
                                            ],
                                          )
                                      ),
                                      Container(
                                          child: Row(
                                            children:  [
                                              Expanded(
                                                child: Center(
                                                  child: Text('${viewModel.moneyFormat.format(viewModel.totalPay)}원',
                                                      style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      Container(
                                          child: Row(
                                            children: [
                                              const Expanded(
                                                child: Center(
                                                    child: Text("")
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    "${viewModel.selectedMonth!.subtract(const Duration(days: 30)).month}월 달 보다 "
                                                        "${(viewModel.totalPay - viewModel.prevMonthTotalPay >= 0) ?
                                                    "${viewModel.moneyFormat.format(viewModel.totalPay - viewModel.prevMonthTotalPay)}원 증가"
                                                        :
                                                    "${viewModel.moneyFormat.format(-(viewModel.totalPay - viewModel.prevMonthTotalPay))}원 감소"}"
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                        child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text("급여계산방식확인"),
                                                    GestureDetector(
                                                      onTap: () {
                                                        viewModel.toggleClicked();
                                                      },
                                                      child: Icon(Icons.arrow_drop_down),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Expanded(
                                                child: Text(""),
                                              ),
                                            ]
                                        ),
                                      ),
                                      Flexible(
                                        child:
                                        AnimatedContainer(
                                            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                            duration: Duration(milliseconds: 200),
                                            height: viewModel.isExpanded ? (viewModel.employeesCost!.length)*75.0 : 0.0,
                                            curve: Curves.easeInOut,
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                physics: AlwaysScrollableScrollPhysics(),
                                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                                itemCount: viewModel.employeesCost!.length,
                                                itemBuilder: (BuildContext context, int index){
                                                  return Column(
                                                      children : [
                                                        Container(
                                                          margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                                          child: Row(
                                                            children : [
                                                              Expanded(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        border: Border.all(width: 1, color: Colors.grey),
                                                                        color: Colors.grey
                                                                    ),
                                                                    child: Center(
                                                                      child: Text('${viewModel.employeesCost![index].date.month}월 ${viewModel.employeesCost![index].date.day}일'),
                                                                    ),
                                                                  )
                                                              ),
                                                              const Expanded(
                                                                  child:Text("")
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        border: Border.all(width: 1, color: Colors.grey),
                                                                        color: Colors.grey
                                                                    ),
                                                                    child: Center(
                                                                      child: Text('시급 ${viewModel.moneyFormat.format(viewModel.employeesCost![index].hourlyPay)}원',
                                                                        style: TextStyle(color: Colors.grey[200]),),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Center(
                                                                    child: Text("일반 근무 \n${viewModel.employeesCost![index].workingHour}시간"),
                                                                  )
                                                              ),
                                                              Expanded(child: Text('')),
                                                              viewModel.employeesCost![index].isAdditionalPayOccurred ?
                                                              Expanded(
                                                                  child: Theme(
                                                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                                      child:ExpansionTile(
                                                                        title: Center(
                                                                          child:
                                                                          Text("일 급여 \n${
                                                                              viewModel.moneyFormat.format(viewModel.employeesCost![index].workingHour * viewModel.employeesCost![index].hourlyPay +
                                                                                  viewModel.employeesCost![index].holidayPay * viewModel.employeesCost![index].hourlyPay * 1.5 +
                                                                                  viewModel.employeesCost![index].bonusDayPay * viewModel.employeesCost![index].hourlyPay * 2 +
                                                                                  viewModel.employeesCost![index].incentive)
                                                                          }원"),
                                                                        ),
                                                                        textColor: Colors.black,
                                                                        collapsedTextColor : Colors.black,
                                                                        children: [
                                                                          if(viewModel.employeesCost![index].holidayPay != 0)
                                                                            Center(
                                                                              child: Text("주휴 수당 ${viewModel.employeesCost![index].holidayPay}원"),
                                                                            ),
                                                                         if(viewModel.employeesCost![index].incentive != 0)
                                                                           Center(
                                                                             child: Text("인센티브 ${viewModel.employeesCost![index].incentive}원"),
                                                                           ),
                                                                          if(viewModel.employeesCost![index].bonusDayPay != 0)
                                                                            Center(
                                                                              child: Text("보너스 데이 ${viewModel.employeesCost![index].bonusDayPay}원"),
                                                                            )
                                                                        ],
                                                                      )
                                                                  )
                                                              )
                                                                  :
                                                              Expanded(
                                                                  child: Center(
                                                                    child:
                                                                    Text("일 급여 \n${
                                                                        viewModel.moneyFormat.format(viewModel.employeesCost![index].workingHour * viewModel.employeesCost![index].hourlyPay +
                                                                            viewModel.employeesCost![index].holidayPay * viewModel.employeesCost![index].hourlyPay * 1.5 +
                                                                            viewModel.employeesCost![index].bonusDayPay * viewModel.employeesCost![index].hourlyPay * 2 +
                                                                            viewModel.employeesCost![index].incentive)
                                                                    }원"),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]
                                                  );
                                                }
                                            )
                                        ),
                                      )
                                    ],
                                 ),
                            )

                          ]
                      )
                      );
                    }
                ),
              )
          );
        }
    );
  }

  Widget monthPicker(CostViewModel viewModel) {
    return MyExpansionTile(
      onExpansionChanged: (value) {
        viewModel.setCustomTileExpanded(value);
      },
      textColor: Colors.black,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              viewModel.setPickerYear(viewModel.pickerYear - 1);
            },
            icon: const Icon(Icons.navigate_before_rounded, color: Colors.black,),
          ),
          Expanded(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30,height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        viewModel.pickerYear.toString() + "년 "+ viewModel.selectedMonth.month.toString() + "월",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    viewModel.customTileExpanded ?
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(Icons.arrow_drop_up,size: 30, color: Colors.black,),
                    )
                        :
                    const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.arrow_drop_down, size: 30, color: Colors.black,)
                    )
                  ],
                )
            ),
          ),
          IconButton(
            onPressed: () {
              viewModel.setPickerYear(viewModel.pickerYear + 1);
            },
            icon: const Icon(Icons.navigate_next_rounded, color: Colors.black,),
          ),
        ],
      ),
      children: generateMonths(viewModel),
    );
  }


}

costTags(CostViewModel viewModel, int index) {
  return Row(
    children: [
      Expanded(
          child: Text('')
      ),
      Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                if(viewModel.employeesCost![index].holidayPay != 0)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.red),
                        color: Colors.red
                    ),
                    child: Center(
                      child: Text('주휴수당'),
                    ),
                  ),
                if(viewModel.employeesCost![index].incentive != 0)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.yellow),
                        color: Colors.yellow
                    ),
                    child: Center(
                      child: Text('인센티브'),
                    ),
                  ),
                if(viewModel.employeesCost![index].bonusDayPay != 0)
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: AppColor().mainColor),
                        color: AppColor().mainColor
                    ),
                    child: Center(
                      child: Text('보너스 데이'),
                    ),
                  )
              ]
          )
      )

    ],
  );
}