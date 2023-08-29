import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sidam_worker/model/appColor.dart';
import 'package:sidam_worker/model/schedule_model.dart';
import 'package:sidam_worker/model/user_model.dart';

import 'package:sidam_worker/viewModel/store_view_model.dart';
import 'package:sidam_worker/viewModel/work_swap_view_model.dart';

import 'package:sidam_worker/utility/shared_preference_provider.dart';

class SwapViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewerState();
}

class _ViewerState extends State<SwapViewer> {
  // design constant
  final _designWidth = 411;
  final _designHeight = 683;
  AppColor color = AppColor();

  // model
  bool _myView = true; // 내 근무를 그릴지 다른 근무자의 근무를 그릴지 구분
  int roleId = 0;

  void loadSPProvider() async {
    final provider = Provider.of<SharedPreferencesProvider>(context);
    roleId = await provider.getRoleId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _myView ? viewMySchedule() : viewOtherSchedule(),
      ],
    );
  }

  // 내 스케줄을 띄우는 위젯
  Widget viewMySchedule() {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double timeWidth = 45;
    // 맨좌우 여백 10, 각 시간 블록 사이 여백 5씩
    double dayWidth = (deviceWidth - timeWidth - 10 - 20) / 8;
    double scheduleHeight = 430;

    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      const Text(
        '변경하실 근무를 선택해주세요!',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      const SizedBox(
        height: 10,
      ),
      Consumer<StoreViewModel>(builder: (context, storeProv, child) {
        return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(children: [
                // 시간을 띄우는 부분
                SizedBox(
                  width: timeWidth,
                  height: scheduleHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '\n',
                        style: TextStyle(fontSize: 8),
                      ),
                      for (int i = storeProv.store.open ?? 0;
                          i < (storeProv.store.close ?? 0);
                          i++)
                        Text(
                          '$i:00',
                          style: TextStyle(
                              fontSize: 12 * deviceHeight / _designHeight),
                        ),
                    ],
                  ),
                ),

                // 각 날짜의 스케줄 박스를 띄우는 부분
                for (int i = 0; i < 7; i++) ...[
                  SizedBox(
                      height: scheduleHeight,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              // 날짜를 구하기 위해 provider에 저장된 주 첫날 + i를 그 달의 마지막 날로 모듈러 연산해서, 0일을 1일로 만들기 위해 마지막 날로 나눈 몫을 합
                              '${(prov.week.day + i) % (DateTime(prov.week.year, prov.week.month + 1, 1).subtract(const Duration(days: 1)).day + 1) + ((prov.week.day + i) / (DateTime(prov.week.year, prov.week.month + 1, 1).subtract(const Duration(days: 1)).day + 1)).floor()}'
                              '일\n${week[storeProv.store.weekStartDay ?? 1 + i]}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            for (int j = 0;
                                j <
                                    ((storeProv.store.close ?? 0) -
                                        (storeProv.store.open ?? 0));
                                j++) ...[
                              GestureDetector(
                                child: Container(
                                  color: prov.mySchedules.isNotEmpty &&
                                          prov.mySchedules.length > i &&
                                          prov.mySchedules[i].time.isNotEmpty &&
                                          prov.mySchedules[i].time[j]
                                      ? color.mainColor
                                      : Colors.black12,
                                  height: 42 * deviceHeight / _designHeight -
                                      ((storeProv.store.close ?? 0) -
                                          (storeProv.store.open ?? 0)),
                                  width: dayWidth,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                ),
                                onTap: () {
                                  // 스케줄이 더미가 아니고 시간이 있으면 통과,
                                  if (prov.mySchedules[i].id != 0 &&
                                      prov.mySchedules[i].time[j]) {
                                    print('${prov.mySchedules[i].id} 스케줄 선택됨');
                                    checkDialog(prov.mySchedules[i],
                                        storeProv.store.open ?? 0);
                                  }
                                },
                              )
                            ]
                          ])),
                ]
              ]));
        });
      })
    ]);
  }

  // 다른 근무자의 스케줄 띄우기
  Widget viewOtherSchedule() {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double timeWidth = 40;
    // 맨좌우 여백 10, 각 시간 블록 사이 여백 5씩
    double dayWidth = (deviceWidth - timeWidth - 10 - 20) / 8;
    double scheduleHeight = 430;

    DateTime selectDate;
    int selected = 0;

    return Column(children: [
      /*const Text(
        '변경하실 근무를 선택해주세요!',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),*/
      const SizedBox(
        height: 10,
      ),
      Consumer<StoreViewModel>(builder: (context, storeProv, child) {
        return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(children: [
                SizedBox(
                    height: 55,
                    width: deviceWidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 각 날짜를 띄우는 부분
                          for (int i = 0; i < 7; i++) ...[
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    child: Text(
                                      '${prov.week.add(Duration(days: i)).day}'
                                      '일\n${week[storeProv.store.weekStartDay ?? 1 + i]}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      selectDate =
                                          prov.week.add(Duration(days: i));
                                      setState(() {
                                        selected = i;
                                      });
                                      print(
                                          '${selectDate.month}월 ${selectDate.day}일 선택됨');
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  selected == i
                                      ? Container(
                                          height: 5,
                                          width: 40,
                                          color: Colors.red,
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ]),
                          ],
                        ])),
                SizedBox(
                    height: scheduleHeight,
                    width: deviceWidth,
                    child: ListView.builder(
                        itemCount: ((storeProv.store.close ?? 0) -
                            (storeProv.store.open ?? 0)),
                        itemBuilder: (context, idx) {
                          return Row(children: [
                                // 시각을 띄우는 부분
                                SizedBox(
                                  width: timeWidth,
                                  height: 33,
                                  child: Text(
                                    '${idx + (storeProv.store.open ?? 0)}:00',
                                    style: TextStyle(
                                        fontSize:
                                            12 * deviceHeight / _designHeight),
                                  ),
                                ),
                                // 스케줄 블록을 띄우는 부분
                                SizedBox(
                                    height: 30,
                                    width: 50,
                                    child: GestureDetector(
                                      child: Container(
                                        color: Colors.black12,
                                        height: 42 *
                                                deviceHeight /
                                                _designHeight -
                                            ((storeProv.store.close ?? 0) -
                                                (storeProv.store.open ?? 0)),
                                        width: dayWidth,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                      ),
                                      onTap: () {
                                        // 스케줄이 더미가 아니고 시간이 있으면 통과,
                                      },
                                    ))
                              ]);
                        })),
              ]));
        });
      })
    ]);
  }

  // 스케줄의 시작 시각 찾기
  int findStartTime(Schedule schedule) {
    for (int i = 0; i < schedule.time.length; i++) {
      if (schedule.time[i]) {
        return i;
      }
    }

    return 0;
  }

  // schedule 객체의 근무 시간을 계산해 숫자로 변환하는 메소드
  int _calculateTime(Schedule schedule) {
    int time = 0;
    for (bool t in schedule.time) {
      if (t) {
        time++;
      }
    }
    return time;
  }

  // 선택 확인 팝업
  bool checkDialog(Schedule schedule, int time) {
    List<String> weekday = [
      'non',
      '월요일',
      '화요일',
      '수요일',
      '목요일',
      '금요일',
      '토요일',
      '일요일'
    ];

    int startTime = findStartTime(schedule) + time;
    int endTime = startTime + _calculateTime(schedule);

    bool result = true;

    showDialog(
        context: context,
        barrierDismissible: false, // 팝업 영역 바깥을 터치 시 사라질지 여부
        builder: (BuildContext context) {
          return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              contentPadding: const EdgeInsets.all(25),
              actionsAlignment: MainAxisAlignment.spaceAround,
              alignment: Alignment.center,
              backgroundColor: Colors.white,
              content: Text('선택하신 근무가 ${weekday[schedule.day.weekday]}'
                  '(${schedule.day.day}일) $startTime:00 - $endTime:00 근무가 맞나요?'),
              actions: [
                IconButton(
                    onPressed: () {
                      result = true;
                      setState(() {
                        _myView = true;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/icons/x.svg')),
                IconButton(
                    onPressed: () {
                      result = false;
                      setState(() {
                        _myView = false;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/icons/check.svg')),
              ],
            );
          });
        });
    return result;
  }

  // 스케줄과 bool 변수를 받아 조건이 맞는지 반환하는 메소드
  /*bool check(Schedule schedule) {

    for (var user in schedule.workers) {
      if (user.id == roleId) { return true; }
      else if (!_myView) { return true; }
    }
    return false;
  }*/
}
