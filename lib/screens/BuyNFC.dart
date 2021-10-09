import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/DrawerCustom.dart';
import 'package:webview_flutter/webview_flutter.dart';

class buyNfc extends StatefulWidget {
  @override
  _buyNfcState createState() => _buyNfcState();
}

class _buyNfcState extends State<buyNfc> {
  num position = 1;
  bool isLoading = true;
  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  Completer<WebViewController> _controller = Completer<WebViewController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: DrawerCustom(
            currentIndex: 2,
            onTap: () {
              Navigator.pop(context);
            }),
        appBar: AppBar(
          brightness: Brightness.light,
          // or use Brightness.dark
          backgroundColor: kPrimaryColor,

          elevation: 0.5,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Pinned',
            style: TextStyle(
              letterSpacing: 0.5,
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'bold',
            ),
          ),
          leading: IconButton(
            icon: Image.asset(
              'assets/menuicon.png',
              height: 20,
              width: 20,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: 'https://www.pinned.eu/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageFinished: (finsih) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  )
                : Stack(),
          ],
        ));
  }
}
