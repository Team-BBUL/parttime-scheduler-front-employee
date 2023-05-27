import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sidam_employee/data/model/announcement.dart';

import '../data/repository/announcement_repository.dart';

class AnnouncementViewModel extends ChangeNotifier {
  AnnouncementRepository announcementRepository;
  List<String> imagePaths = [];
  bool isEditMode = false;
  bool isCreateMode = false;
  Announcement announcement = Announcement(id: '', subject: '', body: '', photo: '', timestamp: '');
  List<Announcement> announcementList =[];

  AnnouncementViewModel(this.announcementRepository){
    fetchAnnouncementList();
  }
  AnnouncementViewModel.withArguments(this.announcementRepository,Map<String,dynamic> arguments) {
    fetchAnnouncement(arguments['id']);
  }

  Future<void> fetchAnnouncement(String announcementId) async {
    try {
      final result = await announcementRepository.getAnnouncement(announcementId);
      announcement = Announcement.fromJson(result);
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
    }
  }
  Future<void> fetchAnnouncementList() async {
    try {
      final result = await announcementRepository.getAnnouncementList();
      announcementList = result.map((json) => Announcement.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      // 에러 처리 로직
      print(e);
    }
  }
}