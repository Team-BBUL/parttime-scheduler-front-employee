import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sidam_employee/view/chatting.dart';
import 'package:sidam_employee/view/cost.dart';
import 'package:sidam_employee/view/cost_page.dart';
import 'package:sidam_employee/view/home.dart';
import 'package:sidam_employee/view/time_table.dart';

import 'data/model/appColor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sidam Worker App',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF89B3),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sidam Worker App'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final AppColor color = AppColor();

  int _currentIndex = 0;
  final List<Widget> _children = [HomeScreen(), TimeTableScreen(),CostPage(), ChattingScreen()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: color.mainColor,
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home, color: Colors.black),
              label: "Home",
              activeIcon: Column(
                children: <Widget>[
                  Icon(Icons.home, color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('asset/icons/table_icon.svg'),
              label: "Time Table",
              activeIcon: Column(
                children: <Widget>[
                  SvgPicture.asset('asset/icons/table_icon.svg', color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('asset/icons/dollar_sign_icon.svg'),
              label: "Cost",
              activeIcon: Column(
                children: <Widget>[
                  SvgPicture.asset('asset/icons/dollar_sign_icon.svg', color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('asset/icons/message_square_icon.svg'),
              label: "Chatting",
              activeIcon: Column(
                children: <Widget>[
                  SvgPicture.asset('asset/icons/message_square_icon.svg', color: color.mainColor),
                  Container(
                    height: 4,
                    width: 24,
                    color: color.mainColor,
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}