import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../view_model/announcement_view_model.dart';
import 'announcement_detail.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  _AnnouncementListScreenState createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<AnnouncementViewModel>(context,listen: false );
    _viewModel.getAnnouncementList(100);

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: const Text('공지사항'),
          centerTitle: true,
      ),
      body: Consumer<AnnouncementViewModel>(
          builder:(context, viewModel,child){
            if (viewModel.announcementList == null || viewModel.announcementList!.length == 0) {
              return SizedBox(
                width: double.infinity,
                  height: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        SvgPicture.asset("assets/icons/loader.svg", color: Colors.black54,),
                        Text("공지사항이 없어요!", style: TextStyle(fontSize: 16),),
                      ])
              );
            } else {
              return ListView.builder(
                // mainAxisAlignment: MainAxisAlignment.start
                  itemCount: viewModel.announcementList?.length ?? 0,
                  controller: viewModel.scrollController,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          viewModel.announcementList?[index].read = true;
                        });
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              int id = viewModel.announcementList?[index].id ??
                                  0;
                              return AnnouncementDetailScreen(id);
                            }
                        ));
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(
                            color: Colors.grey, width: 1.0,),),
                          // border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: Row(children: [
                          !(viewModel.announcementList?[index].read ?? false) ?
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 4, right: 4),
                                child: const Text('new',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                              : const Text(""),
                          !(viewModel.announcementList?[index].read ?? false) ?
                              SizedBox(width: 10, height: 1,) : Text(''),

                          Container(child: Column(children: [
                            const SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  viewModel.announcementList?[index].subject ??
                                      '',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(viewModel.announcementList?[index].timeStamp != null
                                  ? '${DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(viewModel.announcementList?[index].timeStamp ?? DateTime(2023, 1, 1))}'
                                  : '',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey)),
                            ),
                          ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                            width: deviceWidth - 80,
                          )
                        ],),
                      ),
                    );
                  });
            }
          }
      ),
    );
  }
}
