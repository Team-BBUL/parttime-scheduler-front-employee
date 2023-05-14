import 'package:flutter/material.dart';

class ChattingScreen extends StatelessWidget{
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.chat))
                ]),
          ),
          body: TabBarView(
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text("test")
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your username',
                  ),
                ),
              )
            ],
          )

        )
      )
    );
  }


}