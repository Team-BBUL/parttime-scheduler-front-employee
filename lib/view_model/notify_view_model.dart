import 'package:flutter/cupertino.dart';

class NotifyViewModel extends ChangeNotifier{
  Map<String, bool> notifyList = {
    'notify': false,
    'modifyNotify': false,
    'workTimeNotify':false,
    'changeRequestNotify': false,
    'chattingNotify': false,
  };
  String text = '분';
  List<int> times = List<int>.generate(61, (index) => index);
  int selectedNotifyWorkTime = 0;

  void toggle(selected){
    notifyList[selected] = !notifyList[selected]!;
    print(notifyList[selected]);
    notifyListeners();
  }
  void setTime(int time){
    selectedNotifyWorkTime = time;
    print('NotifyViewModel.setTime:$selectedNotifyWorkTime');
    notifyListeners();
  }
  void sendTime(selected) {
    print('NotifyViewModel.sendTime:$selected');
    notifyListeners();
  }
}