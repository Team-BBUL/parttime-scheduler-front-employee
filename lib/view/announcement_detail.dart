

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/app_future_builder.dart';
import '../util/image_hero.dart';
import '../view_model/announcement_view_model.dart';
import 'enum/image_type.dart';


class AnnouncementDetailScreen extends StatelessWidget {
  final int index;

  AnnouncementDetailScreen(this.index);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AnnouncementViewModel>(context,listen: true );
    return AppFutureBuilder<void>(
      future: viewModel.getAnnouncement(index),
      builder: (context, snapshot){
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight), // AppBar의 높이 지정
              child: AppBar(
                title: const Text('View Mode'),
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 1,
                    child: Column(
                        children:[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            decoration:  const BoxDecoration(),
                            child: Text(
                              viewModel.announcement?.subject ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(30, 5, 0, 5),
                            child: Text(
                                viewModel.announcement?.timeStamp != null
                                    ? '${viewModel.announcement?.timeStamp?.year}년 '
                                    '${viewModel.announcement?.timeStamp?.month}월 '
                                    '${viewModel.announcement?.timeStamp?.day}일 '
                                    '${viewModel.announcement?.koreanWeekday()}요일': '',
                                style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          ),
                        ]
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom : BorderSide(width: 1, color: Colors.grey)
                    ),
                  ),
                ),
                Flexible(
                    flex: 7,
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                              viewModel.announcement?.content ?? '',
                              style: TextStyle(fontSize: 16)),

                        )
                    )
                ),
                Flexible(
                    flex: 3,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                        decoration: BoxDecoration(
                          border: const Border(
                              top : BorderSide(width: 1, color: Colors.grey)
                          ),
                        ),
                        child: Row(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: viewModel.images?.length ?? 0,
                              itemBuilder: (context, index) {
                                if(viewModel.images![index] is File){
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return ImageHero(image : viewModel.images![index].path, type: ImageType.FILE);
                                          }
                                      ));
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 2),
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Image.file(File(viewModel.images![index].path)
                                        ),
                                      ),
                                    ),
                                  );
                                }else{
                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return ImageHero(image : viewModel.images![index], type: ImageType.MEMORY);
                                          }
                                      ));
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 2),
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Image.memory(
                                          viewModel.images![index],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                              },
                            ),
                            // Container(),
                          ],
                        )
                    )

                ),

              ],
            )

        );
      },
    );

  }
}
