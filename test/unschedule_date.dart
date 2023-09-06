import 'package:sidam_employee/model/unscheduled_date.dart';
import 'package:test/test.dart';

void main() {
  UnscheduledDate unscheduledDate =
  UnscheduledDate.getRecentWeekOnUnscheduled(DateTime.monday, 3);
  test('calculate previous month', () {
    expect(unscheduledDate.dates,1 );
  });

 {

}}