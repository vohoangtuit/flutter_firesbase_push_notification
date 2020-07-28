import 'package:flutter_notifications/model/response_notification.dart';

class DataNotification{
  String type;
  String content;
  String description;
  String click_action;


  DataNotification({this.type, this.content,this.description,this.click_action});

  factory DataNotification.fromResponse(ResponseNotification responseNotification)=>DataNotification(
      type:responseNotification.dataNotification.type,
      content:responseNotification.dataNotification.content,
      description:responseNotification.dataNotification.description,
      click_action:responseNotification.dataNotification.click_action
  );

  factory DataNotification.fromJson(Map<String,dynamic> json) =>DataNotification(

      type:json['data']['type'],
      content:json['data']['content'],
      description:json['data']['description'],
     click_action:json['data']['click_action']
  );
  factory DataNotification.fromJsonIOS(Map<String,dynamic> json) =>DataNotification(
    // todo: working on ios
      type:json['type'],
      content:json['content'],
      description:json['description'],
      click_action:json['click_action']
  );
  Map<String, dynamic> toJson() => {
    'type': type,
    'content': content,
    'description': description,
    'click_action': click_action,
  };
}