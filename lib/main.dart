import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/data/repository/store_repository.dart';
import 'package:sidam_worker/view/cost_page.dart';

import 'package:sidam_worker/view_model/monthly_cost_view_model.dart';
import 'package:sidam_worker/view_model/notice_view_model.dart';
import 'package:sidam_worker/view_model/schedule_view_model.dart';
import 'package:sidam_worker/view_model/store_view_model.dart';
import 'package:sidam_worker/view_model/user_view_model.dart';
import 'package:sidam_worker/view_model/work_swap_view_model.dart';
import 'package:sidam_worker/view_model/announcement_view_model.dart';
import 'package:sidam_worker/view_model/selected_store_info_view_model.dart';

import 'package:sidam_worker/view/alarm_view.dart';
import 'package:sidam_worker/view/home.dart';
import 'package:sidam_worker/view/time_table_view.dart';
import 'package:sidam_worker/view/check_login.dart';

import 'package:sidam_worker/util/shared_preference_provider.dart';
import 'package:sidam_worker/util/appColor.dart';

import 'data/repository/announcement_repository.dart';

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
              create: (context) => StoreViewModel(StoreRepositoryImpl())
          ),
          ChangeNotifierProvider(
              create: (context) => MonthlyCostViewModel()
          ),
          ChangeNotifierProvider(
              create: (context) => WorkSwapViewModel()
          ),
          ChangeNotifierProvider(
            create: (_) => AnnouncementViewModel(AnnouncementRepositoryImpl()),
          ),
          ChangeNotifierProvider(
              create: (context) => SelectedStore()
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
      home: CheckLoginScreen(),
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
  final List<Widget> _children = [Home(), TimeTable(), CostPage(), AlarmView()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<SharedPreferencesProvider>(context);
    //provider.debugSetup();

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
