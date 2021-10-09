import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plnned/Utils/ConnectionStatusSingleton.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/initDynamicLink.dart';
import 'package:plnned/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import 'checkPurchaseAndroid.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  var userid;

  bool isOffline;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription _connectionChangeStream;

  @override
  void initState() {
    initMethod();
    super.initState();
  }

  Future initMethod() async {
    initPlatformState();
    if (Platform.isAndroid) {
      print("ankitjhfvjh");
      // await checkInAppPurchase();
    }
    initDynamicLinks(context: context);
    checkConnection();
  }

  Future<void> initPlatformState() async {
    String _platformVersion = 'Unknown';
    StreamSubscription _purchaseUpdatedSubscription;
    StreamSubscription _purchaseErrorSubscription;
    StreamSubscription _conectionSubscription;
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      if (Platform.isAndroid) {
        print('Purchased');
        print(productItem);
      }
    });

    bool status = await FlutterInappPurchase.instance.checkSubscribed(sku: 'in_app_purchase');
    print('subscribed or nottttttt' + status.toString());
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      if (isOffline) {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            content: new Text('Please Check your internet connectivity'),
          ),
        );
      } else {
        checkLogin();
      }
    });
  }

  Future checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isOffline = false;
        checkLogin();
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isOffline = false;
        checkLogin();
      });
    } else {
      setState(() {
        isOffline = true;
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Color(0xFFd32e2e), duration: Duration(days: 365), content: new Text('Please Check your internet connectivity')));
      });
    }
  }

  Future getSharedPrefData({String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    return data;
  }

  getUserData() async {
    token = await getSharedPrefData(key: 'token');
    userid = await getSharedPrefData(key: 'userid');
    print('My Token $token');
    print('My Useid $userid');
  }

  Future checkLogin() async {
    await getUserData();

    token == null
        ? Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            ),
          )
        : Timer(
            Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            ),
          );
  }

/*
  getUserData() async {
    SharedPreferences prefs = await SharedPreferenc
    es.getInstance();
    token = prefs.getString('token');
    userid = prefs.getString('userid');
    print('My Token $token');
    print('My Useid $userid');
  }
*/

  _getLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      checkConnection();
      ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
      _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [kPrimaryColor, kColorDark], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.0, 0.5])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Image.asset(
              'assets/ic_logo.png',
              width: 200.0,
              height: 200.0,
            ),
            Image.asset(
              'assets/ic_logo_name.png',
              width: 200.0,
              height: 110.0,
            ),
          ],
        ),
      ),
    );
  }
}
