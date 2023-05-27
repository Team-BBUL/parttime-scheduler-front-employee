import '../model/announcement.dart';

abstract class AnnouncementRepository {
  Future<dynamic> getAnnouncement(String announcementId);
  Future<List<dynamic>> getAnnouncementList();
}