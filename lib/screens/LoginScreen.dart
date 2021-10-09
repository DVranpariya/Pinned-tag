import 'dart:async';
import 'dart:io';
import 'package:device_id/device_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/FacebookLogin.dart';
import 'package:plnned/Utils/GoogleLogin.dart';
import 'package:plnned/Utils/appleLogin.dart';
import 'package:plnned/Utils/process_indicator.dart';
import 'package:plnned/components/Login_Shadow_button.dart';
import 'package:plnned/screens/HomeScreen.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var responseData;
  String deviceId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    deviceInfo();
    // TODO: implement initState
    super.initState();
  }

  deviceInfo() async {
    deviceId = await DeviceId.getID;
  }

  String getdeviceId() {
    if (Platform.isIOS) {
      return '1';
    } else if (Platform.isAndroid) {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [kPrimaryColor, kColorDark], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.0, 0.5])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 80,
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
              SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ColorShadowButton(
                      onTap: () {
                        try {
                          googleLogin(context).then((value) => {
                                if (value != null)
                                  {
                                    login(
                                      profilePic: value.photoUrl,
                                      thirdPartyId: value.id,
                                      email: value.email,
                                      username: value.displayName,
                                    )
                                  }
                              });
                        } on Exception catch (e) {
                          // TODO
                        }
                      },
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      shadowColor: kColorGoogleButton,
                      buttonColor: kColorGoogleButton,
                      textStyle: kLoginButtonText,
                      text: 'Connect With Google',
                      icon: 'assets/ic_google.png',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ColorShadowButton(
                      onTap: () {
                        facebookLogin(context).then((value) => {
                              if (value != null)
                                {
                                  print(value.toString()),
                                  login(
                                    profilePic: value['picture']['data']['url'],
                                    thirdPartyId: value['id'],
                                    email: value['email'],
                                    username: value['name'],
                                  )
                                }
                            });
                      },
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      shadowColor: kColorFBButton,
                      buttonColor: kColorFBButton,
                      textStyle: kLoginButtonText,
                      text: 'Connect With Facebook',
                      icon: 'assets/ic_fb.png',
                    ),
                  ),
                  Platform.isIOS
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ColorShadowButton(
                            onTap: () {
                              appleSignIn().then((credential) => {
                                    login(
                                        thirdPartyId: credential.userIdentifier,
                                        profilePic: 'profilePic',
                                        email: credential.email == null ? credential.userIdentifier.substring(0, 8) + '@gmail.com' : credential.email,
                                        username: credential.givenName == null ? 'user@' + credential.userIdentifier.substring(0, 4) : credential.givenName)
                                  });
                            },
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            shadowColor: kColorAppleButton,
                            buttonColor: kColorAppleButton,
                            textStyle: kLoginButtonTextBlack,
                            text: 'Sign in with Apple',
                            icon: 'assets/ic_apple.png',
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launchASURL(url: 'https://app.pinned.eu/pinned/terms_of_use');
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Terms of use',
                            style: kLoginTerms,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchASURL(url: 'https://app.pinned.eu/pinned/privacy_policy');
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Privacy Policy',
                            style: kLoginTerms,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future login({String thirdPartyId, username, email, profilePic, deviceToken}) async {
    var data = FormData.fromMap({
      'thirdparty_id': thirdPartyId,
      'username': username,
      'email': email,
      'profilePic': profilePic,
      'device_id': deviceId,
      'device_type': getdeviceId(),
      'device_token': 'token',
    });

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);

    var response = await NetworkDioHttp.postDioHttpMethod(context, url: LOGIN, data: data);

    print('response--->');
    print(response);
    if (response != null) {
      setState(() {
        responseData = response['body'];
      });
      if (responseData != null) {
        if (responseData['status'] == 1) {
          await setUserData();
          showToast('${responseData['msg']}', context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          showToast('${responseData['msg']}', context);
        }

        print('Login---> ' + response['body'].toString());
      }
    } else {
      print('response null--->');

      showToast('Something went wrong', context);
    }
  }

  Future setUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', responseData['data']['user']['id'].toString());
    prefs.setString('userprofile', responseData['data']['user']['profile_pic']);
    prefs.setString('useremail', responseData['data']['user']['email']);
    prefs.setString('userdisplayname', responseData['data']['user']['name']);
    prefs.setString('token', responseData['data']['token']);
    prefs.setString('username', responseData['data']['user']['username']);
    prefs.setString('bio', responseData['data']['user']['user_bio']);
    prefs.setBool('switch', responseData['data']['user']['is_business_profile'] == 1 ? true : false);
    print(responseData['data']['user']['name']);
    print(responseData['data']['user']['id'].toString());
    print(responseData['data']['user']['email']);
    print(responseData['data']['user']);
    print(responseData['data']['token']);
  }
}
