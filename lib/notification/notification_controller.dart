

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/screens/detail.dart';

import 'data_model.dart';

class NotificationController{
 // TODO https://www.youtube.com/watch?v=p7aIZ3aEi2w

  late FirebaseMessaging _firebaseMessaging ;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
   BuildContext? context;
  NotificationController.getInstance({BuildContext? context}){
    this.context =context;
    _firebaseMessaging = FirebaseMessaging.instance;
    _flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
   initFirebaseMessage();
   initLocalNotification();
   // deviceToken();
  }
  Future<String?> deviceToken()async{
    String? token ='';
    await _firebaseMessaging.getToken().then((value){
      print("token::: "+value!);
      token =value;
    });
    return token;
  }

  initFirebaseMessage()async{
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission();
    }
    // todo gives you the message on which user tap
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message!=null){
        print('getInitialMessage: ${message.data}');
        // todo open screen
      }
    });
    // todo app opening
    FirebaseMessaging.onMessage.listen((message) {
      if(message!=null){
        print('opening message : ${message.notification!.body}');
        print('opening message: ${message.notification!.title}');
      //  print(message.data);
        display(message);
      }
    });

    // todo when the app is in background but opened and user taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('onMessageOpenedApp: ${message.data}');
      print('message ${message.data['message']}');
      print('type_id ${message.data['type_id']}');
      // todo open screen
      if(message!=null){
        DataNotifyModel data =DataNotifyModel.fromRemoteMessage(message);
         gotoDetailScreen(data);
      }

    });
  }
  initLocalNotification() {

    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@drawable/ic_notification');

    var initializationSettingsIOS = IOSInitializationSettings(requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }

  void display(RemoteMessage message)async{
    print('message $message');
    try{
      final int id = 0;
      final NotificationDetails notificationDetails = NotificationDetails(
        android:  AndroidNotificationDetails('vietravel_channel', 'vietravel_channel',
            importance: Importance.max,
            priority:  Priority.high,
            playSound: true,
            showWhen: true,
            sound: RawResourceAndroidNotificationSound('sound_notification'),
           // sound: RawResourceAndroidNotificationSound('@raw/sound_notification'),
            enableLights: true,
            color: const Color.fromARGB(255, 255, 0, 0),
            ledColor: const Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500,
            autoCancel: true),
        iOS: IOSNotificationDetails(),
      );
      DataNotifyModel data =DataNotifyModel.fromRemoteMessage(message);
      await _flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails,payload: data.toString());
    }on Exception catch(e){
      print('Error Notification $e');
    }

  }
  Future onSelectNotification(dynamic payload) async {
    if (payload != null) {
    //  print('notification payload:::::: ${payload.toString()}' );
      await  handlePayload(payload);
    }
  }
  handlePayload(String payload) async {
  //  print('payload $payload');
    DataNotifyModel data=  DataNotifyModel.fromPyload(payload);
    gotoDetailScreen(data);
  }
  gotoDetailScreen(DataNotifyModel dataModel){
    switch (dataModel.type_id) {
      case '1':// promotion
      //print('new detail');
      print('gotoDetailScreen ${dataModel}');
        Navigator.push(context!,MaterialPageRoute(builder: (context) => DetailPage(content: dataModel.content)));
        break;
      case '2':// new
        print('gotoDetailScreen ${dataModel}');
       // Navigator.push(context,MaterialPageRoute(builder: (context) => NewsDetailsScreen(newsId: dataModel.object_id, title: dataModel.title,)));
        break;
      case '3':// tour
        print('gotoDetailScreen ${dataModel}');

        break;
      default:
        break;
    }
  }
}