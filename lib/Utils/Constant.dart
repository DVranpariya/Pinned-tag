import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

final kPrimaryColor = Color(0xFFED2A67);
final kColorDark = Color(0xFF191919);
final kColorGoogleButton = Color(0xFFFF5065);
final kColorPurchaseButton = Color(0xffE62864);
final kColorFBButton = Color(0xFF2672CA);
final kColorAppleButton = Color(0xFFFFFFFF);
final kDarkPrimaryColor = Color(0xFF9f2414);
final kLightGreyColor = Color(0xFFd6d6d6);
final kLightBlackColor = Color(0xFF3a3a3a);
final kLightSilverColor = Color(0xFFb4bbc1);
final kGreenColor = Color(0xFF007944);
final kGreenTick = Color(0xFF4ACB00);
final kYellowTick = Color(0xFFFF9A3B);
final kLightGreenColor = Color(0xFF6fe48f);
final kGreyColor = Color(0xFFdddbdc);
final kDarkGreyColor = Color(0xFFa4a4a4);
final kBlueColor = Color(0xFF5886f5);
final kLightPurpleColor = Color(0xFF42425B);
final kDashedColor = Color(0xFF707070);
final kFullLightGreyColor = Color(0xFFF2F2F2);
final kYellowLightColor = Color(0xFFffba79);
final kCardOrangeColor = Color(0xFFF7E3D0);
final kDarkGreenColor = Color(0xFF004445);
final kSkyBlueColor = Color(0xFFf7f9fc);
final kGreyTextColor = Color(0xFF6f6f6f);
final kLightPrimaryColor = Color(0xFF9F2414);
final KBlackDullText = Color(0xFF54546B);
final kDull = Color(0xFFe1e1e1);
final kButtonColor = Color(0xFFE62864);

// const BASE_URL = 'https://app.pinned.eu/pinned/api/'; //edited by milan
const BASE_URL = 'http://159.89.145.112/pinned/api/'; // parth
const BASE_URL_NODE = 'http://159.89.145.112:3000/';
const LOGIN = 'login_by_thirdparty';
const ADD_RECIEPT = 'add_reciept';
const UPDATE_SUBSCRIPTION = 'update_subscription';
const USER_PROFILE = 'update_profile';
const LIST_SOCIAL_PLATFORM = 'list_social_platform';
const UPDATE_PROFILE = 'update_profile';
const GET_PROFILE = 'get_user_detail';
const ADD_PROFILE_INFO = 'add_business_info';
const ISUNBLOCK = 'get_link_active_status';
const UPDATE_PIN = 'update_link_status';
const ADD_USER_SOCIAL_LINK = 'add_user_social_link';
const DELETE_USER_SOCIAL_LINK = 'delete_social_link';
const GET_USER_SOCIAL_LINK = 'get_user_social_link';
const GET_BUSINESS_INFO = 'get_business_info';
const GET_BUSINESS_SUBSCRIPTION = 'buy_business_subscription';
const UPDATE_FIRST = 'update_is_first';
const GET_USER_BY_USERNAME = 'get_user_by_username';
const UNLINK_TAG = 'update_link_status';
const LOGOUT = 'logout';
const tagWriteMessage = 'Hold your iphone near the Pinned';
const venmoHint = 'Open the Venmo app and tap on the profile in the top right corner. Find Your share profile url and Copy/paste here.';
const venmoUserNameHint = "Open the Venmo app and tap on the profile in the top right corner. Find Your username and Copy/paste here.";
const scanQrText = "Scan this code with any camera \n to share your pinned profile";

String userProfileStatic;
String businessProfileStatic;

String userNameStatic;
String isLink;
bool isPurchaseStatus;

String getdeviceId() {
  if (Platform.isIOS) {
    return '1';
  } else if (Platform.isAndroid) {
    return '0';
  }
}

Future savePreferenceData({String key, value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

bool isValidate({
  String email,
  String name,
  String web,
  String phoneNumber,
  BuildContext context,
}) {
  if (email.isEmpty) {
    return showToast('Enter your business E-mail', context);
  } else if (name.isEmpty) {
    return showToast('Enter your business Name', context);
  } else if (web.isEmpty) {
    return showToast('Enter your business Website', context);
  } else if (phoneNumber.isEmpty) {
    return showToast('Enter your business Phone Number', context);
  } else {
    return true;
  }
}

saveISSharedData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('link', 'Link');
}

shareProfile(String userName) {
  Share.share('check out my Pinned profile https://app.pinned.eu/pinned/get_user/$userName');
  print(userName);
}

shareUrl(String url) {
  Share.share(url);
  print(url);
}

final kTextStyleLightBlackMedium = TextStyle(
  fontSize: 23.0,
  color: Colors.white,
  fontFamily: 'alien',
  letterSpacing: 1,
  decoration: TextDecoration.none,
);

final kTextStyleLightBlackMediumPopin = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontFamily: 'PoppinsMedium',
  // letterSpacing: 1,
  decoration: TextDecoration.none,
);

