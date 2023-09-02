import 'package:flutter/material.dart';

class Message{
  void showConfirmDialog({required BuildContext context,
    required String title, required String message, required Future Function() apiCall}) async{
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("취소")
              ),
              TextButton(
                  onPressed: (){
                    apiCall.call().then((_){
                      Navigator.pop(context);
                    }).catchError((e){
                      print(e);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("확인")
              )
            ],
          );
        }
    );
  }

  void showAlertDialog({required BuildContext context,
    required String title, required String message,}) async{
    await Future.delayed(Duration(microseconds: 1));
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("학인")
              ),
            ],
          );
        }
    );
  }
}