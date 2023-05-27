import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/announcement_page.dart';
import '../view_model/announcement_view_model.dart';

class AnnouncementListScreen extends StatelessWidget{
  const AnnouncementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Announcement List Screen'),
      ),
      body: Consumer<AnnouncementViewModel>(
          builder:(context, viewModel,child){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: viewModel.announcementList
                  .map((announcement) => Container(
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
                              builder: (context) => AnnouncementDetailPage(),
                              settings: RouteSettings(arguments: {
                                "id" : announcement.id,
                              })));
                        },
                        child : Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(announcement.subject, style: TextStyle(fontSize: 16)),
                        ),
                      ),

                    ],
                  )
              )).toList(),
            );
          }
      ),
    );
  }
}
