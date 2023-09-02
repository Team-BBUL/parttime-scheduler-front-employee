import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../data/repository/announcement_repository.dart';
import '../model/announcement.dart';
import '../view/enum/announcement_mode.dart';

class AnnouncementViewModel extends ChangeNotifier {
  final AnnouncementRepository _announcementRepository;
  Announcement? _announcement;
  Announcement? _newAnnouncement;
  AnnouncementMode? _mode;
  List<Announcement>? _announcementList;
  ScrollController? _scrollController;
  List<dynamic>? _images;
  List<dynamic>? _newImages;

  AnnouncementMode? get mode => _mode;
  List<Announcement>? get announcementList => _announcementList;
  get scrollController => _scrollController;
  get images => _images;
  get newImages => _newImages;
  Announcement? get announcement => _announcement;
  Announcement? get newAnnouncement => _newAnnouncement;

  AnnouncementViewModel(this._announcementRepository){
    int page = 1;
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
          _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        print('botton');
        // getAnnouncementList();
      }
      page++;
    });
  }

  Future<void> getAnnouncement(int announcementId) async {
    _announcement = null;
    try {
      _announcement = await _announcementRepository.fetchAnnouncement(announcementId);
      await _urlToImage();
    } catch (e) {
      log("Error ${e}");
    }
  }

  Future _urlToImage() async{
    if(_announcement!.getPhoto != null){
      _images = [];
      int length = _announcement!.getPhoto!.length;
      for(int i = 0; i < length; i++ ){
        images!.add( await _announcementRepository.fetchImage(
            _announcement!.getPhoto![i].downloadUrl ?? '',
            _announcement!.getPhoto![i].fileName ?? ''));
      }
    }
  }

  Future<void> getAnnouncementList(int page) async {
    try {
      _announcementList = await _announcementRepository.fetchAnnouncementList(page);
      notifyListeners();
    } catch (e) {
      log("Error ${e}");
    }
  }

}