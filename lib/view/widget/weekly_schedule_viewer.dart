import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/util/app_color.dart';
import 'package:sidam_employee/view_model/weekly_schedule_view_model.dart';

import '../../model/store.dart';

class WeeklyScheduleViewer extends StatefulWidget {
  const WeeklyScheduleViewer({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<WeeklyScheduleViewer> {
  AppColor color = AppColor();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Consumer<WeeklyScheduleViewModel>(builder: (context, state, child) {

      if (state.store.id == null || state.store.id == 0) {
        state.getStore();
      }
      double boxWidth = 1260;
      double blockHeight = 40;
      double tableHeight = deviceHeight - 300;

      return SizedBox(
          height: deviceHeight - 2,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Stack(children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                            width: deviceWidth,
                            height: 50,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(onPressed: () {
                                    setState(() {
                                      state.before();
                                    });
                                  }, icon: SvgPicture.asset('assets/icons/chevron-left.svg')),

                                  Text(
                                    '${DateFormat('M월 d일').format(state.thisWeek)} - '
                                        '${DateFormat('M월 d일').format(state.thisWeek.add(const Duration(days: 7)))}',
                                    style: const TextStyle(fontSize: 16),
                                  ),

                                  IconButton(onPressed: () {
                                    setState(() {
                                      state.after();
                                    });
                                  }, icon: SvgPicture.asset('assets/icons/chevron-right.svg')),
                                ])
                        )
                    ),

                    Positioned(
                      top: 0,
                      right: 5,
                      child: IconButton(
                          onPressed: () {
                            state.renew();
                          },
                          icon: const Icon(
                            Icons.cached,
                            color: Colors.black54,
                          )),
                    )
                  ])),
              SizedBox(
                  height: deviceHeight - 200,
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          //color: Colors.green,
                            height: tableHeight + 50,
                            width: 50,
                            child: Column(children:[
                              const SizedBox(height: 40,),
                              timeBuilder(blockHeight, tableHeight, state.store),
                            ])),
                        Container(
                          //color: Colors.blue,
                            height: tableHeight + 50,
                            width: deviceWidth - 50,//state.weekly.isEmpty ? deviceWidth + 1000 : state.weekly.length * 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                itemCount: 7,
                                itemBuilder: (context, idx) {
                                  return dailyTimeTable(
                                      blockHeight, tableHeight, state.store,
                                      state.thisWeek.add(Duration(days: idx)),
                                      boxWidth
                                  );
                                }
                            )
                        )
                      ])
              )
            ],
          ));
    });
  }

  Widget timeBuilder(double blockHeight, double deviceHeight, Store store) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
      child: SizedBox(
        width: 50,
        height: deviceHeight,
        child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: ((store.close ?? 0) - (store.open ?? 0)) < 0 ? 0
                : (store.close ?? 0) - (store.open ?? 0),
            itemBuilder: (context, idx) {
              return SizedBox(
                  width: double.infinity,
                  height: blockHeight + 2,
                  child: Center(child: Text(
                    '${idx + (store.open ?? 0)}:00',
                    style: TextStyle(fontSize: 16, ),
                  ),)
              );
            }),
      ),
    );
  }

  Widget dailyTimeTable(double blockHeight, double deviceHeight, Store store, DateTime thisDay, double boxWidth) {
    double blockWidth = (boxWidth / 7) < 20 ? 20 : boxWidth / 7;
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    return Consumer<WeeklyScheduleViewModel>(
        builder: (context, schedule, child) {

          double width = schedule.weekly[thisDay] == null ? blockWidth
              : schedule.weekly[thisDay]!.length * 40;

          if (width < 40) {
            width = 40;
          }
          return Column(children:[
            SizedBox(
              height: 20,
              child: Center(
                  child: Text('${week[thisDay.weekday]}요일')
              ),
            ),
            SizedBox(
              height: 20,
              child: Center(
                child: Text('(${DateFormat('d일').format(thisDay)})',
                  style: TextStyle(fontSize: 13, color: Colors.black38),),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              child: SizedBox(
                width: width,
                height: deviceHeight,
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: ((store.close ?? 0) - (store.open ?? 0)) < 0 ? 0
                        : (store.close ?? 0) - (store.open ?? 0),
                    itemBuilder: (context, idx) {
                      int before = idx - 1 < 0 ? 12 : idx - 1;

                      return SizedBox(
                          width: double.infinity,
                          height: blockHeight + 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                schedule.weekly.isEmpty || schedule.weekly[thisDay] == null || schedule.weekly[thisDay]!.isEmpty
                                    ? Container(
                                  width: width,
                                  height: blockHeight,
                                  color: Colors.black12,
                                ) :
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for(int i = 0; i < (schedule.weekly[thisDay]?.length ?? 0); i++)...[
                                        Container(
                                          alignment: Alignment.center,
                                          height: blockHeight,
                                          width: 40/*(width / (schedule.weekly[thisDay] == null ? 1 : schedule.weekly[thisDay]!.length)) < 15
                                          ? 15
                                          : width / (schedule.weekly[thisDay] == null ? 1 : schedule.weekly[thisDay]!.length)*/,

                                          color: schedule.weekly[thisDay]![i].time[idx]
                                              ? Color(int.parse(schedule.weekly[thisDay]![i].worker.color ?? '0xFFFFFFFF'))
                                              : Colors.black12,

                                          child: Center(child:
                                          Text(schedule.weekly[thisDay]![i].time[idx] && !schedule.weekly[thisDay]![i].time[before]
                                              ? schedule.weekly[thisDay]![i].worker.alias ?? ''
                                              : '',
                                            style: const TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      ],
                                    ]
                                )]
                          )
                      );
                    }),
              ),
            )]);
        });
  }
}
