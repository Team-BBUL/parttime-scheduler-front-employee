import '../model/announcement.dart';
import 'announcement_repository.dart';

class MockAnnouncementRepository implements AnnouncementRepository {

  @override
  Future<dynamic> getAnnouncement(String param1) async {
    print('MockAnnouncementRepository.getAnnouncement ${param1}}');
    dynamic mockData = {
      'id': param1,
      'subject': 'subject1',
      'body': 'content1',
      'photo': 'photo',
      'timestamp': 'timestamp'
    };
    return mockData;
  }

  @override
  Future<List<dynamic>> getAnnouncementList() async {
    print('MockAnnouncementRepository.getAnnouncementList ${DateTime.now()}}');
    List<dynamic> testData = [
      {
        "id": "1",
        'subject': 'subject1',
        'body': 'content1',
        'photo': 'photo',
        'timestamp': 'timestamp'
      },
      {
        "id": "2",
        'subject': 'subject2',
        'body': 'content2',
        'photo': 'photo',
        'timestamp': 'timestamp'
      },
      {
        "id": "3",
        'subject': 'subject3',
        'body': 'content3',
        'photo': 'photo',
        'timestamp': 'timestamp'
      }
    ];

    // 아이템 이름만 추출
    // final List announcementTitles = testData.map((item) => item['subject']).toList();
    return testData;
  }
}