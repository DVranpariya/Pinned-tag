import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/DrawerCustom.dart';
import 'package:plnned/Utils/network_dio.dart';
// import 'package:plnned/components/Round_Corner_Image.dart';
import 'package:plnned/components/Round_FlatButton.dart';
import 'package:plnned/screens/ProfileScreen.dart';
import 'package:plnned/screens/QrCapture.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'inAppPurchaseScreen.dart';

ScreenshotController screenshotController = ScreenshotController();

class HomeScreen extends StatefulWidget {
  static String textNumber;

  @override
  HomeScreenState createState() => HomeScreenState(randomNuber: textNumber);
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeScreenState({this.randomNuber});

  String randomNuber;
  List userdata = new List();
  String userDisplayName = '';
  String userName = '';
  String fullName = '';
  String userBio = '';
  String userProfile = '';
  String userEmail;
  int isBusinessProfile;
  int _selectedIndex;
  String pinCounter;
  List<bool> selectPin = new List();
  bool status;
  String platformName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSelect = false;

  @override
  void initState() {
    print("AnkitSElect");
    print(_selectedIndex);
    getISSharedData();
    getPinCounter();
    print('--------------------------------------------');
    print(businessProfileStatic1);
    getRegister();
    getUserProfileData();
    super.initState();
  }

  _onSelected({int index, String linkId, bool isSelected, String socialId}) {
    setState(() {
      selectPin.fillRange(0, userdata.length, false);
      selectPin.removeAt(index);
      selectPin.insert(index, true);
    });
    updateFirst(socialId: socialId);
    /*if (isSelected == false) {
    } else {
    }*/
  }

  _onDisSelect({int index, String linkId, bool isSelected, String socialId}) {
    setState(() {
      selectPin.removeAt(index);
      selectPin.insert(index, false);
    });
    print("Ankitdis");
    updateFirst(
      linkId: '0',
    );
  }

