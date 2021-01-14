import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/model/data.dart';
import 'package:flutter_notifications/model/notification.dart';
import 'package:flutter_notifications/model/response_notification.dart';
import 'package:flutter_notifications/screens/setting.dart';

import '../my_router.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  String description ="";
  String content ="";
  String token ="";
  @override
  void initState() {
    super.initState();
    initNotification();
  }
  initNotification(){
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
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
          ResponseNotification responseNotification =  ResponseNotification(notification:pushNotification,dataNotification:data);
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
        ResponseNotification responseNotification =  ResponseNotification(notification:pushNotification,dataNotification:data);
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

          ResponseNotification responseNotification =  ResponseNotification(notification:pushNotification,dataNotification:data);
          //showBannerNewNotify(responseNotification);
          _showNotification(responseNotification);

          description =pushNotification.title;
          content =data.content;
//            });

        });
      },
    );

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
        title: (Text('Firebase Notification HOME')),
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

            SizedBox(height: 30,),
            InkWell(child: Text('godo detail'),onTap: (){
              gotoDetail('Ahihihiih');

            },),

            SizedBox(height: 30,),
            InkWell(child: Text('godo setting'),onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (content)=>SettingPage('content')));

            },)
          ],
        ),
      ),
    );
  }
  Future _showNotification(ResponseNotification responseNotification) async {/// todo: khi app opening thì sẽ vào đây
    //print("responseNotification:  "+responseNotification.toJson().toString());
    DataNotification data = DataNotification.fromResponse(responseNotification);
    print("data description::::: "+data.description);
    print("data toJson()::::: "+data.toJson().toString());

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High,autoCancel: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        5, responseNotification.notification.title, responseNotification.notification.body, platformChannelSpecifics,
        payload: responseNotification.dataNotification.description);
  }
  Future onSelectNotification(String payload) async {//todo: convert model to json rồi gửi qua screen khác, vì ko gửi model dc
    if (payload != null) {
      print('notification payload:::::: ' + payload);
    }
    // await Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (context) => new DetailPage(payload)),ModalRoute.withName('/'));
    gotoDetail(payload);
  }
  gotoDetail(String titile){
    var route =ModalRoute.of(context).settings.name;
    print('route: $route');
    if(Navigator.canPop(context)){
      print('can pop');
      Navigator.popUntil(context,
        ModalRoute.withName(TAG_HOME_SCREEN),
      );
    }else{
      print(' can not pop');
    }
    Navigator.pushNamed(context, TAG_DETAIL_SCREEN,arguments: 'asaadwdedwe');
  }
  showBannerNewNotify(ResponseNotification responseNotification)async{
    var android = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        autoCancel: true
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);

    await flutterLocalNotificationsPlugin.show(
        0, responseNotification.notification.title, responseNotification.notification.body, platform);
  }
  gotoDetailScreen(ResponseNotification responseNotification){
    switch (responseNotification.dataNotification.type) {
      // todo https://www.developerlibs.com/2018/09/flutter-push-and-pop-navigation.html
      case "detail":
        // Navigator.pushAndRemoveUntil(context,
        //   MaterialPageRoute(builder: (BuildContext context) => DetailPage(responseNotification.dataNotification.description)),
        //   ModalRoute.withName(TAG_HOME_SCREEN),
        // );
        gotoDetail(responseNotification.dataNotification.description);
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
// https://stackoverflow.com/questions/60124063/is-it-possible-to-pass-parameter-on-onselectnotification-for-flutter-local-notif
// todo: https://github.com/JohannesMilke/local_push_notification_ii
// todo: tham khảo: https://medium.com/@nitishk72/flutter-local-notification-1e43a353877b
// todo: https://github.com/turcuciprian/coding_with_cip_video_apps/tree/master/flutter_local_notifications_example
}

