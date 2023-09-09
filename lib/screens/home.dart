
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/model/data.dart';
import 'package:flutter_notifications/model/notification.dart';
import 'package:flutter_notifications/model/response_notification.dart';
import 'package:flutter_notifications/notification/notification_controller.dart';
import 'package:flutter_notifications/screens/setting.dart';

import '../my_router.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  String description ="";
  String content ="";
  String? token ="";
  late NotificationController  notificationController ;
  @override
  void initState() {
    super.initState();
    initNotification();
  }
  initNotification()async{
   // notificationController =NotificationController.getInstance(context: context);
    notificationController =NotificationController(context: context);
    notificationController.intiSetup();
     await notificationController.deviceToken().then((value) {
        setState(() {
          token =value;
        });
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
            Text("totken: "+token!,style: TextStyle(color: Colors.black, fontSize: 14),),

            SizedBox(height: 30,),
            InkWell(child: Text('godo detail'),onTap: (){
              //gotoDetail('Ahihihiih');

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

// https://stackoverflow.com/questions/60124063/is-it-possible-to-pass-parameter-on-onselectnotification-for-flutter-local-notif
// todo: https://github.com/JohannesMilke/local_push_notification_ii
// todo: tham khảo: https://medium.com/@nitishk72/flutter-local-notification-1e43a353877b
// todo: https://github.com/turcuciprian/coding_with_cip_video_apps/tree/master/flutter_local_notifications_example
}

