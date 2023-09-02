import 'dart:io';
import 'dart:typed_data';

class Announcement{
  int? id;
  String? subject;
  String? content;
  List<File>? photo;
  List<Uint8List>? memoryImage;
  List<GetPhoto>? getPhoto;
  DateTime? timeStamp;
  Announcement({required this.id, required this.subject, required this.content, required this.photo, required this.timeStamp, required this.getPhoto});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject= json['subject'];
    content= json['content'] ?? '';
    if (json['photo'] != null) {
      getPhoto = [];
      json['photo'].forEach((v) {
        getPhoto!.add(new GetPhoto.fromJson(v));
      });
    }else{
      photo = [];
    }
    photo = json['images'] != null ? json['images'].cast<File>() : [];
    timeStamp= DateTime.parse(json['timeStamp']) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['content'] = this.content;
    // data['photo'] = this.photo;
    data['timeStamp'] = this.timeStamp.toString();
    return data;
  }
  Map<String, dynamic> toJsonExcludeIdAndTimeStamp() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['content'] = this.content;
    // data['photo'] = this.photo;
    return data;
  }

  replaceObject(Announcement announcement){
    this.id = announcement.id;
    this.subject = announcement.subject;
    this.content = announcement.content;
    this.photo = announcement.photo;
    this.timeStamp = announcement.timeStamp;
  }

  koreanWeekday() {
    int? weekday = this.timeStamp?.weekday;
    if(weekday == 1) {
      return '월';
    }else if(weekday == 2) {
      return '화';
    }else if(weekday == 3) {
      return '수';
    }else if(weekday == 4) {
      return '목';
    }else if(weekday == 5) {
      return '금';
    }else if(weekday == 6) {
      return '토';
    }else if(weekday == 7) {
      return '일';
    }
  }

  shortenYear(){
    return this.timeStamp?.year.toString().substring(2,4);
  }

  appendZeroDay(){
    if(this.timeStamp?.day.toString().length == 1){
      return '0${this.timeStamp?.day}';
    }
  }

  appendZeroMonth(){
    if(this.timeStamp?.month.toString().length == 1){
      return '0${this.timeStamp?.month}';
    }
  }
}

class GetPhoto {
  String? fileName;
  String? downloadUrl;

  GetPhoto({this.fileName, this.downloadUrl});

  GetPhoto.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    downloadUrl = json['downloadUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }
}