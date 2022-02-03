import 'dart:ui';

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
                AppColors.jadeGreen,
                Colors.white,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/listScreen'),
            child: Center(
              child: Container(
                width: 300,
                child: Stack(children: [
                  Opacity(
                      child: Image.asset(
                        "assets/images/noBackgroundLogo.png",
                        color: Colors.black,
                        fit: BoxFit.contain,
                        width: 300,
                      ),
                      opacity: 0.2),
                  ClipRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Image.asset(
                            "assets/images/noBackgroundLogo.png",
                            fit: BoxFit.contain,
                            width: 300,
                          )))
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
