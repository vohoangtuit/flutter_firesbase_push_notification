import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/model/data.dart';
import 'package:flutter_notifications/model/notification.dart';
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
  String title ="Firebase Notification ";
  String content ="";
  String totken ="";
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        setState(() {
          print("Called onLaunch");
          print(msg);
        });

      },
      onResume: (Map<String, dynamic> msg){
        setState(() {
          print("onResume "+msg.toString());
          PushNotification ns = PushNotification(title: msg['notification']['title'], body: msg['notification']['body']);
          print("PushNotification "+ns.toString());

          DataNotification data = DataNotification(
              type: msg['data']['type'],
              content: msg['data']['content']
          );
          content =data.content;
          print("data "+data.toString());
          switch (data.type) {
            case "detail":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(data.content)
                ),
              );
              break;
            case "settingc":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingPage(data.content)
                ),
              );
              break;
            default:
              break;
          }
        });


      },
        onMessage: (Map<String, dynamic> message)async{
        //  print("onMessage "+message.toString());//message {notification: {body: text message, title: title message}, data: {}}
          setState(() {
            print("onMessage "+message.toString());
            PushNotification ns = PushNotification(title: message['notification']['title'], body: message['notification']['body']);
           // PushNotification ns = PushNotification(title: message['title'], body: message['body']);
            print("PushNotification 1: "+ns.title);

            //DataNotification data = DataNotification(type: message['data']['type'], content: message['data']['content']);
            DataNotification data = DataNotification(type: message['type'], content: message['content']);
            print("data 1: "+data.type);
           // title =message["notification"]["title"];
            title =ns.title;
            content =data.content;

          });
        },
    );

    getTotken();

  }
  Future<String> getTotken()async{
   await _firebaseMessaging.getToken().then((value){
     setState(() {

     });
     totken =value;
     print("totken "+totken);
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
                title,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              SizedBox(height: 30,),
              Text(
                content,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              SizedBox(height: 30,),
              Text("totken: "+totken),
            ],
          ),
        ),
    );
  }

}


