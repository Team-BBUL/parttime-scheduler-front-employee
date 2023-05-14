import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sidam_worker/model/appColor.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late final String _userName; // 접속 중인 사용자의 이름 UserRole:alias
  late final String _storeName; // store:name
  String annoTitle = "공지 제목"; // anno

  AppColor color = AppColor();

  late final double _annoHeight;
  late final double _newPad;

  @override
  void initState() {
    super.initState();
    // 여기서 데이터 가져와야

    _userName = "000님"; // userName 가져오기 (json)

    _storeName = "가게이름"; // storeName 가져오기 (json)

    // _annoTitle 가져오기 (api)

    // 크기 관련 변수 지정
    _annoHeight = 40;
    _newPad = 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_storeName),
        centerTitle: true,
        leading: Center(
            child: Text(_userName)
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: SvgPicture.asset('asset/icons/bell_icon.svg'),
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.settings),
          )
        ],
      ),

      body: Center(
        child: Column(
          children: <Widget> [
            announceWidget(),
          ],
        ),
      )
    );
  }

  Widget announceWidget() {
    return Container(
        height: _annoHeight,
        color: color.mainColor,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
              ),
              SizedBox(width: _newPad),
              Text(annoTitle),
            ]
        )
    );
  }
}