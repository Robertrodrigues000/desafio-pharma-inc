import 'package:flutter/material.dart';
import 'package:pharmaapp/constants/colors.dart';
import 'package:pharmaapp/screens/splash_screen.dart';
import 'package:pharmaapp/screens/users_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: AppColors.jadeGreen,
            bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent)),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/listScreen': (context) => UsersListScreen(),
        },
      ),
    );
  }
}
