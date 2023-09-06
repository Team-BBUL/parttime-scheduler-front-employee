import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidam_worker/data/repository/user_repository_mock.dart';
import 'package:sidam_worker/view/chatting.dart';
import 'package:sidam_worker/view_model/chatting_view_model.dart';

//공사중(미정)
class ChattingPage extends StatelessWidget {
  const ChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChattingViewModel>(
        create: (_) => ChattingViewModel(MockUserRepository()),
        child: const UnderConstruction());
  }
}