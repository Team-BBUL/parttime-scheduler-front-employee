import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';

import '../../model/Incentive.dart';
import 'package:http/http.dart' as http;

import '../../util/sp_helper.dart';

abstract class IncentiveRepository{
  Future fetchMonthIncentives(DateTime date);
  Future fetchOnesMonthIncentive();
  Future fetchIncentives(int employeeId);
  Future fetchIncentive(int employeeId,int incentiveId);
  Future postIncentive(Incentive incentive, int employeeId);
  Future putIncentive(Incentive incentive, int employeeId);
  Future deleteIncentive(int incentiveId, int employeeId);

}

class IncentiveRepositoryImpl extends IncentiveRepository{

  String incentiveApi = 'https://sidam-scheduler.link/api/stores';

  @override
  Future fetchMonthIncentives(DateTime date) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/incentives?month=${DateFormat('yyyyMM').format(date)}';

    log("fetchMonthIncentives $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<MonthIncentive> monthIncentives = [];
      List<Incentive> incentiveList = [];
      MonthIncentive monthIncentive = MonthIncentive();

      for (var worker in decodedData['data']) {
        if(worker['incentives'].isNotEmpty){
          for (var item in worker['incentives']) {
            incentiveList.add(Incentive.fromJson(item));
          }
          monthIncentive = MonthIncentive(
              id: worker['roleId'],
              alias: worker['alias'],
              incentives: incentiveList
          );
        }
      }

      monthIncentives.add(monthIncentive);


      log('fetchMonthIncentives get successfully.');

      return monthIncentives;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future fetchOnesMonthIncentive() async {
    SPHelper helper = SPHelper();
    DateTime now = DateTime.now();
    String month;
    month = now.month <10 ? '0${now.month}' : '${now.month}';
    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/employees/${helper.getRoleId()}/incentives?month=${now.year}-$month';

    log("fetchOnesMonthIncentive $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    log("fetchOnesMonthIncentive jwt ${helper.getJWT()}");
    log("fetchOnesMonthIncentive url $apiUrl");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<Incentive> incentiveList = [];
      if(decodedData['data'].isEmpty){
        return null;
      }
      for (var item in decodedData['data']['incentives']) {
        incentiveList.add(Incentive.fromJson(item));
      }
      MonthIncentive monthIncentive = MonthIncentive(
          id: decodedData['data']['id'],
          alias: decodedData['data']['alias'],
          incentives: incentiveList
      );
      log('fetchOnesMonthIncentive get successfully.');

      return monthIncentive;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future fetchIncentives(int employeeId) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/employees/$employeeId/incentives/all';

    log("fetchIncentives $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    log("fetchIncentives jwt ${helper.getJWT()}");

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);
      List<Incentive> incentiveList = [];
      for (var item in decodedData['data']) {
        incentiveList.add(Incentive.fromJson(item));
      }
      log('fetchIncentives get successfully.');
      return incentiveList;
    } else if(response.statusCode == 400) {
      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future fetchIncentive(int employeeId, int incentiveId) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/employees/$employeeId/incentives/$incentiveId';

    log("fetchIncentive $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};
    log("fetchIncentive jwt ${helper.getJWT()}");
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('fetchIncentive get successfully.');
      return Incentive.fromJson(decodedData['data']);
    } else if(response.statusCode == 400) {

      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future postIncentive(Incentive incentive, int employeeId) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/employees/$employeeId/incentive';

    log("postAnniversary $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    log("postIncentvie incentive  ${incentive.toJson()}");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body:  jsonEncode(incentive.toJson()),
    );

    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('postAnniversary get successfully.');
      return decodedData['id'];
    } else if(response.statusCode == 400) {

      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }

  @override
  Future putIncentive(Incentive incentive, int employeeId) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/employees/$employeeId/incentive/${incentive.id}';

    log("putAnniversary $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: incentive.toJson(),
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('putAnniversary get successfully.');
    } else if(response.statusCode == 400) {

      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }
  @override
  Future deleteIncentive(int incentiveId, int employeeId) async {
    SPHelper helper = SPHelper();

    final String apiUrl = '$incentiveApi/${helper.getStoreId()}/employees/$employeeId/incentives/${incentiveId}';

    log("deleteAnniversary $apiUrl");

    var headers = {'Authorization': 'Bearer ${helper.getJWT()}',
      'Content-Type': 'application/json'};

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      log("response.body${response.body}");
      Map<String, dynamic> decodedData = json.decode(response.body);

      log('deleteAnniversary get successfully.');
    } else if(response.statusCode == 400) {

      log('failed : ${response.body}');
      throw response.body;
    } else{
      throw Exception('서버 오류가 발생했습니다. 나중에 다시 시도해주세요');
    }
  }
}