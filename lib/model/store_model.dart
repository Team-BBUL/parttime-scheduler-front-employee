import 'package:logger/logger.dart';

class StoreList {

  List<Store>? data;

  StoreList({this.data});

  final _logger = Logger();

  StoreList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Store>[];
      json['data'].forEach((v) {
        data!.add(Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  StoreList filterStores(String keyword){
    _logger.i("keyword $keyword");
    List filteredList = data!.where((store) => store.name!.contains(keyword)).toList();
    StoreList filteredStoreList = StoreList(data: filteredList as List<Store>);
    _logger.i(filteredStoreList.data!.length);
    return filteredStoreList;
  }
}

class Store {
  int? id;
  String? name;
  String? location;
  String? phone;
  int? open;
  int? close;
  int? costPolicy;
  int? payday;
  int? weekStartDay;
  int? unworkableDaySelectDeadline;
  List<dynamic>? errors;

  Store({this.id, this.name, this.location, this.phone});
  Store.setTime({this.id, this.name, this.location, this.phone, this.open, this.close});
  Store.all({this.id, this.name, this.location, this.phone, this.open, this.close, this.costPolicy, this.payday, this.weekStartDay});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    phone = json['phone'];
    open = json['open'];
    close = json['close'];
    payday = json['payday'];
    weekStartDay = json['weekStartDay'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'phone': phone,
    'open': open,
    'close': close,
    'payday': payday,
    'weekStartDay': weekStartDay,
  };

}