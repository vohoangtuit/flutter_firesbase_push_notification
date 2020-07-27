import 'package:flutter_notifications/model/data.dart';
import 'package:flutter_notifications/model/notification.dart';

class ResponseNotification{
  PushNotification notification;
  DataNotification dataNotification;

  ResponseNotification(this.notification, this.dataNotification);
}