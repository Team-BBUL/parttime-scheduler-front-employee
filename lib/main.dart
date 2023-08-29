import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/utility/shared_preference_provider.dart';
import 'package:sidam_worker/utility/sp_helper.dart';
import 'package:sidam_worker/viewModel/cost_view_model.dart';
import 'package:sidam_worker/viewModel/notice_view_model.dart';
import 'package:sidam_worker/viewModel/schedule_view_model.dart';
import 'package:sidam_worker/viewModel/store_view_model.dart';
import 'package:sidam_worker/viewModel/user_view_model.dart';

import 'package:sidam_worker/view/alarm_view.dart';
import 'package:sidam_worker/view/home.dart';
import 'package:sidam_worker/view/cost_view.dart';
import 'package:sidam_worker/view/time_table_view.dart';

import 'package:sidam_worker/model/appColor.dart';
import 'package:sidam_worker/viewModel/work_swap_view_model.dart';

void main() {
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => SharedPreferencesProvider()
          ),
          ChangeNotifierProvider(
              create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider(
              create: (context) => ScheduleViewModel()
          ),
          ChangeNotifierProvider(
              create: (context) => NoticeViewModel()
          ),
          ChangeNotifierProvider(
              create: (context) => StoreViewModel()
          ),
          ChangeNotifierProvider(
              create: (context) => CostViewModel()
          ),
          ChangeNotifierProvider(
              create: (context) => WorkSwapViewModel()
          ),
        ],
        child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final Logger _logger = Logger();

  int _currentIndex = 0;
  final List<Widget> _children = [Home(), TimeTable(), Cost(), AlarmView()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<SharedPreferencesProvider>(context);
    provider.debugSetup();

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
            icon: SvgPicture.asset('assets/icons/table_icon.svg'),
            label: "Time Table",
            activeIcon: Column(
              children: <Widget>[
                SvgPicture.asset('assets/icons/table_icon.svg', color: color.mainColor),
                Container(
                  height: 4,
                  width: 24,
                  color: color.mainColor,
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/dollar_sign_icon.svg'),
            label: "Cost",
            activeIcon: Column(
              children: <Widget>[
                SvgPicture.asset('assets/icons/dollar_sign_icon.svg', color: color.mainColor),
                Container(
                  height: 4,
                  width: 24,
                  color: color.mainColor,
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/bell_icon.svg'),
            label: "Alarm",
            activeIcon: Column(
              children: <Widget>[
                SvgPicture.asset('assets/icons/bell_icon.svg', color: color.mainColor),
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
