import 'package:device_id/device_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plnned/Utils/BusinessInfoPage.dart';
import 'package:plnned/components/Round_Corner_Image.dart';
import 'package:plnned/modal/MenuItem.dart';
import 'package:plnned/screens/ActivePinnedScreen.dart';
import 'package:plnned/screens/BuyNFC.dart';
import 'package:plnned/screens/HomeScreen.dart';
import 'package:plnned/screens/LoginScreen.dart';
import 'package:plnned/screens/ProfileScreen.dart';
import 'package:plnned/screens/TutorialScreen.dart';
import 'package:plnned/screens/inAppPurchaseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant.dart';
import 'UnlinkPinnedTag.dart';
import 'network_dio.dart';

bool deActive = false;

class DrawerCustom extends StatefulWidget {
  final Function onTap;
  final currentIndex;

  DrawerCustom({this.onTap, this.currentIndex});

  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  String userName = '';
  String userProfile = ' ';
  String isBusiness = '0';
  var bImage;
  bool isBlock = false;
  bool status = false;
  int unlinkCount;

  String isLink = 'Unlink Pinned';
  String iconActive = 'assets/ic_unlink.png';

  List<MenuItem> mainMenu = [
    MenuItem("Home", "assets/ic_home.png", 0),
    MenuItem("My Profile ", "assets/ic_profile.png", 1),
    MenuItem("Switch to business", "assets/ic_buy.png", 8),
    MenuItem("Buy Pinned", "assets/ic_buy.png", 2),
    MenuItem("Unlink Pinned", "assets/ic_unlink.png", 3),
    MenuItem("Activate Pinned", "assets/ic_active.png", 4),
    MenuItem("Tutorial", "assets/ic_tutorials.png", 5),
    MenuItem("Log out", "assets/ic_logout.png", 6),
  ];

  List<MenuItem> businessMainMenu = [
    MenuItem("Home", "assets/ic_home.png", 0),
    MenuItem("My Profile ", "assets/ic_profile.png", 1),
    MenuItem("My Business Profile ", "assets/ic_business_icon.png", 7),
    MenuItem("Buy Pinned", "assets/ic_buy.png", 2),
    MenuItem("Unlink Pinned", "assets/ic_unlink.png", 3),
    MenuItem("Activate Pinned", "assets/ic_active.png", 4),
    MenuItem("Tutorial", "assets/ic_tutorials.png", 5),
    MenuItem("Log out", "assets/ic_logout.png", 6),
  ];

  Future isSuccess() async {
    var userdata;

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.tempPostDioHttpMethod(
      url: ISUNBLOCK,
    );
    print(response);
    if (response != null) {
      userdata = response['body'];
      if (userdata['status'] == 1) {
        print('-0-----------------------------');
        if ('${userdata['is_link_active']}' == '0') {
          print('------------?/////////////');
          setState(() {
            isLink = 'Link Pinned';
            iconActive = 'assets/link.png';
            deActive = true;
          });
          print(isLink);
        } else if ('${userdata['is_link_active']}' == '1') {}
      }
    } else {
      showToast('Something went wrong', context);
    }
    print(isBlock);
    return;
  }

  @override
  void initState() {
    getPinCounter();
    getPreferenceData();
    getISSharedData();
    print('businessProfileStatic: $businessProfileStatic');
    // TODO: implement initState
    super.initState();
  }

  getISSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    status = preferences.getBool('switch') ?? false;
    setState(() {
      unlinkCount = status == true ? 4 : 3;
    });
  }

  Future getPreferenceData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('userdisplayname');
      userProfile = pref.getString('userprofile');
      isBusiness = pref.getString('is_business_profile');
    });
    print('isBusinessssssssss:  $isBusiness');
    isSuccess();
    return;
  }

  var businessProfileStatic1;
  Future getPinCounter() async {
    var userdata;
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(
      context,
      url: GET_PROFILE,
    );
    setState(() {
      userdata = response['body']['data'];
    });

    if ('${userdata['is_business_profile']}' == '0') {
      setState(() {
        businessProfileStatic1 = userdata['business_profile_pic'] ?? ' ';
        userProfile = userdata['profile_pic'];
      });
      print(userProfile);
    } else {
      setState(() {
        businessProfileStatic1 = userdata['business_profile_pic'] ?? ' ';
        userProfile = userdata['profile_pic'];
      });
    }
    setState(() {
      userProfileStatic = userProfile;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kColorDark, kPrimaryColor],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(6.0),
                      child: RoundCornerImage(
                        height: 120,
                        placeholder: 'ic_profile_placeholder.png',
                        width: 120,
                        image: isBusiness == '1'
                            ? businessProfileStatic1 ?? ''
                            : userProfile ?? '',
                        circular: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/ic_cancel.png',
                              height: 30, width: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    userNameStatic ?? '',
                    style: kDrawerTextName,
                  ),
                ),
/*                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Switch to Business',
                        style: kDrawerText,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (status == false) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => InAppPurchaseScreen()));
                          } else {
                            showToast('Already in business', context);
                          }
                        },
                        child: Image.asset(
                          status == false ? 'assets/ic_inactiveswitch.png' : 'assets/ic_activeswitch.png',
                          height: 40,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                ),*/
                SizedBox(
                  height: 10,
                ),
                /*Expanded(
                  child: ListView.builder(
                    itemCount: status != true ? mainMenu.length : businessMainMenu.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return DrawerTile(
                        status: status,
                        isLink: isLink,
                        title: status != true
                            ? index != unlinkCount
                                ? mainMenu[index].title
                                : isLink.toString()
                            : index != unlinkCount
                                ? businessMainMenu[index].title
                                : isLink.toString(),
                        onTap: widget.onTap,
                        index: status != true ? mainMenu[index].index : businessMainMenu[index].index,
                        isActive: index == widget.currentIndex ? true : false,
                        icon: status != true
                            ? index != unlinkCount
                                ? mainMenu[index].icon
                                : iconActive
                            : index != unlinkCount
                                ? businessMainMenu[index].icon
                                : iconActive,
                      );
                    },
                  ),
                ),*/
                Expanded(
                  child: ListView.builder(
                    itemCount: status != true
                        ? mainMenu.length
                        : businessMainMenu.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return DrawerTile(
                        status: status,
                        isLink: isLink,
                        title: status != true
                            ? /*index != unlinkCount ? */
                            mainMenu[index].title
                            : /*isLink.toString() : index != unlinkCount ?*/
                            businessMainMenu[index]
                                .title /*: isLink.toString()*/,
                        onTap: widget.onTap,
                        index: status != true
                            ? mainMenu[index].index
                            : businessMainMenu[index].index,
                        isActive: index == widget.currentIndex ? true : false,
                        icon: status != true
                            /* ? index != unlinkCount*/
                            ? mainMenu[index].icon
                            /* : iconActive
                            : index != unlinkCount*/
                            : businessMainMenu[index].icon
                        /* : iconActive*/,
                      );
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Pinned ©',
                          style: kDrawerBottomText,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            'Pinned business is patent pending',
                            style: kDrawerBottomText,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            'Version 2.0',
                            style: kDrawerBottomText,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // switchToBusiness({BuildContext context}) async {
  //   var userdata;
  //   NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
  //   var response = await NetworkDioHttp.postDioHttpMethod(context, url: GET_BUSINESS_SUBSCRIPTION);
  //   if (response != null) {
  //     userdata = response['body'];
  //     print(userdata.toString() + '--------------------->');
  //     if (userdata != null) {
  //       setState(() {
  //         status = true;
  //         unlinkCount = 4;
  //       });
  //       saveSharedPrefData(key: 'switch', value: true);
  //     }
  //   } else {
  //     showToast('Something went wrong', context);
  //   }
  //   return;
  // }
}

String deviceId;

class DrawerTile extends StatelessWidget {
  final String title;
  final int index;
  final bool isActive;
  final bool status;
  final Function onTap;
  final String icon;
  final String isLink;

  DrawerTile(
      {this.title,
      this.index,
      this.isActive,
      this.onTap,
      this.status,
      this.icon,
      this.isLink});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print(isActive);
              print(index);
              currentScreen(isActive, context, index, isLink);
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    icon,
                    color: Colors.white,
                    height: 20,
                    width: 20,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(right: 10, left: 10.0, top: 8, bottom: 8),
                  child: Text(
                    title,
                    style: kDrawerText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  currentScreen(
    bool isActive,
    BuildContext context,
    int index,
    String isLink,
  ) {
    if (index == 0) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        );
      }
    } else if (index == 1) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()),
        );
      }
    } else if (index == 2) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => buyNfc()),
        );
      }
    } else if (index == 3) {
      unLinkPinnedTag(context: context, isLinkActive: 0);
      // print(deActive.toString() + 'sdfsfsdfdssfsfsdfdsf');
      // print(deActive == true ? '1' : '0');
      // if (deActive == true) {
      //   linkPinnedTag(context: context, isLinkActive: 1);
      // } else {
      //   unLinkPinnedTag(context: context, isLinkActive: 0);
      // }

    } else if (index == 4) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => ActivePinned()),
        );
      }
    } else if (index == 5) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => TutorialScreen()),
        );
      }
    } else if (index == 6) {
      showAlertDialog(context);
    } else if (index == 7) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => getBusinessInfo()),
        );
      }
    } else if (index == 8) {
      if (isActive) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => InAppPurchaseScreen()),
        );
      }
    }
  }

  //region FOR Show Logout Dialog
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: () async {
        await deviceInfo();
        logOut(
          context: context,
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Logout",
        style: kLogoutTextBlack,
      ),
      content: Text(
        "Are you sure you want to Logout?",
        style: kLoginButtonTextBlack,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//endregion
  Future logOut({BuildContext context, var data}) async {
    var data = FormData.fromMap({
      'device_id': deviceId,
    });

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(
      context,
      data: data,
      url: LOGOUT,
    );
    if (response != null) {
      clearSharedPreferences();
      socialMediaSignOut();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
    return;
  }

  Future clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future socialMediaSignOut() {
    final FacebookLogin facebookLogOut = new FacebookLogin();

    try {
      facebookLogOut.logOut();
      _googleSignIn.signOut();
    } catch (e) {
      print(e);
      // TODO
    }
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  deviceInfo() async {
    deviceId = await DeviceId.getID;
  }
}
