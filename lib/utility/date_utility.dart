import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class DateUtility {
  final _logger = Logger();

  // 이번 주차 시작일 찾기
  DateTime findStartDay(DateTime base, int weekday) {

    if (base.weekday == weekday) { return base; }

    return DateTime(base.year, base.month, base.day).subtract(
        Duration(days: 7 - (weekday - base.weekday))
    );
  }
}