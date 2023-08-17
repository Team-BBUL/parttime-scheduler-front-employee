import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sidam_worker/api/Session.dart';

class Store {

  final int id;
  final String name;
  final int open;
  final int close;
  final String location;
  final String phone;
  final int deadline;
  final int week;

  Store({
    required this.id,
    required this.name,
    required this.open,
    required this.close,
    required this.deadline,
    required this.location,
    required this.phone,
    required this.week
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        id: json['id'],
        name: json['name'],
        open: json['open'],
        close: json['close'],
        deadline: json['deadline'],
        location: json['location'],
        phone: json['phone'],
        week: json['week']
    );
  }

  static Future<Store> loadStore() async {
    
    Session session = Session();

    String json = await rootBundle.loadString('assets/json/store.json')
        .catchError((error) {
          // api로 매장 정보 호출?
          print("error: $error");
        });
    Store store = Store.fromJson(jsonDecode(json));
    return store;
  }
}