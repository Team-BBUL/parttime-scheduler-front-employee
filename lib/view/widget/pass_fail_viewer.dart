import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/util/app_color.dart';
import 'package:sidam_employee/view_model/selected_store_info_view_model.dart';
import 'package:sidam_employee/view_model/work_swap_view_model.dart';

class ResultViewer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PassFailState();
}

class _PassFailState extends State<ResultViewer> {
  final _designWidth = 411;
  final _designHeight = 683;

  final AppColor _color = AppColor();

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
                  ? (prov.targeting
                      ? changeResultViewer()
                      : nonTargetResult())
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

    double textSize = 20;

    return Consumer<SelectedStore>(builder: (context, storeProv, child) {
      return Consumer<WorkSwapViewModel>(builder: (context, prov, child) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            'assets/icons/check.svg',
            color: Colors.green,
            width: 40,
            height: 40,
          ),
            const SizedBox(height: 10,),

            Row(children: [
              Text(' 당신의', style: TextStyle(fontSize: textSize - 3),
              ),
              const SizedBox(width: 10,),
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  color: _color.whiterColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                    child: Text('${week[prov.mySchedule!.day.weekday]}요일'
                        '(${prov.mySchedule!.day.day}일)\n'
                        '${(storeProv.storeInfo.open ?? 0) + prov.findStartTime(prov.mySchedule!)}:00 - '
                        '${(storeProv.storeInfo.open ?? 0) + prov.findStartTime(prov.mySchedule!) + prov.calculateTime(prov.mySchedule!)}:00 근무',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: textSize),
                    )
                ),
              ),
            ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            const SizedBox(height: 10,),
            SvgPicture.asset('assets/icons/trade_bigger.svg', width: 30, height: 30,),
            const SizedBox(height: 10,),

            Row(children: [
              Text('${prov.name}님의', style: TextStyle(fontSize: textSize - 3),),
              const SizedBox(width: 10,),
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFA9D330),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '${week[prov.target!.day.weekday]}요일(${prov.target!.day.day}일)\n'
                        '${(storeProv.storeInfo.open ?? 0) + prov.findStartTime(prov.target!)}:00 - '
                        '${(storeProv.storeInfo.open ?? 0) + prov.findStartTime(prov.target!) + prov.calculateTime(prov.target!)}:00 근무',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize),
                  ),
                ),
              )
            ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),

          const SizedBox(height: 20,),
          Text('교환 요청 성공!')
        ]);
      });
    });
  }

  Widget nonTargetResult() {
    var week = ['error', '월', '화', '수', '목', '금', '토', '일'];

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    double textSize = 17 * deviceWidth / _designWidth;

    return Consumer<SelectedStore>(builder: (context, storeProv, child) {
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
                  text: '당신이 ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: textSize,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${week[prov.mySchedule!.day.weekday]}요일'
                          '(${prov.mySchedule!.day.day}일) '
                          '${(storeProv.storeInfo.open ?? 0) + prov.findStartTime(prov.mySchedule!)}:00 - '
                          '${(storeProv.storeInfo.open ?? 0) + prov.findStartTime(prov.mySchedule!) + prov.calculateTime(prov.mySchedule!)}:00 근무',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: textSize,
                      ),
                    ),
                    TextSpan(
                      text: '를 하지 못한다고 사장님에게 알렸어요.\n진행 상황은 알림 탭에서 확인해주세요!'
                    )
                  ]))
        ]);
      });
    });
  }
}
