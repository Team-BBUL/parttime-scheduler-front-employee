// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sidam_worker/main.dart';

void main() {

  int year = 2023;
  int month = 12;

  DateTime firstDayOfMonth = DateTime(year, month, 1);
  DateTime lastDayOfMonth = DateTime(year, month + 1, 1);

  print('첫 날: ${firstDayOfMonth.day}');
  print('말일: ${lastDayOfMonth.day}');

  print('년도 : ${firstDayOfMonth.year}');
  print('한달 뒤 년도 : ${lastDayOfMonth.year}');


  DateTime curMonth = DateTime(2023, 07, 31);
  DateTime prevMonth = DateTime(2023, 07 - 1, 31+1);

  print('현재 달 : ${curMonth}');
  print('이전 달 : ${prevMonth}');


/*  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/
}
