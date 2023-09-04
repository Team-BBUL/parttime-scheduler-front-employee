import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../view_model/announcement_view_model.dart';
import 'announcement_detail.dart';

class AnnouncementListScreen extends StatelessWidget{
  const AnnouncementListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<AnnouncementViewModel>(context,listen: false );
    _viewModel.getAnnouncementList(100);
    return Scaffold(
      appBar: AppBar(
          title: const Text('공지사항'),
          centerTitle: true,
      ),
      body: Consumer<AnnouncementViewModel>(
          builder:(context, viewModel,child){
            if (viewModel.announcementList == null || viewModel.announcementList!.length != 0) {
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
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(
                            color: Colors.grey, width: 1.0,),),
                          // border: Border.all(width: 1, color: Colors.black)
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  viewModel.announcementList?[index].subject ??
                                      '',
                                  style: TextStyle(fontSize: 16)),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(viewModel.announcementList?[index]
                                  .timeStamp != null
                                  ? '${viewModel.announcementList?[index]
                                  .appendZeroMonth()}/'
                                  '${viewModel.announcementList?[index]
                                  .appendZeroDay()}'
                                  : '',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey)),
                            )
                            ,
                          ],
                        ),
                      ),
                    );
                  });
            }
          }
      ),
    );
  }
}
