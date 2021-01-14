import 'package:flutter/material.dart';
import 'package:flutter_notifications/screens/home.dart';

import '../my_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
    );
  }
  @override
  void initState() {

    super.initState();
    checkLogin();
  }
  checkLogin(){
    Future.delayed(Duration(seconds: 3),()async{
      ///Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      Navigator.pushNamedAndRemoveUntil(context, TAG_HOME_SCREEN, (route) => false);
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      //     HomeScreen()), (Route<dynamic> route) => false);
    } );
  }
}
