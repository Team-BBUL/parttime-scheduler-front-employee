import 'package:logger/logger.dart';

class DateUtility {
  final _logger = Logger();

  // 이번 주차 시작일 찾기
  DateTime findStartDay(DateTime base, int weekday) {

    return DateTime(base.year, base.month, base.day).subtract(
        Duration(days: (base.weekday - weekday))
    );
  }
}