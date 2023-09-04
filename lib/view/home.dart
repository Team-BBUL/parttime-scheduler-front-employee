import "package:flutter/material.dart";
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:sidam_worker/util/shared_preference_provider.dart';
import 'package:sidam_worker/view/widget/main_cost.dart';
import 'package:sidam_worker/view/widget/my_schedule_viewer.dart';
import 'package:sidam_worker/view_model/notice_view_model.dart';
import 'package:sidam_worker/view_model/schedule_view_model.dart';

import 'package:sidam_worker/view/announcement_page.dart';
import 'package:sidam_worker/view/unworkable_schedule_page.dart';
import 'package:sidam_worker/view/setting.dart';

import '../util/appColor.dart';
import '../util/sp_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // models
  String _storeName = '';
  String _userAlias = '';

  // design constant
  final _designWidth = 411;
  final _designHeight = 683;

  AppColor color = AppColor();
  SPHelper helper = SPHelper();

  late double _newPad;

  // etc
  Logger logger = Logger();

  void loadSPProvider() async {

    final provider = Provider.of<SharedPreferencesProvider>(context);

    String storeName = await provider.getStoreName();
    String userAlias = await provider.getAlias();

    setState(() {
      _storeName = storeName;
      _userAlias = userAlias;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadSPProvider();

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
          title: Text(
            _storeName,
            style: TextStyle(fontSize: storeFontSize),
          ),
          centerTitle: true,
          leading: Center(
              child: Text(
                _userAlias,
            style: TextStyle(fontSize: nameFontSize),
          )),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) => SettingScreen(),
                ));
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              announceWidget(),
              const MonthlyCost(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => const UnworkableSchedulePage()
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    foregroundColor: color.mainColor,
                    backgroundColor: color.moreWhiterColor,
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                  ),
                  child: const Text(
                    '스케줄 희망 편성',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ]),
              timetableWidget(deviceWidth, deviceHeight, now),
            ],
          ),
        ));
  }

  Widget announceWidget() {
    return Container(
        height: 50,
        color: color.mainColor,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => AnnouncementPage(),),
            );
          },
          child: Consumer<NoticeViewModel>(builder: (context, prov, child) {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (!prov.lastNotice.read
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: _newPad, right: _newPad),
                            child: const Text(
                              'new',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ))
                      : const Text("")),
                  SizedBox(width: _newPad),
                  Text(
                    prov.lastNotice.title,
                    style: const TextStyle(fontSize: 17),
                  ),
                ]);
          }),
        ));
  }

  Widget timetableWidget(
      double deviceWidth, double deviceHeight, DateTime now) {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    // 맨좌우 여백 10, 각 시간 블록 사이 여백 5씩
    double scheduleHeight = 290 * deviceHeight / _designHeight;

    return Container(
        width: deviceWidth,
        height: scheduleHeight + 90,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: color.mainColor,
                spreadRadius: 0,
                blurRadius: 5.0,
                offset: const Offset(0, -5),
              )
            ]),
        child: Consumer<ScheduleViewModel>(builder: (context, prov, child) {
          return Column(
            children: [
              const SizedBox(height: 3),
              SizedBox(
                  width: deviceWidth,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 50,
                          height: 1,
                        ),
                        Column(children: [
                          const Text(
                            "이번주 근무",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "${now.month}월 ${now.day}일 ${week[now.weekday]}요일",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ]),
                        IconButton(
                            onPressed: () {
                              prov.renew();
                            },
                            icon: const Icon(
                              Icons.autorenew,
                              color: Colors.black38,
                              size: 25,
                            )),
                      ])),
              ScheduleViewer(),
            ],
          );
        }));
  }
}