  Future getUserProfileData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //    userDisplayName = pref.getString('username');
    //  userName = pref.getString('userdisplayname');
    //userBio = pref.getString('bio');
    //status = pref.getBool('switch');

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context,
        url: GET_USER_SOCIAL_LINK);

    if (response != null) {
      print('responseE: $response');

      setState(() {
        userdata = response['body']['data'];
        platformName = userdata[0]['social_platform_name'];

        List.generate(
            userdata.length,
            (index) =>
                selectPin.add(userdata[index]['is_first'] == 1 ? true : false));

        for (var i = 0; i < userdata.length; i++) {
          print(i);
          if (userdata[i]['is_first'] == 1) {
            setState(() {
              _selectedIndex = i;
            });
            break;
          } else {
            _selectedIndex = null;
          }
        }
        print(_selectedIndex);
        // var count = 0;
        // print(selectPin);
        // for (var i in userdata) {
        //   print(i['is_first']);
        //   if (i['is_first'] == 1) {
        //     setState(() {
        //       _selectedIndex = count;
        //     });
        //   } else {
        //     setState(() {
        //       _selectedIndex = null;
        //     });
        //   }
        //   count++;
        // }
        print(_selectedIndex);
        print("AnKItfksdjh");
      });
      await savePreferenceData(
          key: 'is_business_profile',
          value: userdata[0]['is_business_profile'].toString());
    } else {
      showToast('Something went wrong', context);
    }

    /* List addLinkList = [
      {"social_platform_icon": "milan"},
      {"social_platform_name": "milan"},
      {"link_id": "999"},
    ];*/
    // userdata.add(addLinkList);
    //  userdata.add(addLinkList);

    print('userdata');
    print(userdata.length);
    return;
  }

  var businessProfileStatic1;
  savePurChase({int status}) {
    if (status == 1) {
      setState(() {
        isPurchaseStatus = true;
        saveSharedPrefData(value: true, key: 'switch');
      });
    } else {
      setState(() {
        isPurchaseStatus = true;
        saveSharedPrefData(key: 'switch', value: false);
        print('-------Not preda');
      });
    }
  }

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
    print('usersData' + userdata.toString());
    print(userdata['is_business_profile'].toString() +
        '--------------------------------');
    savePurChase(status: userdata['is_business_profile']);

    if ('${userdata['is_business_profile']}' == '0') {
      setState(() {
        userDisplayName = userdata['username'] ?? '';
        userProfile = userdata['profile_pic'];
        userBio = userdata['user_bio'] ?? '';
        userName = userdata['name'] ?? '';
        isBusinessProfile = userdata['is_business_profile'];
      });
      print(userProfile);
    } else {
      setState(() {
        userDisplayName = userdata['username'] ?? '';
        businessProfileStatic1 = userdata['business_profile_pic'] ?? ' ';
        userBio = userdata['user_bio'] ?? '';
        userName = userdata['business_name'] ?? userdata['name'] ?? ' ';
        userEmail = userdata['business_email'];
        isBusinessProfile = userdata['is_business_profile'];
      });
      print(
          '--------------------------------------businessprofilestatice------------------------');
      print(businessProfileStatic1);
    }
    print('isBusinessProfile£££££££££: $isBusinessProfile');
    setState(() {
      userProfileStatic = userProfile;
    });

    if (response != null) {
      if (userdata != null) {
        pinCounter = '${userdata['total_airpawnd']}';
        userNameStatic = userName;
      }
    } else {
      showToast('Something went wrong', context);
    }

    return;
  }

  Future updateFirst(
      {String linkId, BuildContext context, String socialId}) async {
    var tmpUserdata;
    print(linkId == null ? socialId : linkId);
    print('--------------------------------------');
    var data = FormData.fromMap({
      'link_id': linkId == null ? socialId : linkId,
    });
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.tempPostDioHttpMethod(
        url: UPDATE_FIRST, data: data);

    if (response != null) {
      tmpUserdata = response['body'];
      if (tmpUserdata != null) {
        if (tmpUserdata['status'] == 1) {
        } else {
          showToast(tmpUserdata['msg'], context);
        }
      }
    } else {
      showToast('Something went wrong', context);
    }

    return;
  }

  getISSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    status = preferences.getBool('switch') ?? false;
    var index = await getSharedPrefData1(key: "selectedindex");
    print(index);
    setState(() {
      _selectedIndex = index;
      print("AnkitSelect $_selectedIndex");
    });
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      print(image);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      await Share.files('esys images', {'esys.png': pngBytes}, '*/*',
          text: 'download qr code of my profile');
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  GlobalKey globalKey = new GlobalKey();

  Widget buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Image.asset('assets/menuicon.png', height: 20, width: 20),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text("PINNED", style: kAppBar),
        actions: [
          IconButton(
            icon: Image.asset('assets/ic_code.png', height: 20, width: 20),
            onPressed: () {
              showModalBottomSheet(
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                elevation: 0,
                context: context,
                backgroundColor: Colors.transparent,
                /*builder: (builder) {
                  return buildBottomModelSheet(context);
                },*/
                builder: (builder) {
                  return buildBottomModelSheet(
                      context, userName, userProfile, userDisplayName);
                },
              );
            },
          ),
        ],
      ),
      body: Container(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              userProfile != ''
                  ? Container(
                      height: 110,
                      width: 110,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CachedNetworkImage(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: isBusinessProfile == 1
                                  ? businessProfileStatic1 ?? ''
                                  : userProfile ?? '',
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              errorWidget: (context, url, error) => userProfile
                                      .isNotEmpty
                                  ? Container(
                                      height: 110,
                                      width: 110,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white24,
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                          'assets/ic_profile_placeholder.png',
                                          height: 110,
                                          width: 110),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Image(
                                  height: 30,
                                  width: 30,
                                  image: AssetImage('assets/verified.png'))),
                        ],
                      ),
                    )
                  // Container(
                  //     // margin: EdgeInsets.only(left: 20),
                  //     height: 130,
                  //     width: 130,
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: RoundCornerImage2(
                  //       height: 140,
                  //       placeholder: 'ic_profile_placeholder.png',
                  //       width: 140,
                  //       image: isBusinessProfile == 1
                  //           ? businessProfileStatic1 ?? ''
                  //           : userProfile ?? '',
                  //       circular: 100,
                  //     ),
                  //   )
                  : Container(
                      height: 110,
                      width: 110,
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CachedNetworkImage(
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: isBusinessProfile == 1
                                  ? businessProfileStatic1 ?? ''
                                  : userProfile ?? '',
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              errorWidget: (context, url, error) => userProfile
                                      .isNotEmpty
                                  ? Container(
                                      height: 110,
                                      width: 110,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white24,
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                          'assets/ic_profile_placeholder.png',
                                          height: 110,
                                          width: 110),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Image(
                                  height: 30,
                                  width: 30,
                                  image: AssetImage('assets/verified.png'))),
                        ],
                      ),
                    ),
              // Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: RoundCornerImage2(
              //       height: 100,
              //       placeholder: 'ic_profile_placeholder.png',
              //       width: 100,
              //       image: isBusinessProfile == 1
              //           ? businessProfileStatic1 ?? ''
              //           : userProfile ?? '',
              //       circular: 100,
              //     ),
              //   ),
              Container(
                child: Text(
                  userName ?? ' ',
                  style: kTextStyleLightBlackMediumPopin,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '@$userDisplayName',
                style: kidTextPop,
              ),
              SizedBox(
                height: userBio != '' ? 5 : 0,
              ),
              Text(
                userBio ?? '',
                style: kidTextPop,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: userEmail != null ? 5 : 0,
              ),
              userEmail != null
                  ? Text(
                      userEmail ?? ' ',
                      style: kidTextPop,
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              /* qrDialog(
                                  globalKey: globalKey,
                                  onPress: () {
                                    _captureAndSharePng();
                                  },
                                  context: _scaffoldKey.currentContext,
                                  userName: userDisplayName);*/
                            },
                            child: ColorShadowButtonRound(
                              height: 45,
                              width: 160,
                              shadowColor: kPrimaryColor,
                              icon: 'assets/ic_pinned.png',
                              buttonColor: kPrimaryColor,
                              buttonText: pinCounter ?? '0',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              /* qrDialog(
                                  globalKey: globalKey,
                                  onPress: () {
                                    _captureAndSharePng();
                                  },
                                  context: _scaffoldKey.currentContext,
                                  userName: userDisplayName);*/
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen()));
                            },
                            child: ColorShadowButtonRound(
                              height: 45,
                              width: 160,
                              shadowColor: kPrimaryColor,
                              text: "Edit Profile",
                              buttonColor: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedIndex == null ? false : true,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      userdata.length != 0
                          ? 'Pinned is active to view your $platformName.'
                          : '',
                      style: kMyLinksBigTextPop,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: _selectedIndex == null ? true : false,
                  child: SizedBox(
                    height: 10,
                  )),
              userdata.length != 0
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.826,
                        ),
                        shrinkWrap: true,
                        itemCount: userdata.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          // print(userdata[index]['social_platform_icon']);
                          return index != userdata.length
                              ? SocialWidgetList(
                                  index: index,
                                  socialIcon: userdata[index]
                                      ['social_platform_icon'],
                                  socialName: userdata[index]
                                      ['social_platform_name'],
                                  selectedIndex: _selectedIndex,
                                  onTap: () async {
                                    /* setState(() {
                                _selectedIndex = index;
                                platformName = userdata[index]['social_platform_name'];
                              });
                              _onSelected(
                                isSelected: selectPin[index],
                                index: index,
                                socialId: '${userdata[index]['link_id']}',
                                linkId: '${userdata[index]['link_id']}',
                              );
                              print(index);*/
                                    print(
                                        "Ankit---->, $_selectedIndex, $index");

                                    if (isSelect) {
                                      if (_selectedIndex == index) {
                                        print('if in iff...');
                                        print('my list --->$selectPin');

                                        setState(() {
                                          _selectedIndex = null;
                                          platformName = '';
                                          isSelect = false;
                                        });
                                        _onDisSelect(
                                          isSelected: selectPin[index],
                                          index: index,
                                          socialId:
                                              '${userdata[index]['link_id']}',
                                          linkId:
                                              '${userdata[index]['link_id']}',
                                        );
                                        await saveSharedPrefData1(
                                            key: "selectedindex", value: null);
                                        /*if (userdata[index]['is_premium'] != 1) {
                                          _onDisSelect(
                                            isSelected: selectPin[index],
                                            index: index,
                                            socialId: '${userdata[index]['link_id']}',
                                            linkId: '${userdata[index]['link_id']}',
                                          );
                                        }*/
                                        // if (userdata[index]['is_premium'] == 0 && status == false) {
                                        //   _onDisSelect(
                                        //     isSelected: selectPin[index],
                                        //     index: index,
                                        //     socialId: '${userdata[index]['link_id']}',
                                        //     linkId: '${userdata[index]['link_id']}',
                                        //   );
                                        // } else if (userdata[index]['is_premium'] == 0 && status == true) {
                                        //   _onDisSelect(
                                        //     isSelected: selectPin[index],
                                        //     index: index,
                                        //     socialId: '${userdata[index]['link_id']}',
                                        //     linkId: '${userdata[index]['link_id']}',
                                        //   );
                                        // } else if (userdata[index]['is_premium'] == 1 && status == false) {
                                        //   _onDisSelect(
                                        //     isSelected: selectPin[index],
                                        //     index: index,
                                        //     socialId: '${userdata[index]['link_id']}',
                                        //     linkId: '${userdata[index]['link_id']}',
                                        //   );
                                        // } else {
                                        //   if (userdata[index]['is_premium'] == 1 && status == true) {
                                        //     _onDisSelect(
                                        //       isSelected: selectPin[index],
                                        //       index: index,
                                        //       socialId: '${userdata[index]['link_id']}',
                                        //       linkId: '${userdata[index]['link_id']}',
                                        //     );
                                        //   } else {
                                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => InAppPurchaseScreen()));
                                        //   }
                                        // }
                                      } else {
                                        print('if in else...');
                                        setState(() {
                                          _selectedIndex = index;
                                          platformName = userdata[index]
                                              ['social_platform_name'];
                                          isSelect = false;
                                        });
                                        await saveSharedPrefData1(
                                            key: "selectedindex", value: index);
                                        print(
                                            'user is_Prem${userdata[index]['is_premium']}');
                                        print('my list --->$selectPin');
                                        /* if (userdata[index]['is_premium'] != 1) {
                                          _onSelected(
                                            isSelected: selectPin[index],
                                            index: index,
                                            socialId: '${userdata[index]['link_id']}',
                                            linkId: '${userdata[index]['link_id']}',
                                          );
                                        }*/

                                        if (userdata[index]['is_premium'] ==
                                                0 &&
                                            status == false) {
                                          print("00");
                                          print(userdata[index]['link_id']);
                                          _onSelected(
                                            isSelected: selectPin[index],
                                            index: index,
                                            socialId:
                                                '${userdata[index]['link_id']}',
                                            linkId:
                                                '${userdata[index]['link_id']}',
                                          );
                                        } else if (userdata[index]
                                                    ['is_premium'] ==
                                                0 &&
                                            status == true) {
                                          print("01");
                                          print(userdata[index]['link_id']);
                                          _onSelected(
                                            isSelected: selectPin[index],
                                            index: index,
                                            socialId:
                                                '${userdata[index]['link_id']}',
                                            linkId:
                                                '${userdata[index]['link_id']}',
                                          );
                                        } else {
                                          if (userdata[index]['is_premium'] ==
                                                  1 &&
                                              status == true) {
                                            print("11");
                                            print(userdata[index]['link_id']);
                                            _onSelected(
                                              isSelected: selectPin[index],
                                              index: index,
                                              socialId:
                                                  '${userdata[index]['link_id']}',
                                              linkId:
                                                  '${userdata[index]['link_id']}',
                                            );
                                          } else {
                                            // setState(() {
                                            //   _selectedIndex = null;
                                            // });
                                            // _onDisSelect(
                                            //   isSelected: selectPin[index],
                                            //   index: index,
                                            //   socialId: '${userdata[index]['link_id']}',
                                            //   linkId: '${userdata[index]['link_id']}',
                                            // );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InAppPurchaseScreen()));
                                          }
                                        }
                                      }
                                    } else {
                                      print('else...');
                                      setState(() {
                                        _selectedIndex = index;
                                        platformName = userdata[index]
                                            ['social_platform_name'];
                                        isSelect = true;
                                      });
                                      await saveSharedPrefData1(
                                          key: "selectedindex", value: index);
                                      print(
                                          'user is_Prem${userdata[index]['is_premium']}');
                                      print('my list --->$selectPin');
                                      if (userdata[index]['is_premium'] == 0 &&
                                          status == false) {
                                        print("00");
                                        print(userdata[index]['link_id']);
                                        _onSelected(
                                          isSelected: selectPin[index],
                                          index: index,
                                          socialId:
                                              '${userdata[index]['link_id']}',
                                          linkId:
                                              '${userdata[index]['link_id']}',
                                        );
                                      } else if (userdata[index]
                                                  ['is_premium'] ==
                                              0 &&
                                          status == true) {
                                        print("01");
                                        print(userdata[index]['link_id']);
                                        _onSelected(
                                          isSelected: selectPin[index],
                                          index: index,
                                          socialId:
                                              '${userdata[index]['link_id']}',
                                          linkId:
                                              '${userdata[index]['link_id']}',
                                        );
                                      } else {
                                        if (userdata[index]['is_premium'] ==
                                                1 &&
                                            status == true) {
                                          print("11");
                                          print(userdata[index]['link_id']);
                                          _onSelected(
                                            isSelected: selectPin[index],
                                            index: index,
                                            socialId:
                                                '${userdata[index]['link_id']}',
                                            linkId:
                                                '${userdata[index]['link_id']}',
                                          );
                                        } else {
                                          // setState(() {
                                          //   _selectedIndex = null;
                                          //   _onDisSelect(
                                          //     isSelected: selectPin[index],
                                          //     index: index,
                                          //     socialId: '${userdata[index]['link_id']}',
                                          //     linkId: '${userdata[index]['link_id']}',
                                          //   );
                                          // });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InAppPurchaseScreen()));
                                        }
                                      }
                                    }
