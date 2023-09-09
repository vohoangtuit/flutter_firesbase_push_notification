

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/screens/detail.dart';

import 'data_model.dart';

class NotificationController{
 // TODO https://www.youtube.com/watch?v=p7aIZ3aEi2w

  late FirebaseMessaging _firebaseMessaging ;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
   BuildContext? context;
  // NotificationController.getInstance({BuildContext? context}){
  //   this.context =context;
  //   _firebaseMessaging = FirebaseMessaging.instance;
  //   _flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  //  initFirebaseMessage();
  //   initLocalNotification();
  //  // deviceToken();
  // }
  NotificationController({required this.context});
  intiSetup() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _handleFirebaseMessage();
    _setupLocalNotification();
  }
  Future<String?> deviceToken()async{
    String? token ='';
    await _firebaseMessaging.getToken().then((value){
      print("token::: "+value!);
      token =value;
    });
    return token;
  }

  _handleFirebaseMessage()async{
// todo 1: when app killed and user click notification
    FirebaseMessaging.instance.getInitialMessage().then((message) async{
      if (message != null) {
        if (kDebugMode) {
          print('open app  getInitialMessage: ${message.data}');
        }
        // todo open screen
        _getDataDetail(message);
        //    if(Device.get().isAndroid){// todo android duplicate
        //      addCount();
        //      if(count==1){
        //        _getDataDetail(message);
        //        resetCount();
        //      }
        //    }else{
        //      _getDataDetail(message);
        //    }
      }
    });

    // todo 2: when the app running in background but  and user tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      if (kDebugMode) {
        print('App running in background onMessageOpenedApp: ${message.data}');
      }
      // todo open screen
      _getDataDetail(message);
      // if(Device.get().isAndroid){
      //   addCount();
      //   if(count==1){
      //     _getDataDetail(message);
      //     resetCount();
      //   }
      // }else{ // todo: ios same todo 1, duplicate
      //   // _getDataDetail(message);
      //   // resetCount();
      // }

    });

    // todo 3: when app opening
    FirebaseMessaging.onMessage.listen((message) async{
      if (message.notification != null) {
        if (kDebugMode) {
          print('App opening message : ${message.data}');
        }
        display(message);
        // if(Device.get().isAndroid){
        //   addCount();
        //   if(count==1){
        //     selectNotificationSubject.add(message.data.toString());
        //     display(message);
        //     resetCount();
        //   }
        // }else{
        //
        // }

      }
    });
  }
 _setupLocalNotification() async{

   await Future.delayed(const Duration(seconds: 6), () {
     var initializationSettingsAndroid =
     const AndroidInitializationSettings('@drawable/ic_notification');

     var initializationSettingsIOS =
     const DarwinInitializationSettings(
       requestAlertPermission: true,
       requestBadgePermission: true,
       requestSoundPermission: true,
     );

     var initializationSettings = InitializationSettings(
         android: initializationSettingsAndroid,
         iOS: initializationSettingsIOS,
         macOS: initializationSettingsIOS);
     // _flutterLocalNotificationsPlugin!.initialize(initializationSettings, onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
     _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onSelectNotification);
   });
  }


  void display(RemoteMessage message)async{
    print('message display ${message.data.toString()}');
    try{
      final int id = 100;
      //final int id = DateTime.now().microsecond ~/100000;
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
           autoCancel: true
        ),
        iOS: DarwinNotificationDetails(presentBadge: true),
      );
      DataNotifyModel data =DataNotifyModel.fromRemoteMessage(message);
      print('data ${data.toString()}');
      await _flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails,payload: data.toString());
      //await _flutterLocalNotificationsPlugin.show(1,' message.notification!.title', 'message.notification!.body', notificationDetails,payload: 'data.toString()');
    }on Exception catch(e){
      print('Error Notification $e');
    }

  }
  Future _onSelectNotification(dynamic payload) async {
    if (payload != null) {
      print('notification payload111:::::: ${payload.toString()}');
      await handlePayload(payload);
    }
  }

  Future onSelectNotification_(NotificationResponse payload) async {
    print('onSelectNotification 1 ${payload.payload}');
    if (payload != null) {
      print('notification payload:::::: 1  ${payload.payload}' );
      await  handlePayload(payload.payload.toString());
    }
  }
  // todo cách 2 xử lý payload
  Future _onDidReceiveNotificationResponse(NotificationResponse payload) async {
    if (payload != null) {
      //  print('notification payload:::::: ${payload.toString()}');
      //selectNotificationSubject.add(payload);
      await handlePayload(payload.payload.toString());
    }
  }
  handlePayload(String payload) async {
  //  print('payload $payload');
    DataNotifyModel data=  DataNotifyModel.fromPyload(payload);
    gotoDetailScreen(data);
  }
  _getDataDetail(RemoteMessage remoteMessage){
    DataNotifyModel data = DataNotifyModel.fromRemoteMessage(remoteMessage);
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