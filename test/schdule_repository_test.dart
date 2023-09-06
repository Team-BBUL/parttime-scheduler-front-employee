import 'dart:convert';

import 'package:sidam_worker/data/repository/schedule_repository.dart';
import 'package:test/test.dart';

void main(){
  ScheduleRepository scheduleRepository = ScheduleRepository();

  test('calculate previous month', (){
    expect(scheduleRepository.getPrevYearMonth('202306', 08), '202305');
  });

  test('calculate previous month without front of the month zero padding', (){
    expect(scheduleRepository.getPrevYearMonth('202312', 08), '202311');
  });

  test('calculate previous month with month zero padding', (){
    expect(scheduleRepository.getPrevYearMonth('202210', 08), '202209');
  });

  test('calculate previous year', (){
    expect(scheduleRepository.getPrevYearMonth('202401', 08), '202312');
  });

  String jsonData = '''
{
  "date": [
    {
      "id": 1,
      "day": "2023-03-06",
      "schedule": [
        {
          "id": 1,
          "time": [true, true, true, true, false, false, false, false, false, false, false, false ],
          "workers": [
            {
              "id": 1,
              "alias": "홍길동",
              "color": "0xFF000000",
              "cost": 10000
            }
          ]
        },
        {
          "id": 2,
          "time": [false, false, false, true, true, true, true, false, false, false, false, false ],
          "workers": [
            {
              "id": 1,
              "alias": "최판서",
              "color": "0xFF000000",
              "cost": 10000
            }
          ]
        }
      ]
    },
    null,
    null
  ],
  "time_stamp": "2023-05-28T21:23:52"
}
''';

  Map<String, dynamic> decodedData = json.decode(jsonData);

  List<Map<String, dynamic>> dateList = (decodedData['date'] as List<dynamic>?)
      ?.where((item) => item != null)
      ?.cast<Map<String, dynamic>>() // 타입 캐스트는 null 값 제외 후에 수행합니다.
      ?.toList() ?? [];

  List<dynamic> filteredDays = dateList
      .where((item) => int.parse(item['day'].substring(8,10)) <= 8)
      .toList();

  print(filteredDays);
}