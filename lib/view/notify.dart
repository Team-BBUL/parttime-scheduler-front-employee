import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/view_model/notify_view_model.dart';

import 'custom_cupertino_picker.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('알림 설정'),

        ),
        body : Consumer<NotifyViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("알림", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: toggleButton(viewModel,'notify')
                            )
                          ],
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("근무표 작성 및 수정 알림", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: toggleButton(viewModel,'modifyNotify')
                            )
                          ],
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("근무 시간 알림", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                                    child: ElevatedButton(
                                      onPressed: () => showDialog(
                                          CupertinoPicker(
                                            backgroundColor: Colors.white,
                                            magnification: 1.22,
                                            squeeze: 1.2,
                                            useMagnifier: true,
                                            itemExtent: 32.0,
                                            looping: true,
                                            selectionOverlay: CustomCupertinoPickerDefaultSelectionOverlay(
                                              text: viewModel.text,
                                            ),
                                            // This sets the initial item.
                                            scrollController: FixedExtentScrollController(
                                              initialItem: viewModel.selectedNotifyWorkTime,
                                            ),
                                            // This is called when selected item is changed.
                                            onSelectedItemChanged: (int selectedItem) {
                                              viewModel.setTime(selectedItem);
                                            },
                                            children:
                                            List<Widget>.generate(viewModel.times.length, (int index) {
                                              return Center(
                                                  child: Text('${viewModel.times[index]}'));
                                            }),
                                          ),
                                          context,
                                          viewModel
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("${viewModel.selectedNotifyWorkTime}${viewModel.text} 전", style: TextStyle(fontSize: 16,color: Colors.black)),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_drop_down,color: Colors.black,),
                                        ],
                                      ),
                                    )
                                ),
                            Expanded(
                                flex: 3,
                                child: toggleButton(viewModel,'workTimeNotify')
                            )
                          ],
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("근무변경요청 알림", style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                                child: toggleButton(viewModel,'changeRequestNotify')
                            )
                          ],
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("채팅 알림", style: TextStyle(fontSize: 16)),
                                ),
                            ),
                            Expanded(
                              flex: 3,
                              child: toggleButton(viewModel,'chattingNotify')
                            )
                          ],
                        )
                    ),
                  ]
              );
            }
        )
    );
  }
  Widget toggleButton(viewModel, String key){
    return FlutterSwitch(
      width: 40,
      height: 25,
      toggleSize: 17,
      padding: 2,
      value: viewModel.notifyList[key]!,
      activeColor: Color(0xFF7CFF67),
      onToggle: (bool value) {
        viewModel.toggle(key);
        },
    );
  }

  // 동기적으로 처리하여 모달팝업이 pop될 시 api호출 function을 작동하게 함.
  showDialog(Widget child, context,viewModel) async {
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
    viewModel.sendTime(viewModel.selectedNotifyWorkTime);
  }
}
