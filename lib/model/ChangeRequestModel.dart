import 'package:sidam_worker/model/AccountRole.dart';

class ChangeRequest{
  late final int id;
  late AccountRole requester;
  AccountRole? receiver;
  String? res;
  late String own;
  late int target;
  late int old;
  late String oldText;
  String? targetText;

  ChangeRequest({
    required this.id,
    required this.res,
    required this.own,
    required this.target,
    required this.old,
    required this.requester,
    required this.receiver,
    required this.oldText,
    required this.targetText
  });

  void setRequester(AccountRole role) { requester = role; }
  void setReceiver(AccountRole rec) { receiver = rec; }

  factory ChangeRequest.fromJson(Map<String, dynamic> json) {
    return ChangeRequest(
        id: json['id'],
        res: json['res'],
        own: json['own'],
        target: json['target'],
        old: json['old'],
        requester: AccountRole.fromJson(json['requester']),
        receiver: json['receiver'] != null ?
            AccountRole.fromJson(json['receiver']) :
            null,
        oldText: json['oldSchedule'],
        targetText: json['targetSchedule']
    );
  }
}