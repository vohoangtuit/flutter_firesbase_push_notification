import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
final  String NOTIFY_DATA ='data';
final String NOTIFY_TYPE_ID ='type_id';
final String NOTIFY_MESSAGE ='message';
final String NOTIFY_TITLE ='title';
final String NOTIFY_NOTIFICATION_ID ='notification_id';
final String NOTIFY_OBJECT_ID ='object_id';
final String NOTIFY_CLICK_ACTION ='click_action';
class DataNotifyModel{
  String type_id;
  String message;
  String title;
  String notification_id;
  String object_id;
  String click_action;
  DataNotifyModel({this.type_id, this.message,this.title,this.notification_id,this.object_id,this.click_action});

  factory DataNotifyModel.fromPyload(String payload){
    print('payload::...:: $payload');

    var _json = jsonDecode(payload) as Map;
    print('_json $_json');
    return DataNotifyModel(
        type_id: _json[NOTIFY_TYPE_ID],
        message: _json[NOTIFY_MESSAGE].toString(),
        title: _json[NOTIFY_TITLE].toString(),
        notification_id: _json[NOTIFY_NOTIFICATION_ID].toString(),
        object_id: _json[NOTIFY_OBJECT_ID].toString(),
        click_action: _json[NOTIFY_CLICK_ACTION]);
  }

  factory DataNotifyModel.fromRemoteMessage(RemoteMessage remoteMessage) =>DataNotifyModel(
      type_id:remoteMessage.data[NOTIFY_TYPE_ID],
      message:remoteMessage.data[NOTIFY_MESSAGE],
      title:remoteMessage.data[NOTIFY_TITLE],
      notification_id:remoteMessage.data[NOTIFY_NOTIFICATION_ID],
      object_id:remoteMessage.data[NOTIFY_OBJECT_ID],
      click_action:remoteMessage.data[NOTIFY_CLICK_ACTION]
  );
  factory DataNotifyModel.fromJsonAndroid(Map<String,dynamic> json) =>DataNotifyModel(
      type_id:json[NOTIFY_DATA][NOTIFY_TYPE_ID],
      message:json[NOTIFY_DATA][NOTIFY_MESSAGE],
      title:json[NOTIFY_DATA][NOTIFY_TITLE],
      notification_id:json[NOTIFY_DATA][NOTIFY_NOTIFICATION_ID],
      object_id:json[NOTIFY_DATA][NOTIFY_OBJECT_ID],
     click_action:json[NOTIFY_DATA][NOTIFY_CLICK_ACTION]
  );
  factory DataNotifyModel.fromJsonIOS(Map<String,dynamic> json) =>DataNotifyModel(
    // todo: working on ios
      type_id:json[NOTIFY_TYPE_ID],
      message:json[NOTIFY_MESSAGE],
      title:json[NOTIFY_TITLE],
      notification_id:json[NOTIFY_NOTIFICATION_ID],
      object_id:json[NOTIFY_OBJECT_ID],
      click_action:json[NOTIFY_CLICK_ACTION]
  );
  Map<String, dynamic> toJson() => {
    NOTIFY_TYPE_ID: type_id,
    NOTIFY_MESSAGE: message,
    NOTIFY_TITLE: title,
    NOTIFY_NOTIFICATION_ID: notification_id,
    NOTIFY_OBJECT_ID: object_id,
    NOTIFY_CLICK_ACTION: click_action,
  };
@override
  String toString() {// todo handle  pyload
    return '{"type_id": "$type_id", "message": "$message", "title": "$title", "notification_id": "$notification_id", "object_id": "$object_id", "click_action": "$click_action"}';
  }
}