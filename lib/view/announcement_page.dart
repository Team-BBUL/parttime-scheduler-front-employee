import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidam_employee/view/announcement.dart';
import 'package:sidam_employee/view_model/announcement_view_model.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnouncementViewModel>(
        create: (_) => AnnouncementViewModel(),
        child: const AnnouncementScreen());
  }
}