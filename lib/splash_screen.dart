import 'package:author_registration_app_firebase_miner3/utils/colours.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  initTime() async {
    await Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, "/");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/auther_app_logo.png",
              height: 150,
              width: 150,
            ),
            Text(
              "Author App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
