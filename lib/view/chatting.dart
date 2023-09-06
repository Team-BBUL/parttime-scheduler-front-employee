import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view_model/chatting_view_model.dart';

import '../util/appColor.dart';

class ChattingScreen extends StatelessWidget{
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: AppColor().mainColor,
        useMaterial3: true,
      ),
      home : DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
                indicatorColor: AppColor().mainColor,
                tabs: [
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: SvgPicture.asset('assets/icons/message_square_icon.svg'),)
                ]),
          ),
          body: Consumer<ChattingViewModel>(
              builder: (context, viewModel, child) { return TabBarView(
                children: [
                   Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: viewModel.userRole
                            .map((userRole) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom : BorderSide(width: 1, color: Colors.grey)
                              ),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Test(),
                                        settings: RouteSettings(arguments: userRole.alias)));
                                  },
                                  child : Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                        "${userRole.level} ${userRole.alias}",
                                        style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                  ),
                                ),

                              ],
                            )
                        )).toList(),
                      )
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
              );
              }
          )
        )
      )
    );
  }
}
class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

}
class UnderConstruction extends StatelessWidget{
  const UnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: AppColor().mainColor,
        useMaterial3: true,
      ),
      home : Scaffold(
        appBar: AppBar(
          title: const Text('Chatting Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("공사중"),
              Icon(Icons.construction)
            ],
          ),
        ),
      )
    );
  }
}