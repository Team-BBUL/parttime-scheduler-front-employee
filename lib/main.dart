import 'package:flutter/material.dart';
import 'package:sidam_employee/view/chatting.dart';
import 'package:sidam_employee/view/cost.dart';
import 'package:sidam_employee/view/cost_page.dart';
import 'package:sidam_employee/view/home.dart';
import 'package:sidam_employee/view/schedule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyStatefulWidget(),

    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ScheduleScreen(),
    CostPage(),
    ChattingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.transparent;
    return Scaffold(

      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Schedule',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Cost',
            backgroundColor: color,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatting',
            backgroundColor: color,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}