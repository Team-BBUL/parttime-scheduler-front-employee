import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/viewModel/store_view_model.dart';
import 'package:sidam_worker/viewModel/work_swap_view_model.dart';

class ResultViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PassFailState();
}

class _PassFailState extends State<ResultViewer> {
  final _designWidth = 411;
  final _designHeight = 683;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double textSize = 22.0 * deviceWidth / _designWidth;

    return Container(
      color: Colors.white,
      width: deviceWidth,
      height: deviceHeight,
      child: Consumer<WorkSwapViewModel>(
        builder: (context, prov, child) {
          return Container(
              margin: EdgeInsets.only(
                  left: 50 * deviceWidth / _designWidth,
                  right: 50 * deviceWidth / _designWidth),
              alignment: Alignment.center,
              width: 300 * deviceWidth / _designWidth,
              height: 300 * deviceHeight / _designHeight,
              child: prov.result
                  ? changeResultViewer()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          const Icon(
                            Icons.warning,
                            color: Color(0xFFf3cf2e),
                            size: 50,
                          ),
                          Text(
                            '근무 교환 신청이 실패했습니다.\n창을 닫고 다시 시도해주세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textSize,
                            ),
                          ),
                        ]));
        },
      ),
    );
  }

  Widget changeResultViewer() {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double textSize = 17 * deviceWidth / _designWidth;

    return Consumer<StoreViewModel>(builder: (context, storeProv, child) {
      return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            'assets/icons/check.svg',
            color: Colors.green,
            width: 40,
            height: 40,
          ),
          RichText(
            textAlign: TextAlign.center,
            strutStyle: const StrutStyle(fontSize: 25),
            text: TextSpan(
                text: '당신의 ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textSize,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${week[prov.mySchedule!.day.weekday]}요일'
                        '(${prov.mySchedule!.day.day}일) '
                        '${(storeProv.store.open ?? 0) + prov.findStartTime(prov.mySchedule!)}:00 - '
                        '${(storeProv.store.open ?? 0) + prov.findStartTime(prov.mySchedule!) + prov.calculateTime(prov.mySchedule!)}:00 근무',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: textSize,
                    ),
                  ),
                  TextSpan(
                      text: '를\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textSize,
                      )),
                  TextSpan(
                      text: '${prov.name}님의 ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: textSize,
                      )),
                  TextSpan(
                      text: '${week[prov.target!.day.weekday]}요일'
                          '(${prov.target!.day.day}일) '
                          '${(storeProv.store.open ?? 0) + prov.findStartTime(prov.target!)}:00 - '
                          '${(storeProv.store.open ?? 0) + prov.findStartTime(prov.target!) + prov.calculateTime(prov.target!)}:00 근무',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: textSize,
                      )),
                  TextSpan(
                      text: '와 교환하는 요청에 성공했습니다.\n진행 상황은 알림 탭에서 확인해주세요!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textSize,
                      )),
                ]),
          )
        ]);
      });
    });
  }
}
