import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:sidam_worker/model/appColor.dart';
import 'package:sidam_worker/model/scheduleModel.dart';
import 'package:sidam_worker/model/storeModel.dart';
import 'package:sidam_worker/provider/userProvider.dart';
import 'package:sidam_worker/view/alarmView.dart';
import 'package:sidam_worker/view/noticeView.dart';
import 'package:sidam_worker/viewModel/noticeViewModel.dart';
import 'package:sidam_worker/viewModel/scheduleViewModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // models
  late String _storeName; // store:name
  String _annoTitle = "공지사항이 없습니다"; // annotation title
  late bool _noticeCheck = false;

  List<Schedule> weeklySchedule = [];
  Store store = Store(
      id: 0,
      name: '',
      open: 0,
      close: 0,
      deadline: 1,
      location: '',
      phone: '',
      week: 1
  );

  // design constant
  final _designWidth = 411;
  final _designHeight = 683;

  AppColor color = AppColor();

  late double _newPad;

  // etc
  Logger logger = Logger();

  var noticeVM = NoticeViewModel();

  @override
  void initState() {
    super.initState();
    // 여기서 데이터 가져와야?

    _storeName = ""; // storeName 가져오기 (json)

    Store.loadStore().then((value) {
      store = value;
      setState(() {
        _storeName = value.name;
      });
    })
    .catchError((error) {
      logger.e(error);
    });

    noticeVM.loadTitle().then((value) {
      setState(() {
        _annoTitle = value.title;
        _noticeCheck = value.read;
      });
    }).catchError((error){
      _annoTitle = "-";
      _noticeCheck = false;
      logger.e(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // x : y = w : t  ->  x = y * w / t
    // 크기 관련 변수 지정
    _newPad = deviceWidth * 4 / deviceWidth;
    final storeFontSize = deviceWidth * 20 / _designWidth;
    final nameFontSize = deviceWidth * 13 / _designWidth;

    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(_storeName, style: TextStyle(fontSize: storeFontSize),),
        centerTitle: true,
        leading: Center(
            child: Consumer<UserProvider> (
              builder: (context, userProvider, child) {
                final user = userProvider.user;
                return Text(user != null ? user.name : "사용자", style: TextStyle(fontSize: nameFontSize),);
              },
            )
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.settings),
          )
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            announceWidget(),
            timetableWidget(deviceWidth, deviceHeight, now),
          ],
        ),
      )
    );
  }

  Widget announceWidget() {
    return Container(
        height: 50,
        color: color.mainColor,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeView()));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (!_noticeCheck ? Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: _newPad, right: _newPad),
                    child: const Text(
                      'new',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
              ) : const Text("")),
              SizedBox(width: _newPad),
              Text(_annoTitle, style: const TextStyle(fontSize: 17),),
            ]
          ),
        )
    );
  }

  Widget timetableWidget(double deviceWidth, double deviceHeight, DateTime now) {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    double timeWidth = 45;
    // 맨좌우 여백 10, 각 시간 블록 사이 여백 5씩
    double dayWidth = (deviceWidth - timeWidth - 10 - 20) / 8;
    double scheduleHeight = 270 * deviceHeight / _designHeight;
    var cnt = store.close - store.open;


    ScheduleViewModel scheduleVM = ScheduleViewModel();
    scheduleVM.loadMySchedule(now)
        .then((value) {
          weeklySchedule = value;
        });

    return Container(
      width: deviceWidth,
      height: scheduleHeight + 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: color.mainColor,
            spreadRadius: 0,
            blurRadius: 5.0,
            offset: const Offset(0, -10),
        )]
      ),
      child: Column(
        children: [
          const SizedBox(height: 3),
          const Text("이번주 근무", style: TextStyle(fontSize: 15),),
          Text("${now.month}월 ${now.day}일 ${week[now.weekday]}요일", style: const TextStyle(fontSize: 20),),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Row(
                  children: [
                    // 시간을 띄우는 부분
                    SizedBox(
                      width: timeWidth,
                      height: scheduleHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('\n', style: TextStyle(fontSize: 11),),
                          for(int i = store.open; i < store.close; i++)
                            Text('$i:00',
                              style: TextStyle(fontSize: 12 * deviceHeight / _designHeight),
                            )
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
                                RichText(
                                  text: TextSpan(
                                    text: '${weeklySchedule.isNotEmpty?
                                      weeklySchedule[i].day.day : 0}일\n${week[i + 1]}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: // 오늘에 포인트 주기
                                        DateFormat.yMd().format(DateTime.now()) ==
                                            DateFormat.yMd().format(weeklySchedule.isNotEmpty?
                                            weeklySchedule[i].day : DateTime.parse('2023-01-01')) ?
                                        Colors.red : Colors.black,
                                      fontWeight:
                                        DateFormat.yMd().format(DateTime.now()) ==
                                            DateFormat.yMd().format(weeklySchedule.isNotEmpty?
                                            weeklySchedule[i].day : DateTime.parse('2023-01-01')) ?
                                        FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),

                                  textAlign: TextAlign.center,
                                ),
                                for (int j = 0; j < (store.close - store.open); j++) ...[
                                  Container(
                                    color: weeklySchedule.isNotEmpty
                                        && weeklySchedule[i].time.isNotEmpty
                                        && weeklySchedule[i].time[j]
                                        ? color.mainColor : Colors.black12,
                                    height: 15 * deviceHeight / _designHeight,
                                    width: dayWidth,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                  )
                                ]
                              ]
                          )
                      )
                    ]
                  ]
              )
          ),
        ],
      ),
    );
  }
}