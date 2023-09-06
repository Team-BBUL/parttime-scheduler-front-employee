import 'package:flutter/material.dart';

import 'dialog_message.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder;

  AppFutureBuilder({required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          Message().showAlertDialog(
              context: context,
              title: "에러",
              message: "에러가 발생했습니다.");
          return Container();
        } else {
          return builder(context, snapshot);
        }
      },
    );
  }
}