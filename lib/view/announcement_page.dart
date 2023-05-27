import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/announcement_list.dart';
import 'package:sidam_employee/view_model/announcement_view_model.dart';

import '../data/repository/announcement_repository_mock.dart';
import 'announcement_detail.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(MockAnnouncementRepository()),
        child: const AnnouncementListScreen());
  }
}class AnnouncementDetailPage extends StatelessWidget {
  const AnnouncementDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel.withArguments(MockAnnouncementRepository(),arguments!),
        child: const AnnouncementDetailScreen());
  }
}

