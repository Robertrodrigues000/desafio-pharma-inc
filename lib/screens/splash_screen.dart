import 'package:flutter/material.dart';
import 'package:pharmaapp/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.deepBlue,
                AppColors.jadeGreen,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/listScreen'),
            child: Center(
              child: Container(
                // color: Colors.white,
                width: 360,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
