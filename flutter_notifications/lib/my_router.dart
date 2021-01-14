
import 'package:flutter/material.dart';
import 'package:flutter_notifications/screens/detail.dart';
import 'package:flutter_notifications/screens/home.dart';
import 'package:flutter_notifications/screens/setting.dart';
import 'package:flutter_notifications/screens/splash.dart';

const String TAG_SPLASH_SCREEN = '/';
const String TAG_HOME_SCREEN = '/home_screen';
const String TAG_SETTING_SCREEN = '/setting_screen';
const String TAG_DETAIL_SCREEN = '/detail_screen';
class  MyRouter {
  static  Route<dynamic> generateRoute(RouteSettings settings) {
    print('MyRouter ${settings.name}');
    switch (settings.name) {
      case TAG_SPLASH_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => SplashScreen());
        break;
      case TAG_HOME_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => HomeScreen());
        break;
      case TAG_SETTING_SCREEN:
        var data = settings.arguments as String;
        return MaterialPageRoute(settings: settings,builder: (_) => SettingPage(data));
        break;
      case TAG_DETAIL_SCREEN:
        var data = settings.arguments as String;
        return MaterialPageRoute(settings: settings,builder: (_) => DetailPage(data));
        break;
    }
  }
}

