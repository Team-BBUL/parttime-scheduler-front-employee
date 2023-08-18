import 'package:sidam_worker/api/local_data_source.dart';
import 'package:sidam_worker/model/schedule_model.dart';
import 'package:sidam_worker/model/user_model.dart';

class ScheduleRepository {
  final LocalDataSource _dataSource = LocalDataSource();

  Future<List<Schedule>> loadMySchedule(DateTime now) async {

    Map<String, dynamic> data = await _dataSource.getWeeklySchedule(now);
    List<Schedule> result = [];
    bool insert;

    // 이번주 내 스케줄 찾기
    for (var day in data['date']) {

      insert = false;
      // 스케줄이 없는 날짜면 스킵
      if (day == null) {
        result.add(Schedule(id: 0, day: DateTime.parse(day['day']), time: [], workers: []));
        continue;
      }

      for (var daily in day['schedule']) {

        Schedule schedule = Schedule.fromJson(daily, DateTime.parse(day['day']));

        // 근무자 목록 중에서 사용자를 찾음
        for (User u in schedule.workers) {
          if (u.id == 7) {
            result.add(schedule);
            insert = true;
          }
        }
      }

      // add가 안 일어났으면 (= 내 스케줄이 없는 날이었으면) 더미 추가
      if (!insert) {
        result.add(Schedule(id: 0, day: DateTime.parse(day['day']), time: [], workers: []));
      }
    }

    result.sort((a, b) => a.day.compareTo(b.day));

    return result;
  }
}