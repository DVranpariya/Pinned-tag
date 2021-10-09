import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/androidWrite.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/components/Simple_Button.dart';
import 'package:plnned/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivePinned extends StatefulWidget {
  @override
  _ActivePinnedState createState() => _ActivePinnedState();
}

class _ActivePinnedState extends State<ActivePinned> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ShortDynamicLink shortDynamicLink;
  String userName;
  String fallBackUrl;
  String firebaseLink;
  bool isBlock = false;

  @override
  void initState() {
    getFallBackDynamicLink();
    // TODO: implement initState
    super.initState();
  }

  Future getFallBackDynamicLink() async {
    userName = await getSharedPrefData(key: 'username');
    fallBackUrl = 'https://app.pinned.eu/pinned/api/$userName' + userName;
    createShortUrl();
    isSuccess();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kColorDark, kPrimaryColor], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.3, 0.9])),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Align(
                    alignment: Alignment.center,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Image.asset(
                          'assets/ic_mobile.png',
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                iconSize: 15,
                                icon: Image.asset(
                                  'assets/ic_cancel.png',
                                  height: 34,
                                  width: 34,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Column(
                          children: [
                            Text(
                              'Your Pinned will be activated with \n the profile',
                              textAlign: TextAlign.center,
                              style: kActivePinnedText,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SimpleButton(
                              onTap: () async {
                                print(firebaseLink);
                                if (firebaseLink != null) {
                                  print('Write on');

                                  if (isBlock == false) {
                                    androidWrite(context: context, fireBessDynamicLink: firebaseLink);
                                  } else {
                                    activePin();
                                  }
                                }
                              },
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 40,
                              shadowColor: kButtonColor,
                              buttonColor: kButtonColor,
                              textStyle: kLoginButtonText,
                              text: 'Tap here to activate',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future activePin() async {
    print('[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Active ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
    var userdata;
    var data;
    data = FormData.fromMap({
      'is_link_active': '1',
    });
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context, url: UNLINK_TAG, data: data);
    print(response);
    if (response != null) {
      userdata = response['body'];

      if (userdata['status'] == 1) {
        androidWrite(context: context, fireBessDynamicLink: firebaseLink);
      }
    } else {
      showToast('Something went wrong', context);
    }
    return;
  }

  Future isSuccess() async {
    var userdata;

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(
      context,
      url: ISUNBLOCK,
    );
    print(response);
    if (response != null) {
      userdata = response['body'];

      if (userdata['status'] == 1) {
        if (userdata['is_link_active'] == 0) {
          setState(() {
            isBlock = true;
          });
        }
      }
    } else {
      showToast('Something went wrong', context);
    }
    print(isBlock);
    return;
  }

  Future saveDynamicUrl({String dynamicLink}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('dynamicLink', dynamicLink);
    return;
  }

  Future<void> createShortUrl() async {
    print('https://app.pinned.eu/pinned/api/$userName');
    print('Dynamic Link');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://pinnednfc.page.link',
      link: Uri.parse('https://app.pinned.eu/pinned/get_user/$userName'),
      androidParameters:
          AndroidParameters(packageName: 'com.pinned', fallbackUrl: Uri.parse('https://app.pinned.eu/pinned/get_user/$userName'), minimumVersion: 1),
      iosParameters: IosParameters(
        fallbackUrl: Uri.parse('https://app.pinned.eu/pinned/get_user/$userName'),
        bundleId: 'com.pinned',
      ),
    );

    try {
      shortDynamicLink = await parameters.buildShortLink();
      firebaseLink = shortDynamicLink.shortUrl.toString();
    } on Exception catch (e) {
      print(e);
      // TODO
    }
    print(firebaseLink);
    print('short url');
  }
}
