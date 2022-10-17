import 'package:author_registration_app_firebase_miner3/splash_screen.dart';
import 'package:flutter/cupertino.dart';


import '../screens/home_screen/page/home_screen.dart';
import 'appRoutes.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes().homePage: (context) => HomePage(),
  AppRoutes().splashScreen: (context) => IntroScreen(),

};
