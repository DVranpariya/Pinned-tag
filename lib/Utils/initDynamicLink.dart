import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:plnned/screens/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Constant.dart';
import 'network_dio.dart';

Future initDynamicLinks({BuildContext context}) async {
  Uri deepLink;
  FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
    print('----------------on Link -----------------');
    Uri deepLink;

    deepLink = dynamicLink?.link;
    print(deepLink.toString() + 'My deep link');
    if (dynamicLink.link != null) {
      String username = Uri.decodeFull(deepLink.toString().replaceAll('https://app.pinned.eu/pinned/get_user/', ''));

      print(username.toLowerCase() + 'My user name');
      await getUserSocialLink(username: username, context: context);
    }
  }, onError: (OnLinkErrorException e) async {
    print('onLinkError');
    print(e.message);
  });

  final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
  print('----------------intial -----------------');
  if (data.link != null) {
    deepLink = data?.link;
    print(deepLink.toString() + 'My deep link');
    String username = Uri.decodeFull(deepLink.toString().replaceAll('https://app.pinned.eu/pinned/get_user/', ''));

    print(username.toLowerCase() + 'My user name');
    await getUserSocialLink(username: username, context: context);
  }
}

Future getUserSocialLink({String username, BuildContext context}) async {
  var userdata;
  print('< -------------------------');
  print(username + '< -------------------------');
  var data = ({
    'name': username,
  });

  NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL_NODE);
  var response = await NetworkDioHttp.postDioHttpMethod(
    context,
    url: GET_USER_BY_USERNAME,
    data: data,
  );
  print(response);
  if (response != null) {
    userdata = response['body'];
    print("Ankit----->$response");
    if (userdata['status'] == 1) {
      redirectSelector(
        username: username,
        randomNumber: '${userdata['random_number']}',
        redirectUrl: '${userdata['link']}',
        socialLink: '${userdata['social_link']}',
        socialId: '${userdata['social_id']}',
      );
      print('u yehhhhhhhh');
    }
  } else {
    showToast('Something went wrong', context);
  }
  return;
}

_launchASURL({String url}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchASURL({String urlq}) async {
  print('LAUNCH URL: $urlq');

  if (await canLaunch(urlq)) {
    await launch(urlq, forceWebView: false, forceSafariVC: false);
  } else {
    throw 'Could not launch $urlq';
  }
}

Future redirectSelector({String socialId, String socialLink, String redirectUrl, String username, String randomNumber}) async {
  if (socialId == '2') {
    launchASURL(urlq: redirectUrl);

    // facebookRedirection(socialLink: socialLink, redirectUrl: redirectUrl);
  } else if (socialId == '5') {
    _launchASURL(url: 'mailto:' + socialLink.toString());
  } else if (socialId == '10') {
    saveContact(phoneNumber: socialLink.toString(), userName: username);
  } else {
    print('--------------');
    /*if (socialId == '51' || socialId == '52') {
      launchASURL(urlq: socialLink);
    } else {
      launchASURL(urlq: redirectUrl);
    }*/
    launchASURL(urlq: redirectUrl);
  }
}

saveContact({String userName, String phoneNumber}) {
  HomeScreenState().saveContact(username: userName, mobileno: phoneNumber);
}

Future facebookRedirection({String redirectUrl, String socialLink}) async {
  var sp;
  try {
    print(redirectUrl + 'url  of data');

    sp = await AppAvailability.checkAvailability("fb://");
    if (sp != null) {
      print(redirectUrl + 'url  of data');
      AppAvailability.launchApp("$redirectUrl");
    } else {
      print('https://www.facebook.com/profile/' + socialLink);
      _launchASURL(url: 'https://www.facebook.com/profile.php?id=' + socialLink);
      print('https://www.facebook.com/profile/' + socialLink);
    }
  } on Exception catch (e) {
    print(e);
    AppAvailability.launchApp("$redirectUrl");

    launchASURL(
      urlq: 'https://www.facebook.com/profile.php?id=' + socialLink,
    );
  }
  return;
}

Future mailRedirection({String redirectUrl, String socialLink}) async {
  print('2000');
  launchASURL(urlq: 'mailto:$redirectUrl');
  // AppAvailability.launchApp('mailto:$redirectUrl');
  print('mailto:$redirectUrl');
  return;
}
