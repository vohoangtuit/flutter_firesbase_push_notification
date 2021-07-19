
import 'data_model.dart';
import 'notification_model.dart';

class ResponseNotification{
  NotificationModel notification;
  DataNotifyModel data;

  ResponseNotification({this.notification, this.data});

  factory ResponseNotification.fromJson(Map<String, dynamic> json) => ResponseNotification(
    notification: json['notification'],
    data: json['data'],
  );
  Map<String, dynamic> toJson() => {
    'notification': notification,
    'data': data,
  };

  @override
  String toString() {
    return '{"notification": $notification, "data": $data}';
  }
}