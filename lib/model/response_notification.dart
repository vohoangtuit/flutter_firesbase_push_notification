import 'package:flutter_notifications/model/data.dart';
import 'package:flutter_notifications/model/notification.dart';

class ResponseNotification{
  PushNotification? notification;
  DataNotification? dataNotification;

  ResponseNotification({this.notification, this.dataNotification});

 // factory ResponseNotification.
  factory ResponseNotification.fromJson(Map<String, dynamic> json) => ResponseNotification(
    notification: json['notification'],
    dataNotification: json['data'],
  );
  Map<String, dynamic> toJson() => {
    'notification': notification,
    'data': dataNotification,
  };

}