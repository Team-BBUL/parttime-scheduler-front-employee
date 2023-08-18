import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class LocalDataSource {

  final Logger logger = Logger();

  Future<Map<String, dynamic>> getWeeklySchedule(DateTime now) async {

    var fileName = DateFormat('yyyyMM').format(now);

    String json = await rootBundle.loadString('assets/json/schedules/$fileName.json')
        .catchError((error) {
      logger.e('error: $error');
      return "json 읽기 오류";
    });

    return jsonDecode(json);
  }
}