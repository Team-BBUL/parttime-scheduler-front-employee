import 'package:flutter/material.dart';
import 'package:sidam_employee/view/announcement.dart';
import 'package:sidam_employee/view/announcement_page.dart';
import 'package:sidam_employee/view/setting.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: <Widget>[
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
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AnnouncementPage()
                ));
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: TextButton(
              child: const Text("매장정보설정"),
              onPressed: () {
/*                Navigator.push(context, MaterialPageRoute<void>(
                    builder: (BuildContext context) => const StoreManagementPage()
                ));*/
              },
            ),
          ),
        ],
      ),
    );
  }
}