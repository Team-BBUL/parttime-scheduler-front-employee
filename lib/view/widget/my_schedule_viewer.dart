import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sidam_worker/util/appColor.dart';

import 'package:sidam_worker/viewModel/store_view_model.dart';
import 'package:sidam_worker/viewModel/schedule_view_model.dart';

class ScheduleViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScheduleViewerState();
}

class _ScheduleViewerState extends State<ScheduleViewer> {
  // design constant
  final _designWidth = 411;
  final _designHeight = 683;
  AppColor color = AppColor();

  @override
  Widget build(BuildContext context) {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double timeWidth = 45;
    // 맨좌우 여백 10, 각 시간 블록 사이 여백 5씩
    double dayWidth = (deviceWidth - timeWidth - 10 - 20) / 8;
    double scheduleHeight = 280 * deviceHeight / _designHeight;

    return Consumer<StoreViewModel>(builder: (context, storeProv, child) {
      return Consumer<ScheduleViewModel>(builder: (context, prov, child) {
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
                                  '일\n${week[((prov.week.weekday + i) > 7 ?
                                  (prov.week.weekday + i) % 8 + 1 : prov.week.weekday + i)]}',
                              style: TextStyle(
                                fontSize: 12,
                                color: // 오늘에 포인트 주기
                                    DateFormat.yMd().format(DateTime.now()) ==
                                            DateFormat.yMd().format(
                                                prov.scheduleList.isNotEmpty
                                                ? prov.scheduleList[i].day
                                                : DateTime.parse('2023-01-01'))
                                        ? Colors.red
                                        : Colors.black,
                                fontWeight: DateFormat.yMd()
                                            .format(DateTime.now()) ==
                                        DateFormat.yMd().format(
                                            prov.scheduleList.isNotEmpty
                                                ? prov.scheduleList[i].day
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
              const SizedBox(height: 7,),

              // 시간과 블록을 띄우는 부분
              SizedBox(
                  width: deviceWidth,
                  height: scheduleHeight - 24,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                      itemCount: (storeProv.store.close ?? 0) -
                          (storeProv.store.open ?? 0),
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
                                    '${idx + (storeProv.store.open ?? 0)}:00',
                                    style: TextStyle(
                                        fontSize:
                                            12 * deviceHeight / _designHeight),
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
                                      Container(
                                        color: prov.scheduleList.isNotEmpty &&
                                             prov.scheduleList[j].time
                                                 .isNotEmpty &&
                                              prov.scheduleList[j].time[idx]
                                             ? color.mainColor :
                                            Colors.black12,
                                        height: 31 *
                                                deviceHeight /
                                                _designHeight -
                                            ((storeProv.store.close ?? 0) -
                                                (storeProv.store.open ?? 0)),
                                        width: dayWidth,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                      )
                                    ])
                              ]
                            ])
                          ]),
                          const SizedBox(height: 1,)
                        ]);
                      })),
            ]));
      });
    });
  }
}
