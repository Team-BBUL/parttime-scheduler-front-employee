class Announcement{
  String id;
  String subject;
  String body;
  String photo;
  String timestamp;

  Announcement({required this.id, required this.subject, required this.body, required this.photo, required this.timestamp});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      subject: json['subject'],
      body: json['body'],
      photo: json['photo'],
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'body': body,
      'photo': photo,
      'timestamp': timestamp,
    };
  }
}