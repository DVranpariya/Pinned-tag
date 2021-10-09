import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Constant.dart';

Future  facebookLogin(BuildContext context) async {
  var facebookData;
  final FacebookLogin facebookSignIn = new FacebookLogin();
  facebookSignIn.loginBehavior = FacebookLoginBehavior.nativeWithFallback;

  final FacebookLoginResult result =
      await facebookSignIn.logIn(['email', 'public_profile']);
  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final FacebookAccessToken accessToken = result.accessToken;

      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');

      return facebookData = jsonDecode(graphResponse.body);
      break;
    case FacebookLoginStatus.cancelledByUser:
      print('Cancel by user');
      break;
    case FacebookLoginStatus.error:
      print(result.errorMessage);
      print(
          'Something went wrong with the login process.\n'
          'Here\'s the error Facebook gave us: ${result.errorMessage}',);
      break;
  }
  return facebookData;
}
