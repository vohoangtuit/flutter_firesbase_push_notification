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
  String title ="";
  String content ="";
  String totken ="";
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async{
        setState(() {
          print("Called onLaunch");
          print("onLaunch $msg");
        });
      },
      onResume: (Map<String, dynamic> msg)async{
          print("onResume $msg");
          PushNotification pushNotification = PushNotification.fromJson(msg);
          print("PushNotification $pushNotification");

          DataNotification data = DataNotification.fromJson(msg);


          print("title 1 : $title - content 1: $content");
         // gotoDetailScreen(data);
        setState(() {
          title =pushNotification.title;
          content =data.content;
        });

      },
        onMessage: (Map<String, dynamic> message)async{

          //setState(() {
            print("onMessage "+message.toString());
            PushNotification pushNotification = PushNotification.fromJson(message);

            print("PushNotification 1: "+pushNotification.title);

            DataNotification data = DataNotification.fromJson(message);

            print("data 1: "+data.type);
            print("title : $title - content: $content");
           // gotoDetailScreen(data);
            setState(() {
              title =pushNotification.title;
              content =data.content;
            });

         // });
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
                "Title: $title",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              SizedBox(height: 30,),
              Text(
                "Content: $content",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              SizedBox(height: 30,),
              Text("totken: "+totken,style: TextStyle(color: Colors.black, fontSize: 14),),
            ],
          ),
        ),
    );
  }

  void gotoDetailScreen(DataNotification dataNotification){
    switch (dataNotification.type) {
      case "detail":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(dataNotification.content)
          ),
        );
        break;
      case "setting":
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingPage(dataNotification.content)
          ),
        );
        break;
      default:
        break;
    }
  }
}


