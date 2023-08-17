import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view_model/cost_view_model.dart';

import 'custom_cupertino_picker.dart';

class CostScreen extends StatelessWidget{
  const CostScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child : Consumer<CostViewModel>(
                builder:(context, viewModel,child){
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        child: selectDateWidget(viewModel, context),
                      ),
                      Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Row(
                            children:  [
                              Expanded(
                                  child:
                                  viewModel.dateIndex == viewModel.dateList.length -1 ?
                                  Text("이번 달 예상 급여 (급여일 기준 : ${viewModel.costDay}일 )")
                                      :
                                  Text("지급 급여 (급여일 기준 : ${viewModel.costDay}일 )")
                              ),
                            ],
                          )
                      ),
                      Container(
                          child: Row(
                            children:  [
                              Expanded(
                                child: Center(
                                  child: Text('${viewModel.totalPay}원', style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                          child: Row(
                            children: const [
                              Expanded(
                                child: Center(
                                    child: Text("")
                                ),
                              ),
                              Expanded(
                                child: Text("2월 달 보다 20,000원 증가"),
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
                      Container(
                          child : Row(
                            children:  [
                              Expanded(
                                  child: Center(
                                    child: Text("총 근무 ${viewModel.totalWorkTime}시간", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                  )
                              ),
                              Expanded(
                                  child: Center(
                                    child: Text("시급 ${viewModel.pay}원", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                  )
                              ),
                            ],
                          )
                      ),
                      Flexible(
                        child:                 AnimatedContainer(
                            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            duration: Duration(milliseconds: 200),
                            height: viewModel.isExpanded ? (viewModel.monthCost.length)*75.0 : 0.0,
                            curve: Curves.easeInOut,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                itemCount: viewModel.monthCost.length,
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
                                                      child: Text(viewModel.monthCost[index].date),
                                                    ),
                                                  )
                                              ),
                                              const Expanded(
                                                  child:Text("")
                                              ),
                                              const Expanded(
                                                  child:Text("")
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
                                                    child: Text("일반 근무 ${viewModel.monthCost[index].dayHour}시간"),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Center(
                                                    child: Text("야간 근무 ${viewModel.monthCost[index].nighHour}시간"),
                                                  )
                                              ),
                                              Expanded(
                                                  child: Center(
                                                    child: Text("급여 ${viewModel.monthCost[index].dayCost}원"),
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
                  );
                }
            )
        )
    );
  }
  Widget selectDateWidget(CostViewModel viewModel, BuildContext context){
    return Row(
      children: [
        Expanded(
            child: IconButton(
                onPressed: () {
                  int index = viewModel.dateIndex;
                  if(index > 0 ) {
                    viewModel.setDate(index-1);
                    viewModel.getCost(viewModel.dateList[index-1]);
                  }
                },
              icon: Icon(Icons.arrow_circle_left)),
        ),
        Expanded(
            child: TextButton(
              child: Text('${viewModel.selectedDate}', style: TextStyle(color: Colors.black)),
              onPressed: () => showDialog(
                  CupertinoPicker(
                    backgroundColor: Colors.white,
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    looping: false,
                    // This sets the initial item.
                    scrollController: FixedExtentScrollController(
                      initialItem:  viewModel.dateList.length - viewModel.dateIndex - 1
                    ),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItemIndex) {
                      viewModel.dateIndex = viewModel.dateList.length - selectedItemIndex - 1;
                    },
                    children:
                    List<Widget>.generate(viewModel.dateList.length, (int index) {
                      int reversedIndex = viewModel.dateList.length - index - 1;
                      return Center(
                          child: Text('${viewModel.dateList[reversedIndex]}'));
                    }),
                  ),

                  context,
                  viewModel
              ),
            ),
        ),
        Expanded(
          child: IconButton(
              onPressed: () {
                int index = viewModel.dateIndex;
                if(index < viewModel.dateList.length-1) {
                  viewModel.setDate(index+1);
                  viewModel.getCost(viewModel.dateList[index+1]);
                }
              },

              icon: Icon(Icons.arrow_circle_right)),
        ),
      ],
    );
  }

  showDialog(Widget child, BuildContext context, CostViewModel viewModel) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 3.0),
        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: true,
          child: child,
        ),
      ),
    );
    viewModel.setDate(viewModel.dateIndex);
    viewModel.getCost(viewModel.selectedDate);
  }
}



