import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/impossible_schedule.dart';

class ImpossibleScheduleRepository{
  Future<void> saveJson(ImpossibleTime impossibleTime) async {
    try {
      final jsonData = jsonEncode(impossibleTime.toJson());

      //해당 앱에서만 엑세스 할 수 있는 경로 (/data/user/0/패키지이름/app_flutter)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/impossible_schedule.json');

      await file.writeAsString(jsonData);
    } catch (e) {
      print('Error saving cells to JSON: $e');
    }
  }

  Future<ImpossibleTime> loadJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/impossible_schedule.json');

      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final decodedData = json.decode(jsonData);

        return ImpossibleTime.fromJson(decodedData);
      }
    } catch (e) {
      print('Error loading cells from JSON: $e');
    }
    return ImpossibleTime();
  }
}