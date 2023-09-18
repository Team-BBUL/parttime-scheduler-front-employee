
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:sidam_employee/model/announcement.dart';
import 'package:http/http.dart' as http;
import '../../util/sp_helper.dart';

abstract class AnnouncementRepository {
  Future<Announcement> fetchAnnouncement(int announcementId);
  Future<List<Announcement>> fetchAnnouncementList(int page);

  Future fetchImage(String url, String fileName);
}

class AnnouncementRepositoryImpl implements AnnouncementRepository{

  //static String server = 'http://10.0.2.2:8088';
  static String server = 'https://sidam-scheduler.link';
  static String noticeApi = '$server/api/notice/';
  static SPHelper helper = SPHelper();
  final headers = {'Authorization': 'Bearer ${helper.getJWT()}',
    'Content-Type': 'application/json'};

  @override
  Future<Announcement> fetchAnnouncement(int announcementId) async {
    final String apiUrl = '$noticeApi${helper.getStoreId()}'
        '/view/detail?id=$announcementId&role=${helper.getRoleId()}';
    log("fetchAnnouncement $apiUrl");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log(response.body);
      Map<String, dynamic> decodedData = json.decode(response.body);
      return Announcement.fromJson(decodedData['data']);
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future<List<Announcement>> fetchAnnouncementList(int page) async {
    final String apiUrl = '$noticeApi${helper.getStoreId()}/view/list?last=0&cnt=10000&role=${helper.getRoleId()}';
    log("fetchAnnouncementList $apiUrl");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<Announcement> announcementList = [];
      for (var item in decodedData['data']) {
        announcementList.add(Announcement.fromJson(item));
      }
      log("${announcementList.length}");
      log('NoticeList get successfully.');
      return announcementList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future fetchImage(String url, String fileName) async {
    final String apiUrl = "$server$url?filename=$fileName";
    Uint8List imageBytes;
    log("getImage $apiUrl");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
      return imageBytes;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      log('failed : ${response.body}, status code : ${response.statusCode}');
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

}