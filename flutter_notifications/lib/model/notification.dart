class PushNotification{
  String title;
  String body;
  PushNotification({this.title, this.body});

  factory PushNotification.fromJson(Map<String, dynamic> json)=> PushNotification(
    title: json['notification']['title'],
    body: json['notification']['body']
  );

}