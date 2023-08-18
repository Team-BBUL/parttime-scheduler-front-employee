
class Notice {

  final int id;
  String title;
  String timeStamp;
  late DateTime date;
  bool read = false;

  Notice({
    required this.title,
    required this.timeStamp,
    required this.id,
    required this.read
  }) {
    date = DateTime.parse(timeStamp);
  }

  String getTitle() { return title; }

  int getId() { return id; }

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        title: json['subject'],
        timeStamp: json['timeStamp'],
        id: json['id'],
        read: json['check']
    );
  }
}