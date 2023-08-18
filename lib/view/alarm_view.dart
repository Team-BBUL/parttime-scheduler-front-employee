import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:sidam_worker/api/alarm_http_provider.dart';
import 'package:sidam_worker/model/AlarmModel.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/model/appColor.dart';
import 'package:sidam_worker/viewModel/alarm_view_model.dart';

class AlarmView extends StatefulWidget{

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<AlarmView> {

  var logger = Logger();

  final _designWidth = 411;
  final _designHeight = 683;
  final _myId = 7;

  AppColor color = AppColor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // 크기 관련 변수 설정
    final fontSize = deviceWidth * 16 / _designWidth;
    final indent = 15.0; //deviceWidth * 20 / _designWidth;
    final iconSize = deviceHeight * 40 / _designHeight;

    // 변경이 생기면 provider를 호출하는 위젯
    return ChangeNotifierProvider<AlarmHttpProvider>(
      create: (_) => AlarmHttpProvider()..started(),
      child: Consumer<AlarmHttpProvider>(builder: (context, state, child) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton( // 새로고침 버튼
                    onPressed: () {
                      state.renewData();

                      if (scrollController.hasClients){
                        scrollController.jumpTo(0);
                      }
                    },
                    icon: SvgPicture.asset("assets/icons/rotate-cw.svg", width: iconSize / 2,)
                ),
              ],
            ),
          // 특정 이벤트가 생기면 이를 처리하는 위젯
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              state.scrollListener(scrollController);
              return false;
            },
            child: state.alarms.isEmpty ?
            // SizedBox 알림이 없거나 서버에 연결이 불가능할 때 뜸
            // (기타 이유로 데이터 로딩이 실패해서 alarm 데이터가 없어도 뜸
              SizedBox(
                height: deviceHeight,
                width: deviceWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      SvgPicture.asset("assets/icons/loader.svg", color: Colors.black54,),
                      Text("알림이 없어요!", style: TextStyle(fontSize: fontSize),),
                    ])
              ) :
            // ListView.builder 목록 뷰를 만들어줌. 스크롤 컨트롤러를 사용하기 위해선 builder로 생성해야 함
              ListView.builder(
                controller: scrollController,
                // 콘텐츠가 짧아도 스크롤을 생성하기 위한 물리 설정
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: state.alarms.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        if (state.alarms[index].valid)
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Column( children: [
                              alarmBuilder(state.alarms[index], deviceWidth),
                              Divider(indent: indent, endIndent: indent, color: Colors.grey,),
                            ])
                        ),

                        if (state.alarms.length - 1 == index && state.done) ...[
                          const SizedBox(
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF89B3),
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  );
                })
            ),
          ),
        );
      },),
    );
  }

  // 알림 객체를 이용해 내용을 생성, 위젯을 반환하는 메소드
  Widget alarmBuilder(Alarm alarm, double width) {

    AlarmViewModel alarmVM = AlarmViewModel();

    return Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        width: width,
        child: Column(
            children:[
              Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column( // 내용, 날짜를 생성하는 부분
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( children: [
                        !alarm.read ?
                              Row(children: const [
                                Icon(Icons.circle, size: 5, color: Colors.red,),
                                SizedBox(width: 5,)
                              ])
                            : const SizedBox(),
                        SizedBox(width: 260 * width / _designWidth, child: alarmTextBuilder(alarm),)
                      ]),
                      Text(
                        DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(alarm.date),
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),

                  // 알림의 종류가 교환이고 점주와 근무자가 모두 수락했다면
                  if (alarm.type == "CHANGE" && alarm.request?.own == "PASS" && alarm.request?.res == "PASS")
                    Row( children:[
                      // 알림 승낙
                      SvgPicture.asset('assets/icons/accept.svg'),
                      // 알림 삭제 버튼
                      IconButton(onPressed: (){
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context) {
                          return deleteCheckPopup(alarm);
                        });
                      }, icon: const Icon(Icons.close, color: Colors.grey,))
                    ])

                    // 알림의 종류가 교환이고 점주와 근무자 둘 중 하나라도 거절했다면
                  else if (alarm.type == "CHANGE" && (alarm.request?.own == "FAIL" || alarm.request?.res == "FAIL"))
                    Row( children:[
                      // 알림 거절
                      SvgPicture.asset('assets/icons/denial.svg'),
                      // 알림 삭제 버튼
                      IconButton(onPressed: (){
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context) {
                          return deleteCheckPopup(alarm);
                        });
                      }, icon: const Icon(Icons.close, color: Colors.grey,))
                    ])

                    // 알림의 종류가 교환이고 아직 확정나지 않은 상태 (둘 모두가 non or 둘 중 하나는 non, 하나는 pass)
                  else if (alarm.type == "CHANGE")
                    // 알림 응답대기
                    SvgPicture.asset('assets/icons/non.svg')

                      // 알림의 종류가 교환이 아닐 경우
                    else
                      // 알림 삭제 버튼
                      IconButton(onPressed: (){
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context) {
                          return deleteCheckPopup(alarm); // popup을 띄워서 확인
                        });
                      }, icon: const Icon(Icons.close, color: Colors.grey,))
                ]
              ),

              // 교환 알림이고 대상일 경우, 수락/거절 버튼을 표시
              if (alarm.type == "CHANGE" && alarm.request?.res == "NON"
                  && alarm.request?.receiver?.id == _myId) ...[
                const SizedBox(height: 5,),
                Row(
                  //mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        height: 30,
                        width: 100,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green.shade400,
                              primary: Colors.white,
                              padding: EdgeInsets.zero
                            ),
                            onPressed: () async {
                              Future<bool> check = alarmVM.answerAlarm("change", true, alarm.id);
                              check.then((value) {
                                setState(() {
                                  alarm.request?.res = "PASS";
                                });
                              }).catchError((error){
                                logger.e(error);
                              });
                            },
                            child: const Text("수락", style: TextStyle(fontSize: 11),)
                        )
                    ),
                    SizedBox(
                        width: 100,
                        height: 30,
                        child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          primary: Colors.white,
                          padding: EdgeInsets.zero
                        ),
                        onPressed: () async {
                          Future<bool> check = alarmVM.answerAlarm("change", false, alarm.id);
                          check.then((value) {
                            setState(() {
                              alarm.request?.res = "FAIL";
                            });
                          }).catchError((error) {
                            logger.e(error);
                          });
                          // api 요청 -> 알림 거절
                        },
                        child: const Text("거절", style: TextStyle(fontSize: 11),)
                    )),
                  ],
                )
              ]
            ]
        )
    );
  }

  Widget deleteCheckPopup(Alarm alarm) {

    AlarmViewModel alarmVM = AlarmViewModel();

    return AlertDialog(
      backgroundColor: Colors.white,
      content: const Text("알림은 삭제하면 복구할 수 없습니다.\n정말 삭제하시겠습니까?"),
      insetPadding: const EdgeInsets.all(10),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(); // popup 화면 삭제

          alarmVM.deleteAlarm(alarm.id); // 알림 삭제 api 호출
          setState(() {
            alarm.valid = false; // 화면 상에서 해당 알림 삭제
          });
        }, child: const Text('확인', style: TextStyle(color: Colors.black87),)
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text('취소', style: TextStyle(color: Colors.black87),)
        )
      ],
    );
  }

  // 서버 오류 뷰잉 위젯
  Widget errorDialog(String error) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("서버 오류"),
      content: Text(error),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text("확인", style: TextStyle(color: Colors.black87),))
      ],
    );
  }

  // 알림 내용으로 작성될 내용을 빌드하는 메소드
  Widget alarmTextBuilder(Alarm alarm) {

    late String editType = "";

    if (alarm.state == "ADD") { editType = "작성"; }
    else if (alarm.state == "UPDATE") { editType = "수정"; }
    else if (alarm.state == "DELETE") { editType = "삭제"; }

    if (alarm.type == "NOTICE") {
      return Text('"${alarm.content}" 공지사항이 $editType되었습니다!');
    }

    if (alarm.type == "SCHEDULE") {
      return Text('${alarm.content}의 근무표가 $editType되었습니다!');
    }

    if (alarm.type == "CHANGE") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _myId == alarm.request?.requester.id ?
              const Text("당신의 변경 요청!") : Text("${alarm.request?.requester.alias} 님의 교환 요청!"),

          // request.old를 id로 스케줄을 조회해 바꾸려는 시간 가져오기
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: _myId != alarm.request?.requester.id ?
                Text('${alarm.request?.requester.alias}의 ${alarm.request?.oldText} 근무') :
                Text('당신의 ${alarm.request?.oldText} 근무')
          ),

          alarm.request?.receiver != null ?
          // request.target를 id로 스케줄을 조회해 바꾸려는 시간 가져오기
              Column(children:[
                const Text("|"),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: _myId != alarm.request?.receiver?.id ?
                    Text('${alarm.request?.receiver!.alias}의 ${alarm.request?.targetText} 근무') :
                    Text('당신의 ${alarm.request?.targetText} 근무'),
                )
              ]) : const SizedBox()
        ],
      );
    }
    return const Text("alarm formatting error");
  }
}