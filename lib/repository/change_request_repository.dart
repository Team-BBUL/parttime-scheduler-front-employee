import 'package:logger/logger.dart';

import 'package:sidam_worker/data/local_data_source.dart';
import 'package:sidam_worker/data/remote_data_source.dart';

import 'package:sidam_worker/utility/sp_helper.dart';

class ChangeRequestRepository {
  final Session _session = Session();
  final _logger = Logger();
  final _helper = SPHelper();

  ChangeRequestRepository() {
    _helper.init();
    _session.init();
  }

  // 대상 비지정 요청 전송
  Future<bool> nonTargetChange(int storeId, int roleId, int scheduleId) async {

    _logger.i('대상 비지정 근무 변경 요청 전송, $scheduleId 스케줄을 변경 요청함');

    // api url
    var url = '/api/schedule/change/$storeId?id=$roleId&schedule=$scheduleId';

    _logger.i('http post $url');

    return false;

    /*
    // 반환
    var res = await _session.post(url, null);

    // 오류인 경우
    if (res.statusCode < 200 || res.statusCode >= 400) {
      return false;
    }
    return true;
     */
  }

  // 대상 지정 변경 요청 전송
  Future<bool> targetingChange(int storeId, int roleId, int targetId, int scheduleId, int obId) async {

    _logger.i('대상 지정 근무 변경 요청 전송, $scheduleId 스케줄을 $targetId의 $obId 스케줄로 변경 요청함');

    // api url
    var url = '/api/schedule/change/$storeId?id=$roleId&schedule=$scheduleId&target=$targetId&objective=$obId';

    _logger.i('http post $url');

    return true;
    /*
    // 반환
    var res = await _session.post(url, null);

    // 오류인 경우
    if (res.statusCode < 200 || res.statusCode >= 400) {
      return false;
    }
    return true;
     */
  }

}