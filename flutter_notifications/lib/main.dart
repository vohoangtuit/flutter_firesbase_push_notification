import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/model/data.dart';
import 'package:flutter_notifications/model/notification.dart';
import 'package:flutter_notifications/model/response_notification.dart';
import 'package:flutter_notifications/screens/detail.dart';
import 'package:flutter_notifications/screens/setting.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  String description ="";
  String content ="";
  String token ="";
  @override
  void initState() {
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async{
        setState(() {
          print("Called onLaunch");
          print("onLaunch $message");
          PushNotification pushNotification = PushNotification.fromJson(message);
          DataNotification data;
          if(Platform.isIOS){
            data = DataNotification.fromJsonIOS(message);
          }else{
            data = DataNotification.fromJson(message);
          }
          ResponseNotification responseNotification =  ResponseNotification(pushNotification,data);
          gotoDetailScreen(responseNotification);
        });
      },

      onResume: (Map<String, dynamic> message)async{
        print("onResume $message");
        PushNotification pushNotification = PushNotification.fromJson(message);

        DataNotification data;
        if(Platform.isIOS){
          data = DataNotification.fromJsonIOS(message);
        }else{
          data = DataNotification.fromJson(message);
        }
        ResponseNotification responseNotification =  ResponseNotification(pushNotification,data);
        gotoDetailScreen(responseNotification);
        setState(() {
          description =data.description;
          content =data.content;
        });

      },
      onMessage: (Map<String, dynamic> message)async{
        setState(() {
          print("onMessage "+message.toString());
          PushNotification pushNotification = PushNotification.fromJson(message);

         // print("PushNotification 1: "+pushNotification.title);
          DataNotification data;
          if(Platform.isIOS){
            data = DataNotification.fromJsonIOS(message);
          }else{
            data = DataNotification.fromJson(message);
          }
         // print("data 1: "+data.type);
        //  print("title : $description - content: $content");
          ResponseNotification responseNotification =  ResponseNotification(pushNotification,data);
        //  showBannerNewNotify(responseNotification);
          _showBannerNewNotify(responseNotification);

          description =pushNotification.title;
          content =data.content;
//            });

        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });

    getToken();

  }
  Future<String> getToken()async{
    await _firebaseMessaging.getToken().then((value){
      setState(() {

      });
      token =value;
      print("token "+token);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Firebase Notification')),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Description: $description",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            SizedBox(height: 30,),
            Text(
              "Content: $content",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
            SizedBox(height: 30,),
            Text("totken: "+token,style: TextStyle(color: Colors.black, fontSize: 14),),
          ],
        ),
      ),
    );
  }

   gotoDetailScreen(ResponseNotification responseNotification){
    switch (responseNotification.dataNotification.type) {
      case "detail":
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => DetailPage(responseNotification.dataNotification.description)),
          ModalRoute.withName('/'),
        );
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => DetailPage(dataNotification.content)
//            ),
//        );
        break;
      case "setting":
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => SettingPage(responseNotification.dataNotification.description)),
          ModalRoute.withName('/'),
        );
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (context) => SettingPage(dataNotification.content)
//          ),
//        );
        break;
      default:
        break;
    }
  }
  showBannerNewNotify(ResponseNotification responseNotification)async{
    var android = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);

    await flutterLocalNotificationsPlugin.show(
        0, responseNotification.notification.title, responseNotification.notification.body, platform);
  }
  // todo: other solution
  _showBannerNewNotify(ResponseNotification responseNotification)async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);

   // flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
//
//
    var android1 = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'channel DESCRIPTION',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker',
      ongoing: false,autoCancel: false
    );
//
   var ios1 = new IOSNotificationDetails();
    var platform = new NotificationDetails(android1, ios1);
    await flutterLocalNotificationsPlugin
        .show(0, responseNotification.notification.title, responseNotification.notification.body, platform, payload: responseNotification.notification.toString());

  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
    }
    await Navigator.pushAndRemoveUntil(context,
         MaterialPageRoute(builder: (context) => new DetailPage('iiu')),ModalRoute.withName('/'));
  }
// todo: https://github.com/JohannesMilke/local_push_notification_ii
  // todo: tham khảo: https://medium.com/@nitishk72/flutter-local-notification-1e43a353877b
// todo: https://github.com/turcuciprian/coding_with_cip_video_apps/tree/master/flutter_local_notifications_example
}


