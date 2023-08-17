import 'package:flutter/material.dart';
import 'package:sidam_employee/view/announcement_page.dart';
import 'package:sidam_employee/view/store_list.dart';
import 'package:sidam_employee/view/store_list_page.dart';
import 'package:sidam_employee/view/unworkable_schedule_page.dart';
import 'package:sidam_employee/view/setting.dart';

import '../util/appColor.dart';
import '../util/sp_helper.dart';


class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen>{
  final SPHelper helper = SPHelper();

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
    int? id = helper.getStoreId();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading:  TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) => SettingScreen(),
            ));
          },
          child: Text('${helper.getAlias()}', style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        title: TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => StoreListPage(),
              ));
            },
            child: Text("${helper.getStoreName()}", style: TextStyle(color: Colors.black, fontSize: 16))
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => SettingScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],

      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: <Widget> [
                announceWidget(),
                Container(
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) => const UnworkableSchedulePage()
                        ));
                      },
                    )
                )
              ],
            ),
          ),
        ],
      ),
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
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementPage(),
                          ),
                        );
                      },
                      child: Text(
                        annoTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ]
            ),
    );
  }
}