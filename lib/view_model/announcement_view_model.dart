import 'package:flutter/material.dart';
import 'package:sidam_employee/data/model/announcement.dart';

class AnnouncementViewModel extends ChangeNotifier{

  List<Announcement> _announcements = [
    Announcement(title: "title", content: "1번글입니다"),
    Announcement(title: "title2",content: "2번글입니다"),
    Announcement(title: "title3",content: "3번글입니다")
  ];
  List<Announcement> get announcement => _announcements;
}
