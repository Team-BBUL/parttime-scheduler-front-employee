import 'package:flutter/material.dart';
import 'package:sidam_worker/model/notice_model.dart';

class NoticeView extends StatefulWidget{

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<NoticeView> {

  final _designWidth = 360;
  final _designHeight = 683;
  List<Notice> noticeList = [];

  @override
  void initState() {
    super.initState();

    // api 요청, 공지사항 정보 받아오기
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    // 크기 관련 변수 설정
    final fontSize = deviceWidth * 17 / _designWidth;
    final indent = deviceWidth * 10 / _designWidth;
    final padding = deviceHeight * 10 / _designHeight;

    return Scaffold(
      // 상단 (뒤로가기) (페이지 이름) 탭바
      appBar: AppBar(
        title: const Text("공지사항"),
        titleTextStyle: TextStyle(fontSize: fontSize, color: Colors.black87),
        centerTitle: true,
      ),
      // 하단 내용
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(bottom: padding)),
          // 상단 탭바와 내용 사이의 간격

          // 반복문을 통해 notice 객체를 위젯으로 반환
          for (var n in noticeList)
            Column(
              children: [
                Row(
                  children: [
                    // 안 읽음 표시
                    noticeBuilder(n.getTitle(), 40),
                  ]
                ),
                Divider( // 구분자
                  indent: indent,
                  endIndent: indent,
                )
              ],
            )

        ],
      )
    );
  }

  Widget noticeBuilder(String title, double height) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: EdgeInsets.only(top: height / 4.5),
            height: height,
            child: Text(title, style: const TextStyle(fontSize: 15),)
          );
        }
    );
  }
}