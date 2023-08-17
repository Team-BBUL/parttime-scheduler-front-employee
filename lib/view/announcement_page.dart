import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/data/repository/announcement_repository.dart';
import 'package:sidam_employee/view/announcement_list.dart';
import 'package:sidam_employee/view_model/announcement_view_model.dart';

import '../data/repository/announcement_repository_mock.dart';
import 'announcement_detail.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(AnnouncementRepositoryImpl()),
        child: const AnnouncementListScreen());
  }
}

