import 'package:author_registration_app_firebase_miner3/utils/appRoutes.dart';
import 'package:author_registration_app_firebase_miner3/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Author registration app",
      //home: HomePage(),
      initialRoute: AppRoutes().splashScreen,
      routes: routes,
    );
  }
}
