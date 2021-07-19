class NotificationModel{
  String title;
  String body;
  NotificationModel({this.title, this.body});

  factory NotificationModel.fromJson(Map<String, dynamic> json)=> NotificationModel(
    title: json['notification']['title'],
    body: json['notification']['body']
  );

  @override
  String toString() {
    return '{title: $title, body: $body}';
  }
}