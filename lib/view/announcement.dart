import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/announcement_view_model.dart';

class AnnouncementScreen extends StatelessWidget{
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Screen'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) => AnnouncementCreateScreen(),
                ));
              },
            ),
          ]
      ),
      body: Consumer<AnnouncementViewModel>(
        builder:(context, viewModel,child){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: viewModel.announcement
            .map((e) => Container(
                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom : BorderSide(width: 1, color: Colors.grey)
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(e.title, style: TextStyle(fontSize: 16)),
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

class AnnouncementCreateScreen extends StatefulWidget{
  const AnnouncementCreateScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AnnouncementCreateState();

}
class _AnnouncementCreateState extends State<AnnouncementCreateScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '글 제목',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: '내용을 입력하세요',
              ),
            ),
          ],
        )
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child:Row(
          children: [
            Image.asset('assets/image/no-image.png')
          ],
        )
      ),
    );
  }

}