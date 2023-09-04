import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sidam_worker/util/appColor.dart';
import 'package:sidam_worker/model/schedule_model.dart';

import 'package:sidam_worker/view_model/selected_store_info_view_model.dart';
import 'package:sidam_worker/view_model/work_swap_view_model.dart';

import 'package:sidam_worker/util/shared_preference_provider.dart';

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
  int roleId = 0; // 선택된 교환 근무자의 id

  void loadSPProvider() async {
    final provider = Provider.of<SharedPreferencesProvider>(context);
    roleId = await provider.getRoleId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _myView ? viewMySchedule() : viewOtherSchedule(),
    ],);
  }

  // 다른 근무자를 선택하는 위젯
  Widget selectOtherWorker() {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: deviceWidth,
      height: 30,
      child: Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
        return ListView.builder(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: prov.workers.length,
            itemBuilder: (context, idx) {
              return Row(
                children: [
                  const SizedBox(width: 5,),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size.zero),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                        // 선택하거나 선택한 근무자가 현재 띄우고 있는 객체일 경우 빨갛게 강조표시
                        if (states.contains(MaterialState.pressed) || prov.otherId == prov.workers[idx].id) {
                          return Colors.red;
                        } else {
                          return Color(int.parse(prov.workers[idx].color));
                        }
                      }),
                      padding: MaterialStateProperty.all(const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5)),
                    ),
                    child: Text(prov.workers[idx].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        prov.otherId = prov.workers[idx].id;
                        prov.name = prov.workers[idx].name;
                        prov.getOtherWorkerSchedule();
                      });
                      print('${prov.workers[idx].id} 근무자가 선택됨');
                    },
                  ),
                  const SizedBox(width: 5,)
                ],
              );
            });
      }),
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
        '변경 요청하실 근무를 선택해주세요!',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      const SizedBox(
        height: 10,
      ),
      Consumer<SelectedStore>(builder: (context, storeProv, child) {
        return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(children: [
                SizedBox(
                    width: deviceWidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          // 날짜 띄우는 부분
                          for (int i = 0; i < 7; i++) ...[
                            RichText(
                              text: TextSpan(
                                text: '${prov.week.add(Duration(days: i)).day}'
                                    '일\n${week[((prov.week.weekday + i) > 7 ? (prov.week.weekday + i) % 8 + 1 : prov.week.weekday + i)]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: // 오늘에 포인트 주기
                                      DateFormat.yMd().format(DateTime.now()) ==
                                              DateFormat.yMd().format(
                                                  prov.mySchedules.isNotEmpty
                                                      ? prov.mySchedules[i].day
                                                      : DateTime.parse('2023-01-01'))
                                          ? Colors.red
                                          : Colors.black,
                                  fontWeight: DateFormat.yMd().format(DateTime.now()) ==
                                          DateFormat.yMd().format(prov.mySchedules.isNotEmpty
                                              ? prov.mySchedules[i].day
                                              : DateTime.parse('2023-01-01'))
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 20,
                            )
                          ]
                        ])),
                const SizedBox(
                  height: 7,
                ),

                // 시간과 블록을 띄우는 부분
                SizedBox(
                    width: deviceWidth,
                    height: scheduleHeight - 24,
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: (storeProv.storeInfo.close ?? 0) -
                            (storeProv.storeInfo.open ?? 0),
                        itemBuilder: (context, idx) {
                          return Column(children: [
                            Row(children: [
                              SizedBox(
                                width: timeWidth,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${idx + (storeProv.storeInfo.open ?? 0)}:00',
                                      style: TextStyle(
                                          fontSize: 12 * deviceHeight / _designHeight),
                                    )
                                  ],
                                ),
                              ),
                              // 각 날짜의 스케줄 박스를 띄우는 부분
                              Row(children: [
                                for (int j = 0; j < 7; j++) ...[
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            color: prov.mySchedules.isNotEmpty &&
                                                    prov.mySchedules.length > j &&
                                                    prov.mySchedules[j].time.isNotEmpty &&
                                                    prov.mySchedules[j].time[idx]
                                                ? color.mainColor
                                                : Colors.black12,
                                            height: 42 * deviceHeight
                                                / _designHeight - ((storeProv.storeInfo.close ?? 0) - (storeProv.storeInfo.open ?? 0)),
                                            width: dayWidth,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                          ),
                                          onTap: () {
                                            // 스케줄이 더미가 아니고 시간이 있으면 통과,
                                            if (prov.mySchedules[j].id != 0 && prov.mySchedules[j].time[idx]) {

                                              print('${prov.mySchedules[j].id} 스케줄 선택됨');

                                              checkDialog(prov.mySchedules[j], storeProv.storeInfo.open ?? 0);
                                              prov.mySchedule = prov.mySchedules[j];
                                            }
                                          },
                                        )
                                      ])
                                ]
                              ])
                            ]),
                            const SizedBox(
                              height: 1,
                            )
                          ]);
                        })),
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

    double timeWidth = 45;
    // 맨좌우 여백 10, 각 시간 블록 사이 여백 5씩
    double dayWidth = (deviceWidth - timeWidth - 10 - 20) / 8;
    double scheduleHeight = 430;

    return Column(children: [

      const SizedBox(height: 5,),

      selectOtherWorker(),

      const SizedBox(
        height: 5,
      ),
      Consumer<SelectedStore>(builder: (context, storeProv, child) {
        return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Column(children: [
                SizedBox(
                    width: deviceWidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          // 날짜 띄우는 부분
                          for (int i = 0; i < 7; i++) ...[
                            RichText(
                              text: TextSpan(
                                text: '${prov.week.add(Duration(days: i)).day}'
                                    '일\n${week[((prov.week.weekday + i) > 7 ? (prov.week.weekday + i) % 8 + 1 : prov.week.weekday + i)]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: // 오늘에 포인트 주기
                                      DateFormat.yMd().format(DateTime.now()) ==
                                              DateFormat.yMd().format(
                                                  prov.mySchedules.isNotEmpty
                                                      ? prov.mySchedules[i].day
                                                      : DateTime.parse(
                                                          '2023-01-01'))
                                          ? Colors.red
                                          : Colors.black,
                                  fontWeight: DateFormat.yMd()
                                              .format(DateTime.now()) ==
                                          DateFormat.yMd().format(prov
                                                  .mySchedules.isNotEmpty
                                              ? prov.mySchedules[i].day
                                              : DateTime.parse('2023-01-01'))
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 20,
                            )
                          ]
                        ])),
                const SizedBox(
                  height: 7,
                ),

                // 시간과 블록을 띄우는 부분
                SizedBox(
                    width: deviceWidth,
                    height: scheduleHeight - 55,
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: (storeProv.storeInfo.close ?? 0) -
                            (storeProv.storeInfo.open ?? 0),
                        itemBuilder: (context, idx) {
                          return Column(children: [
                            Row(children: [
                              SizedBox(
                                width: timeWidth,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${idx + (storeProv.storeInfo.open ?? 0)}:00',
                                      style: TextStyle(
                                          fontSize: 12 * deviceHeight / _designHeight),
                                    )
                                  ],
                                ),
                              ),
                              // 각 날짜의 스케줄 박스를 띄우는 부분
                              Row(children: [
                                for (int j = 0; j < 7; j++) ...[
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            color: prov.otherSchedules.isNotEmpty &&
                                                    prov.otherSchedules.length > j &&
                                                    prov.otherSchedules[j].time.isNotEmpty &&
                                                    prov.otherSchedules[j].time[idx]
                                                ? color.mainColor
                                                : Colors.black12,
                                            height: 40 * deviceHeight /
                                                _designHeight - ((storeProv.storeInfo.close ?? 0) - (storeProv.storeInfo.open ?? 0)),
                                            width: dayWidth,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                          ),
                                          onTap: () {
                                            // 스케줄이 더미가 아니고 시간이 있으면 통과,
                                            if (prov.otherSchedules[j].id != 0 && prov.otherSchedules[j].time[idx]) {

                                              print('${prov.otherSchedules[j].id} 스케줄 선택됨');

                                              checkDialog(prov.otherSchedules[j], storeProv.storeInfo.open ?? 0);
                                              prov.target = prov.otherSchedules[j];
                                            }
                                          },
                                        )
                                      ])
                                ]
                              ])
                            ]),
                            const SizedBox(
                              height: 1,
                            )
                          ]);
                        })),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                            backgroundColor: color.blackColor,
                          ),
                          onPressed: (){
                            print('대상 비지정 요청 선택됨');
                            showDialog(context: context, builder: (builder) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),),
                                contentPadding: const EdgeInsets.all(25.0),
                                content: RichText(
                                  text: const TextSpan(
                                      text: '이대로 전송하면 선택한 근무의 대체 근무는 ',
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(text: '점주님이 직접 선택',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                      TextSpan(text: '해야 합니다.\n',
                                          style: TextStyle(color: Colors.black)),
                                      TextSpan(text: '점주님과 논의 후 전송하는 것을 추천드립니다.',
                                          style: TextStyle(color: Colors.black87,)),
                                      TextSpan(text: '\n\n정말 전송할까요?',
                                          style: TextStyle(color: Colors.black)),
                                    ]
                                  ),),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: SvgPicture.asset('assets/icons/x.svg')),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // 데이터 전송 프로세스
                                        prov.postChangeReq(false);
                                      },
                                      icon: SvgPicture.asset('assets/icons/check.svg')),
                                ],
                              );
                            },
                              barrierDismissible: false,
                            );
                          },
                          child: const Text('사장님이 골라주세요!',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),)),

                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: (){
                          if (prov.mySchedule != null && prov.target != null) {
                              showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    contentPadding: const EdgeInsets.all(25.0),
                                    content: RichText(
                                      text: TextSpan(
                                          text: '당신의 ',
                                          style: const TextStyle(color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(text: '${week[prov.mySchedule!.day.weekday]}요일'
                                                '(${prov.mySchedule!.day.day}일) '
                                                '${(storeProv.storeInfo.open ?? 0) + _findStartTime(prov.mySchedule!)}:00 - '
                                                '${(storeProv.storeInfo.open ?? 0) + _findStartTime(prov.mySchedule!) + _calculateTime(prov.mySchedule!)}:00 근무',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),

                                            const TextSpan(text: '를\n',
                                                style: TextStyle(
                                                    color: Colors.black)),

                                            TextSpan(text: '${prov.name}님의 ',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                )),

                                            TextSpan(text: '${week[prov.target!.day.weekday]}요일'
                                                '(${prov.target!.day.day}일) '
                                                '${(storeProv.storeInfo.open ?? 0) + _findStartTime(prov.target!)}:00 - '
                                                '${(storeProv.storeInfo.open ?? 0) + _findStartTime(prov.target!) + _calculateTime(prov.target!)}:00 근무',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),

                                            const TextSpan(text: '와 교환 요청할까요?\n한번 전송한 요청은 취소, 수정할 수 없습니다.',
                                                style: TextStyle(
                                                  color: Colors.black,)),
                                          ]),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    actions: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/icons/x.svg')),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            // 데이터 전송 프로세스
                                            prov.postChangeReq(true);
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/icons/check.svg')),
                                    ],
                                  );
                                },
                                barrierDismissible: false,
                              );
                          }

                          print('내 ${prov.mySchedule?.day.toIso8601String()}와'
                              ' 상대의 ${prov.target?.day.toIso8601String()}를 교환 신청');
                        },
                        child: const Text('전송',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),)),
                    ])
              ]));
        });
      })
    ]);
  }

  // 스케줄의 시작 시각 찾기
  int _findStartTime(Schedule schedule) {
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
  void checkDialog(Schedule schedule, int time) {
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

    int startTime = _findStartTime(schedule) + time;
    int endTime = startTime + _calculateTime(schedule);

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
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/icons/x.svg')),
                IconButton(
                    onPressed: () {
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