/*
                              if (userdata[index]['is_premium'] != 1) {
                                _onSelected(
                                  isSelected: selectPin[index],
                                  index: index,
                                  socialId: '${userdata[index]['link_id']}',
                                  linkId: '${userdata[index]['link_id']}',
                                );
                              } else {
                                if (status == true) {
                                  _onDisSelect(
                                    isSelected: selectPin[index],
                                    index: index,
                                    socialId: '${userdata[index]['link_id']}',
                                    linkId: '${userdata[index]['link_id']}',
                                  );
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => InAppPurchaseScreen()));
                                  //showToast('Switch to business to use this Link', context);
                                }
                              }*/
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return ProfileScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Image(
                                              image:
                                                  AssetImage('assets/add.png'),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Add SocialLink',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: kColorAppleButton,
                                            fontFamily: 'PoppinsRegular',
                                            decoration: TextDecoration.none,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                          /*return SocialMediaTagTile(
                    color: colorSelected(selected: selectPin[index]),
                    selectedIndex: _selectedIndex,
                    gradientEnd: int.parse(userdata[index]['gradient_end']),
                    gradientStart: int.parse(userdata[index]['gradient_start']),
                    onTap: () async {
                      if (userdata[index]['is_premium'] != 1) {
                        _onSelected(
                          isSelected: selectPin[index],
                          index: index,
                          socialId: '${userdata[index]['link_id']}',
                          linkId: '${userdata[index]['link_id']}',
                        );
                      } else {
                        if (status == true) {
                          _onSelected(
                            isSelected: selectPin[index],
                            index: index,
                            socialId: '${userdata[index]['link_id']}',
                            linkId: '${userdata[index]['link_id']}',
                          );
                        } else {
                          showToast('Switch to business to use this Link', context);
                        }
                      }
                    },
                    index: index,
                    socialIcon: userdata[index]['social_platform_icon'],
                    socialName: userdata[index]['social_platform_name'],
                  );*/
                        },
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerCustom(
        currentIndex: 0,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Color colorSelected({bool selected}) {
    if (selected == true) {
      return Colors.yellow;
    } else {
      return Colors.white;
    }
  }

  Future getRegister() async {
    String userId;
    userId = await getSharedPrefData(key: 'userid');
    Socket socket;
    String socketid;
    socket = io('http://159.89.145.112:3000/', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on(
        'connect',
        (data) => {
              socket.emit('socket_register', {'user_id': userId}),
              socketid = socket.id,
              print(socketid.toString() +
                  'connect------------------------------------------------'),
            });

    print(socket.id);
    print('-------------------------');

    socket.on('getphonenumber', (data) {
      print('object ----------->$data');
      var randomNumber = HomeScreen.textNumber;
    });

    socket.on('updatecount', (data) {
      setState(() {
        pinCounter = '${data['count']}';
      });
      print(data.toString() + ' Message Event');
    });
    return;
  }

  Future saveContact({String username, String mobileno}) async {
    List<Contact> _contacts;
    var contact = (await ContactsService.getContactsForPhone(mobileno,
            iOSLocalizedLabels: true))
        .toList();
    print(contact);
    if (contact.toString() != '[]') {
      print('already saved');
      _contacts = contact;
      await ContactsService.openExistingContact(_contacts[0],
          iOSLocalizedLabels: true);
    } else {
      print('Add new Conatct');
      Contact sp = new Contact();
      sp.givenName = username;
      sp.phones = [Item(label: "mobile", value: mobileno)];
      await ContactsService.addContact(sp);
      var contact = (await ContactsService.getContactsForPhone(mobileno,
              iOSLocalizedLabels: true))
          .toList();
      _contacts = contact;

      ContactsService.openExistingContact(_contacts[0],
          iOSLocalizedLabels: true);
    }
  }
}

Widget buildBottomModelSheet(BuildContext context, String name,
    String profileName, String userDisplayName) {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade100.withOpacity(0.00001),
          ),
          child: Stack(
            children: [
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Image(
                      image: AssetImage(
                        "assets/ic_cancel.png",
                      ),
                      color: Colors.black,
                    ),
                  ),
                ),
                top: 0,
                right: 0,
                height: 50,
                width: 50,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Share Your Profile",
                        style: kQrCodeText,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    QrImage(
                      data:
                          'https://app.pinned.eu/pinned/get_user/$userDisplayName',
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      scanQrText,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontFamily: 'PoppinsRegular',
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        /* screenshotController.capture().then((Uint8List image) {
                          print('image');
                          print(image);
                        }).catchError((onError) {
                          print('onError');
                          print(onError);
                        });
                        print("File Saved to Gallery");*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrCapture(
                              userName: name,
                              userProfile: profileName,
                              link:
                                  'https://app.pinned.eu/pinned/get_user/$userDisplayName',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffD4D3D9),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Save QR Code",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Share.text('Pinned', 'https://app.pinned.eu/pinned/get_user/$userDisplayName');
                        // Share.share('Pinned', 'https://app.pinned.eu/pinned/get_user/$userDisplayName', 'text');
                        shareUrl(
                            'https://app.pinned.eu/pinned/get_user/$userDisplayName');
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffE32863),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Share Profile link",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
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

class SocialWidgetList extends StatelessWidget {
  String socialId;
  int selectedIndex;
  Function onTap;
  int index;
  String socialIcon;
  String socialName;

  SocialWidgetList(
      {this.socialId,
      this.selectedIndex,
      this.onTap,
      this.index,
      this.socialIcon,
      this.socialName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: index == selectedIndex
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.5,
                      ),
                    )
                  : BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image(
                  image: AssetImage(
                    'assets/social_icn/' +
                        socialIcon.replaceAll(
                            'https://app.pinned.eu/pinned/public/social_icon/',
                            ''),
                  ),
                ),
              ),
            ),
          ),
          Text(
            socialName,
            style: TextStyle(
              fontSize: 14.0,
              color: kColorAppleButton,
              fontFamily: 'PoppinsRegular',
              decoration: TextDecoration.none,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

class SocialMediaTagTile extends StatelessWidget {
  final String socialName, socialIcon;
  final Function onTap;
  final Color color;
  final int index, gradientStart, gradientEnd, selectedIndex;

  SocialMediaTagTile(
      {this.index,
      this.color,
      Key key,
      this.socialIcon,
      this.socialName,
      this.onTap,
      this.selectedIndex,
      this.gradientStart,
      this.gradientEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          colors: [
            Color(gradientStart),
            Color(gradientEnd),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.0),
                image: DecorationImage(
                    image: AssetImage('assets/social_icon/' +
                        socialIcon.replaceAll(
                            'https://app.pinned.eu/pinned/public/social_icon/',
                            '')))),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Text(
              socialName,
              style: kMyLinksBigText,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: onTap,
                child: Image.asset('assets/ic_share_white.png',
                    height: 22, color: color),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/ic_more.png',
              height: 22,
              width: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/*
class SocialMediaTagTile extends StatefulWidget {
  final String socialName, socialIcon;
  final Function onTap;
  final Color color;
  final int index, gradientStart, gradientEnd, selectedIndex;

  SocialMediaTagTile(
      {this.index,
      this.color,
      this.socialIcon,
      this.socialName,
      this.onTap,
      this.selectedIndex,
      this.gradientStart,
      this.gradientEnd});

  @override
  _SocialMediaTagTileState createState() => _SocialMediaTagTileState();
}

class _SocialMediaTagTileState extends State<SocialMediaTagTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          colors: [
            Color(widget.gradientStart),
            Color(widget.gradientEnd),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.0),
                image: DecorationImage(
                    image: AssetImage('assets/social_icon/' +
                        widget.socialIcon.replaceAll(
                            'https://app.pinned.eu/pinned/public/social_icon/',
                            '')))),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Text(
              widget.socialName,
              style: kMyLinksBigText,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Image.asset('assets/ic_share_white.png',
                    height: 22, color: widget.color),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/ic_more.png',
              height: 22,
              width: 22,
            ),
          ),
        ],
      ),
    );
  }
}
*/

void qrDialog(
    {String userName,
    BuildContext context,
    Function onPress,
    GlobalKey globalKey}) {
  final size = 150.0;

  showDialog(
    barrierDismissible: true,
    builder: (context) => Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Share Profile",
                    style: TextStyle(
                      color: Color(0xff808080),
                      fontSize: 22.0,
                      fontFamily: 'bold',
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: Text(
                      "Scan this code with any camera to share your Pinned profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff808080),
                        fontSize: 18.0,
                        fontFamily: 'regular',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  /*       Expanded(
                child:  Center(
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                      data: _dataString,
                      size: 0.5 * bodyHeight,
                      onError: (ex) {
                        print("[QR] ERROR - $ex");
                        setState((){
                          _inputErrorText = "Error! Maybe your input value is too long?";
                        });
                      },
                    ),
                  ),
                ),
              )*/
                  RepaintBoundary(
                    key: globalKey,
                    child: CustomPaint(
                      size: Size.square(size),
                      painter: QrPainter(
                        data: 'https://app.pinned.eu/pinned/get_user/$userName',
                        version: QrVersions.auto,
                        color: Colors.black,
                        emptyColor: Color(0xffeafcf6),
                        // size: 320.0,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size.square(60),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: MaterialButton(
                        height: 50.0,
                        color: Color(0xffD4D3D9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Text(
                          'cancel',
                          style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 0.5,
                              color: Colors.black,
                              fontFamily: 'bold'),
                        ),
                        onPressed: onPress),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    context: context,
    // barrierColor: Colors.white.withOpacity(0.7),
    // pillColor: Colors.red,
    // backgroundColor: Colors.yellow,
  );
}

class RoundCornerImage2 extends StatefulWidget {
  final double height;
  final double width;
  final String image;
  final File fileImage;
  final String placeholder;
  final double circular;

  const RoundCornerImage2(
      {Key key,
      this.height,
      this.width,
      this.image,
      this.fileImage,
      this.placeholder,
      this.circular})
      : super(key: key);

  // BoxFit fit;
  // RoundCornerImage2({this.height, this.width, this.image, this.fileImage, this.circular, this.placeholder});

  @override
  _RoundCornerImageState createState() => _RoundCornerImageState();
}

class _RoundCornerImageState extends State<RoundCornerImage2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.circular),
            child: CachedNetworkImage(
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
              imageUrl: widget.image,
              placeholder: (context, url) => Center(
                child: new CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              errorWidget: (context, url, error) => widget.image.isNotEmpty
                  ? Container(
                      height: widget.width,
                      width: widget.height,
                      decoration: BoxDecoration(
                        /*  color: Color(0xFFdbdbdb),*/
                        borderRadius: BorderRadius.circular(widget.circular),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.fileImage == null
                              ? AssetImage(('assets/${widget.placeholder}'))
                              : FileImage(widget.fileImage),
                        ),
                        /* new Image.asset('assets/test.jpg')*/
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: Image(
                  height: 30,
                  width: 30,
                  image: AssetImage('assets/verified.png'))),
        ],
      ),
    );
  }
}