final kLoginButtonText = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kSocialText = TextStyle(
  fontSize: 17.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kActivePinnedText = TextStyle(
  fontSize: 17.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kDrawerText = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kDrawerTextName = TextStyle(
  fontSize: 19.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kDrawerTextPop = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'PoppinsMedium',
  decoration: TextDecoration.none,
);

final kDrawerBottomText = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton.withOpacity(0.5),
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kLoginButtonTextBlack = TextStyle(
  fontSize: 14.0,
  color: kColorDark,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);
final kEditInput = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kLogoutTextBlack = TextStyle(
  fontSize: 17.0,
  color: kColorDark,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);
final kBusinessBold = TextStyle(
  fontSize: 22.0,
  color: kColorAppleButton,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kBigTextBlack = TextStyle(
  fontSize: 16.0,
  color: kColorDark,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kSmallTextBlack = TextStyle(
  fontSize: 14.0,
  color: kColorDark,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kSmallTextGray = TextStyle(
  fontSize: 14.0,
  color: kDarkGreyColor,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kSmallTextGrayHint = TextStyle(
  fontSize: 14.0,
  color: kDarkGreyColor,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kLoginTerms = TextStyle(
  fontSize: 15.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.underline,
);
final kBusinessTerms = TextStyle(
  fontSize: 15.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kidText = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kidTextPop = TextStyle(
  fontSize: 15.0,
  color: kColorAppleButton,
  fontFamily: 'PoppinsRegular',
  decoration: TextDecoration.none,
);

final kQrCodeText = TextStyle(
  fontSize: 20.0,
  color: Colors.black,
  fontWeight: FontWeight.w900,
  fontFamily: 'PoppinsRegular',
  decoration: TextDecoration.none,
);

final kQrCodeUserName = TextStyle(
  fontSize: 17.0,
  color: Colors.white,
  fontWeight: FontWeight.w900,
  fontFamily: 'PoppinsRegular',
  decoration: TextDecoration.none,
);

final kQrCodeTextSmall = TextStyle(
  fontSize: 10.0,
  color: Colors.black,
  fontFamily: 'PoppinsRegular',
  decoration: TextDecoration.none,
);

final kIconText = TextStyle(
  fontSize: 15.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kMyLinksBigText = TextStyle(
  fontSize: 17.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kMyLinksBigTextPop = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton,
  fontFamily: 'PoppinsRegular',
  decoration: TextDecoration.none,
);

final kPurchaseBusiness = TextStyle(
  fontSize: 19.0,
  color: kColorAppleButton,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kAppBar = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'PoppinsRegular',
  decoration: TextDecoration.none,
);

final kidTextHome = TextStyle(
  fontSize: 12.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);
final kEmailText = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kLabelText = TextStyle(
  fontSize: 12.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);
final kHeadLabelText = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);
final kHeadLabelSmallText = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kMainText = TextStyle(
  fontSize: 14.0,
  color: kColorAppleButton,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

final kEditProfileText = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);
final kEditText = TextStyle(
  fontSize: 16.0,
  color: kColorAppleButton,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kInputTextStyleCabin = TextStyle(
  fontSize: 14.0,
  color: Color(0XFF091F1D),
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kInputTextStyletTwo = TextStyle(
  fontSize: 14.0,
  color: Colors.white,
  fontFamily: 'flatosemiboald',
  decoration: TextDecoration.none,
);

final kInputHint = TextStyle(
  fontSize: 14.0,
  color: Colors.grey,
  fontFamily: 'flatoregular',
  decoration: TextDecoration.none,
);

showToast(String msg, BuildContext context) {
  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}

Future getSharedPrefData({String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key);
  return data;
}

Future getSharedPrefData1({String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getInt(key);
  return data;
}

Future saveSharedPrefData({String key, bool value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future saveSharedPrefData1({String key, int value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

launchASURL({String url}) async {
  if (await canLaunch(url)) {
    await launch(
      url,
    );
  } else {
    throw 'Could not launch $url';
  }
}
