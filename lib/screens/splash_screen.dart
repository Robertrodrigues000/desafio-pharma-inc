import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {Navigator.pushNamed(context, '/second');},
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
      ),
    );
  }
}
