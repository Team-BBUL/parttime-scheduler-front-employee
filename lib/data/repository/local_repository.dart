import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/schedule.dart';


class ScheduleRepository{
  Future<List<Schedule>> getItemsFromJsonAssets() async {
    String jsonString = await rootBundle.loadString('asset/data.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => Schedule.fromJson(json)).toList();
  }
}