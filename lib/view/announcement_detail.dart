
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/announcement_view_model.dart';


class AnnouncementDetailScreen extends StatelessWidget {
  const AnnouncementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar의 높이 지정
        child: Consumer<AnnouncementViewModel>(
          builder: (context, viewModel, _) {
            return AppBar(
              title: Text('view mode'),
            );
          },
        ),
      ),
      body: Consumer<AnnouncementViewModel>(
          builder:(context, viewModel,child){
            return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                child:Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                        Text(
                                          '${viewModel.announcement.subject}${viewModel.announcement.id}' ?? '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                    ],
                                  ),
                                )
                            )
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                        Text(
                                          viewModel.announcement.body ?? '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                    ],
                                  ),
                                )
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: viewModel.imagePaths.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Image.file(
                                  File(viewModel.imagePaths[index]),
                                  fit: BoxFit.cover,
                                ),
                                title: Text(viewModel.imagePaths[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(viewModel.announcement.timestamp ?? '', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    )
                  ],
                )
            );
          }
      ),
    );
  }
}
