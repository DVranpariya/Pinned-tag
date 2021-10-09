import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plnned/screens/LoginScreen.dart';
import 'package:plnned/screens/SplashScreen.dart';
import 'Utils/ConnectionStatusSingleton.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  runApp(Pinned());
}

class Pinned extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plnned',
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(brightness: Brightness.light),
        primaryColor: Colors.black,

//        scaffoldBackgr  oundColor:Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
