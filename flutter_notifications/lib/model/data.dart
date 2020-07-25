class DataNotification{
  String type;
  String content;
  String description;
  String click_action;

  DataNotification({this.type, this.content,this.description,this.click_action});

  factory DataNotification.fromJson(Map<String,dynamic> json) =>DataNotification(
      type:json['data']['type'],
      content:json['data']['content'],
      description:json['data']['description'],
     click_action:json['data']['click_action']
      // todo: working on ios
//      type:json['type'],
//      content:json['content'],
//      description:json['description'],
//      click_action:json['click_action']
  );

}