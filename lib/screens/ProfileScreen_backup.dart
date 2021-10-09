import 'dart:io';
import 'dart:ui';



import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/DrawerCustom.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/components/InputShadowCabin.dart';
import 'package:plnned/components/Round_Corner_Image.dart';
import 'package:plnned/components/Simple_Button.dart';
import 'package:plnned/components/TextContainer.dart';
import 'package:plnned/components/inputField_editdialog.dart';
import 'package:plnned/modal/tranferent.dart';
import 'package:plnned/screens/EdirtSocialPlatform.dart';
import 'package:plnned/screens/EditProfileScreen.dart';
import 'package:plnned/screens/SocialIdList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inAppPurchaseScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isBusinessProfile = false;

  String userName = '';
  String displayName = '';
  String bio = '';
  bool isProfile = false;
  File _image;
  List userdata = new List();
  bool status = false;
  String userDisplayName = '';
  String fullName = '';
  String userBio = '';
  String userProfile = '';
  SlidableController slidableController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List socialLinks = List();
  List addContact = List();
  List addMusic = List();
  List addPayments = List();
  List addMore = List();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      isProfile = true;
    });
  }

  @override
  void initState() {
    getPreferenceData();
    getUserProfileData();
    slidableController = SlidableController(onSlideIsOpenChanged: handleSlideIsOpenChanged);
    super.initState();
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {});
  }

  Future keyListAdd() async {
    for (int i = 0; i < userdata.length; i++) {
      print('pinned list');
      print(userdata[i]['app_type']);

      if (userdata[i]['app_type'] == 1) {
        socialLinks.add(userdata[i]);
      } else if (userdata[i]['app_type'] == 2) {
        addContact.add(userdata[i]);
      } else if (userdata[i]['app_type'] == 3) {
        addMusic.add(userdata[i]);
      } else if (userdata[i]['app_type'] == 4) {
        addPayments.add(userdata[i]);
      } else {
        addMore.add(userdata[i]);
      }
    }
    print('-----------------');
    print(addMusic);
  }

  Future getPreferenceData() async {
    var userdata;
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(
      context,
      url: GET_PROFILE,
    );
    setState(() {
      userdata = response['body']['data'];
    });
    print('usersData---->' + userdata.toString());
    print(userdata['is_business_profile'].toString() + '--------------------------------');

    if ('${userdata['is_business_profile']}' == '0') {
      setState(() {
        userDisplayName = userdata['username'] ?? '';
        userProfile = userdata['profile_pic'];
        userBio = userdata['user_bio'] ?? '';
        userName = userdata['name'] ?? '';
      });
    } else {
      setState(() {
        isBusinessProfile = true;
        userDisplayName = userdata['username'] ?? '';
        userProfile = userdata['business_profile_pic'] ?? ' ';
        userBio = userdata['user_bio'] ?? '';
        userName = userdata['business_name'] ?? userdata['name'] ?? ' ';
      });
    }

    return;

    SharedPreferences pref = await SharedPreferences.getInstance();
    userDisplayName = pref.getString('username');
    userName = pref.getString('userdisplayname');
    userProfile = pref.getString('userprofile');
    userBio = pref.getString('bio');
    status = pref.getBool('switch') ?? false;

    print(userProfile + '-----------');
    return;
  }

  Future getUserProfileData() async {
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(
      context,
      url: LIST_SOCIAL_PLATFORM,
    );

    if (response != null) {
      setState(() {
        userdata = response['body']['data'];
      });
      if (userdata != null) {
        print('login--->' + response['body'].toString());
      }
      await keyListAdd();
    } else {
      showToast('Something went wrong', context);
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        drawer: DrawerCustom(
          currentIndex: 1,
        ),
        appBar: AppBar(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isProfile != false
                    ? GestureDetector(
                        onTap: () {
                          if (isBusinessProfile) {
                            saveBusinessProfile(bProfilePic: _image);
                          } else {
                            saveProfile();
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Text(
                              'Save',
                              style: kEditProfileText,
                            )),
                      )
                    : Container(),
              ],
            )
          ],
          elevation: 0,
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kColorDark, kPrimaryColor], begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.3, 0.9])),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 130,
                          width: 130,
                        ),
                        userProfile != ''
                            ? Container(
                                child: RoundCornerImage(
                                  height: 120,
                                  width: 120,
                                  image: _image != null ? '' : userProfile ?? ' ',
                                  circular: 100,
                                  placeholder: 'ic_profile_placeholder.png',
                                  fileImage: _image != null ? _image : null,
                                ),
                              )
                            : RoundCornerImage(
                                height: 120,
                                width: 120,
                                image: _image != null ? '' : userProfile ?? ' ',
                                circular: 100,
                                placeholder: 'ic_profile_placeholder.png',
                                fileImage: _image != null ? _image : null),
                        Positioned(
                          bottom: 20,
                          right: 15,
                          child: Image.asset(
                            'assets/ic_camera.png',
                            height: 30,
                            width: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    userDisplayName ?? "",
                    style: kTextStyleLightBlackMedium,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditProfileScreen(
                                labelText: 'Name',
                                keyName: 'name',
                                type: 1,
                                preferenceKey: 'userdisplayname',
                                mainText: userName ?? '',
                              ),
                            ),
                          )
                          .then((value) => {
                                setState(() {
                                  getPreferenceData();
                                })
                              });
                    },
                    child: TextContainer('Name', userName ?? '', '')),
                TextContainer('User Name', '@' + userDisplayName ?? '', null),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditProfileScreen(
                              labelText: 'Bio',
                              keyName: 'user_bio',
                              preferenceKey: 'bio',
                              type: 3,
                              mainText: userBio ?? '',
                            ),
                          ),
                        )
                        .then((value) => {
                              setState(() {
                                getPreferenceData();
                              })
                            });
                  },
                  child: TextContainer('Bio', userBio ?? '', ''),
                ),
                /* Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Social Links',
                        style: kLoginButtonText,
                      ),
                    ],
                  ),
                ),*/
                SocialIdList(
                  headText: 'Social Links',
                  userSocialData: socialLinks,
                  scaffoldKey: _scaffoldKey,
                  refreshData: getPreferenceData,
                ),
                SocialIdList(
                  headText: 'Add Contact',
                  userSocialData: addContact,
                  scaffoldKey: _scaffoldKey,
                  refreshData: getPreferenceData,
                ),
                SocialIdList(
                  headText: 'Add Music',
                  userSocialData: addMusic,
                  scaffoldKey: _scaffoldKey,
                  refreshData: getPreferenceData,
                ),
                SocialIdList(
                  headText: 'Add Payment',
                  userSocialData: addPayments,
                  scaffoldKey: _scaffoldKey,
                  refreshData: getPreferenceData,
                ),
                SocialIdList(
                  headText: 'Add More',
                  userSocialData: addMore,
                  scaffoldKey: _scaffoldKey,
                  refreshData: getPreferenceData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future saveBusinessProfile({var bProfilePic}) async {
    var userdata;
    var imageWithData;

    imageWithData = FormData.fromMap({
      'business_profile_pic': _image != null ? await MultipartFile.fromFile('${_image.path}') : ' ',
    });

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context, url: ADD_PROFILE_INFO, data: imageWithData);

    print(response);
    if (response != null) {
      userdata = response['body']['data'];
      if (response['body']['status'] == 1) {
        userProfileStatic = userdata['business_profile_pic'];
      }
    } else {
      showToast('Something went wrong', context);
    }
    return;
  }

  Future saveProfile() async {
    var userdata;
    var data;
    print(_image.path);
    FormData formData = FormData();
    if (_image != null) {
/*         formData.files.add(MapEntry(
            "profile_pic",
            await MultipartFile.fromFile("${_image.path}",
                filename: "${_image.path}")));*/
      formData = FormData.fromMap({
        'profile_pic': await MultipartFile.fromFile(
          _image.path,
        )
      });
    }

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context, url: UPDATE_PROFILE, data: formData);
    if (response != null) {
      setState(() {
        userdata = response['body']['data'];
      });
      userProfileStatic = userdata['profile_pic'];
      print(userProfileStatic);
      print('My profile ------------------?');
      if (userdata != null) {
        saveUserProfile(userdata['profile_pic']);
        setState(() {
          isProfile = false;
        });
      }
    } else {
      showToast('Something went wrong', context);
    }

    return;
  }

  Future saveUserProfile(String userprofile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userprofile', userprofile);
  }
}

class SocialNetworkContainer extends StatelessWidget {
  final String profile;
  final Function onTap;

  SocialNetworkContainer({this.profile, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360.0),
            image: DecorationImage(
              image: AssetImage('assets/social_icon/' + profile.replaceAll('http://159.89.145.112/pinned/public/social_icon/', '')),
            )),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}

class SocialPlatformsTile extends StatefulWidget {
  final String userSocialName, socialPlatformNName, venmoSHareUrl, socialIdl, socialIcon, inputHint, padKey, socialMediaId;
  final SlidableController slidableController;
  final bool status;
  final int gradientStart, gradientEnd, isPremium, index;
  final BuildContext context;
  final Function refreshData;

  SocialPlatformsTile(
      {this.socialIdl,
      this.padKey,
      this.inputHint,
      this.venmoSHareUrl,
      this.refreshData,
      this.isPremium,
      this.status,
      this.socialMediaId,
      this.socialPlatformNName,
      this.userSocialName,
      this.gradientEnd,
      this.context,
      this.slidableController,
      this.socialIcon,
      this.gradientStart,
      this.index});

  @override
  _SocialPlatformsTileState createState() => _SocialPlatformsTileState();
}

class _SocialPlatformsTileState extends State<SocialPlatformsTile> {
  bool status;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (widget.isPremium != 1) {
                /* settingModalBottomSheet(
                    venmoSocialLink: widget.venmoSHareUrl ?? ' ',
                    userSocialName: widget.userSocialName ?? ' ',
                    socialId: widget.socialIdl,
                    context: widget.context,
                    inputHint: widget.inputHint,
                    socialMediaName: widget.socialPlatformNName,
                    socialIcon: widget.socialIcon.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''));*/

                /*  Navigator.of(context).push(TransparentRoute(
                    builder: (BuildContext context) => EditSocialLink(
                          socialLink: widget.socialIcon,
                          socialName: widget.socialPlatformNName,
                          refreshData: widget.refreshData,
                          socialId: widget.socialIdl,
                          socialMediaName: widget.userSocialName,
                        )));*/

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
                      context,
                      widget.socialIcon,
                      widget.socialPlatformNName,
                      widget.refreshData,
                      widget.socialIdl,
                      widget.userSocialName,
                    );
                  },
                );
              } else {
                await getISSharedData();
                if (status == true) {
                  /* settingModalBottomSheet(
                      venmoSocialLink: widget.venmoSHareUrl ?? ' ',
                      userSocialName: widget.userSocialName ?? ' ',
                      socialId: widget.socialIdl,
                      context: widget.context,
                      inputHint: widget.inputHint,
                      socialMediaName: widget.socialPlatformNName,
                      socialIcon: widget.socialIcon.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''));*/

                  /* Navigator.of(context).push(TransparentRoute(
                      builder: (BuildContext context) => EditSocialLink(
                            socialLink: widget.socialIcon,
                            socialName: widget.socialPlatformNName,
                            refreshData: widget.refreshData,
                            socialMediaName: widget.userSocialName,
                            socialId: widget.socialIdl,
                          )));*/

                  /* buildBottomModelSheet(
                    context: context,
                    refreshData: getISSharedData(),
                    socialId: widget.socialIcon,
                    socialLink:  widget.userSocialName,
                    socialMediaName: widget.socialPlatformNName,
                    socialName: widget.userSocialName,
                  );
                  */
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
                        context,
                        widget.socialIcon,
                        widget.socialPlatformNName,
                        widget.refreshData,
                        widget.socialIdl,
                        widget.userSocialName,
                      );
                    },
                  );
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InAppPurchaseScreen()));
                  // showToast('Switch to business to use this Link', context);
                }
              }
            },
            child: Stack(
              children: [
                Container(
                  decoration: widget.socialMediaId != 'null'
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.green,
                            width: 2.5,
                          ),
                        )
                      : BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: AssetImage(
                        'assets/social_icn/' + widget.socialIcon.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.socialMediaId != 'null' ? true : false,
                  child: Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/social_icn/ic_check.png',
                      height: 17,
                      width: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            widget.socialPlatformNName,
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
    /*return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Slidable(
        controller: widget.slidableController,
        key: Key(widget.padKey),
        closeOnScroll: true,
        actionPane: SlidableStrechActionPane(),
        actionExtentRatio: 0.10,
        child: Container(
          margin: EdgeInsets.only(right: 10),
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
                  widget.userSocialName ?? widget.socialPlatformNName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kMyLinksBigText,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (widget.isPremium != 1) {
                    settingModalBottomSheet(
                        venmoSocialLink: widget.venmoSHareUrl ?? ' ',
                        userSocialName: widget.userSocialName ?? ' ',
                        socialId: widget.socialIdl,
                        context: widget.context,
                        inputHint: widget.inputHint,
                        socialMediaName: widget.socialPlatformNName,
                        socialIcon: widget.socialIcon.replaceAll(
                            'https://app.pinned.eu/pinned/public/social_icon/',
                            ''));
                  } else {
                    await getISSharedData();
                    if (status == true) {
                      settingModalBottomSheet(
                          venmoSocialLink: widget.venmoSHareUrl ?? ' ',
                          userSocialName: widget.userSocialName ?? ' ',
                          socialId: widget.socialIdl,
                          context: widget.context,
                          inputHint: widget.inputHint,
                          socialMediaName: widget.socialPlatformNName,
                          socialIcon: widget.socialIcon.replaceAll(
                              'https://app.pinned.eu/pinned/public/social_icon/',
                              ''));
                    } else {
                      showToast('Switch to business to use this Link', context);
                    }
                  }
                },
                child: Container(
                  width: 60,
                  height: 40,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Edit',
                      style: kLoginButtonTextBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        secondaryActions: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/ic_unlink.png',
              height: 25,
              width: 25,
            ),
            onPressed: () {
              print(widget.socialMediaId);
              if (widget.socialMediaId != 'null') {
                clearSocialLink(
                    context: context,
                    socialId: widget.socialMediaId,

                    refreshUserData: widget.refreshData);
              } else {
                showToast('it\'s already empty', context);
              }
            },
          ),
        ],
      ),
    );*/
  }

  getISSharedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    status = preferences.getBool('switch') ?? false;
  }

  Widget buildBottomModelSheet(
    BuildContext context,
    String socialLink,
    String socialName,
    Function refreshData,
    String socialId,
    String socialMediaName,
  ) {
    // edtText = new TextEditingController(text: socialMediaName);
    // edtText.text = socialMediaName;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(0.00001),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
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
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter Your ${socialName} User Name',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: kColorDark,
                      fontFamily: 'PoppinsRegular',
                      decoration: TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage(
                      'assets/social_icn/' + socialLink.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    socialName,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: kColorAppleButton,
                      fontFamily: 'PoppinsRegular',
                      decoration: TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: InputShadowCabin(
                      height: 50,
                      /*controller: ,*/
                      hintText: '${socialName} Username',
                      prefix: '',
                      type: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        /* print('yes its my...');
                        print(edtText.text);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (edtText.text.isNotEmpty) {
                          if (socialId == '17') {
                            Navigator.of(context).pop();
                            venmoUserSheet(
                                venmoUserName: edtText.text,
                                userSocialName: widget.venmoSHareUrl ?? ' ',
                                socialId: widget.socialIdl,
                                context: widget.context,
                                inputHint: widget.inputHint,
                                socialMediaName: widget.socialPlatformNName,
                                socialIcon: widget.socialIcon.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''));
                          } else {
                            addSocialLink(refreshData: widget.refreshData, socialId: socialId, socialLink: edtText.text, context: context);
                          }
                        } else {
                          showToast('Enter social Link', context);
                        }*/
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                          color: kColorGoogleButton,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: kColorGoogleButton,
                              offset: Offset(0.0, 1.0), //(x,y)
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            child: InkWell(
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Save',
                                      style: kLoginButtonText,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void settingModalBottomSheet(
      {BuildContext context,
      String socialMediaName,
      String socialIcon,
      String userSocialName,
      String socialName,
      String venmoSocialLink,
      String socialId,
      String inputHint}) {
    TextEditingController username = new TextEditingController(text: userSocialName);

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter Your $socialMediaName Username',
                    style: kBigTextBlack,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputFieldEditDialog(
                    gradientStart: widget.gradientStart,
                    gradientEnd: widget.gradientEnd,
                    controller: username,
                    type: TextInputType.text,
                    prefix: 'assets/social_icon/$socialIcon',
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'How to get username?',
                    style: kSmallTextBlack,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    inputHint ?? '',
                    textAlign: TextAlign.center,
                    style: kSmallTextGray,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (username.text.isNotEmpty) {
                        if (socialId == '17') {
                          Navigator.of(context).pop();
                          venmoUserSheet(
                              venmoUserName: username.text,
                              userSocialName: widget.venmoSHareUrl ?? ' ',
                              socialId: widget.socialIdl,
                              context: widget.context,
                              inputHint: widget.inputHint,
                              socialMediaName: widget.socialPlatformNName,
                              socialIcon: widget.socialIcon.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''));
                        } else {
                          addSocialLink(refreshData: widget.refreshData, socialId: socialId, socialLink: username.text, context: context);
                        }
                      } else {
                        showToast('Enter social Link', context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: SimpleButton(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
                        shadowColor: kButtonColor,
                        buttonColor: kButtonColor,
                        textStyle: kLoginButtonText,
                        text: 'Save',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void venmoUserSheet(
      {BuildContext context,
      String socialMediaName,
      String venmoUserName,
      String socialIcon,
      String userSocialName,
      String socialName,
      String socialId,
      String inputHint}) {
    TextEditingController venmoLink = new TextEditingController(text: userSocialName == 'null' ? ' ' : userSocialName);
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Enter Your $socialMediaName Profile url',
                    style: kBigTextBlack,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputFieldEditDialog(
                    gradientStart: widget.gradientStart,
                    gradientEnd: widget.gradientEnd,
                    controller: venmoLink,
                    type: TextInputType.text,
                    prefix: 'assets/social_icon/$socialIcon',
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'How to get venmo profile url?',
                    style: kSmallTextBlack,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    venmoHint ?? '',
                    textAlign: TextAlign.center,
                    style: kSmallTextGray,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (venmoLink.text.isNotEmpty) {
                        addSocialLink(
                            venmoUserName: venmoUserName,
                            venmoShareLink: venmoLink.text,
                            refreshData: widget.refreshData,
                            socialId: socialId,
                            context: context);
                      } else {
                        showToast('Enter social Link', context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: SimpleButton(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
                        shadowColor: kButtonColor,
                        buttonColor: kButtonColor,
                        textStyle: kLoginButtonText,
                        text: 'Save',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future clearSocialLink({String socialId, BuildContext context, Function refreshUserData}) async {
    print(socialId);
    var userdata;
    var data = FormData.fromMap({
      'link_id': socialId,
    });

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context, url: DELETE_USER_SOCIAL_LINK, data: data);
    if (response != null) {
      userdata = response['body'];

      if (userdata != null) {
        if (userdata['status'] == 1) {
          refreshUserData();
        }
      }
    } else {
      showToast('Something went wrong', context);
    }
    return;
  }
}

void settingModalBottomSheet(
    {BuildContext context,
    String socialMediaName,
    String socialIcon,
    String socialName,
    int gradientStart,
    int gradientEnd,
    String socialId,
    String inputHint}) {
  TextEditingController username = new TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
    ),
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Your $socialMediaName Username',
                  style: kBigTextBlack,
                ),
                SizedBox(
                  height: 10,
                ),
                InputFieldEditDialog(
                  gradientStart: gradientStart,
                  gradientEnd: gradientEnd,
                  controller: username,
                  type: TextInputType.text,
                  prefix: 'assets/social_icon/$socialIcon',
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  'How to get username?',
                  style: kSmallTextBlack,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  inputHint ?? '',
                  textAlign: TextAlign.center,
                  style: kSmallTextGray,
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    if (socialName != '') {
                      addSocialLink(socialId: socialId, socialLink: username.text, context: context);
                    } else {
                      showToast('Enter social Link', context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: SimpleButton(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 40,
                      shadowColor: kButtonColor,
                      buttonColor: kButtonColor,
                      textStyle: kLoginButtonText,
                      text: 'Save',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future addSocialLink({String socialLink, String socialId, String venmoUserName, String venmoShareLink, BuildContext context, Function refreshData}) async {
  print(socialId);
  print(socialLink);
  var userdata;
  var data = FormData.fromMap({
    'social_id': socialId,
    'social_link': socialLink,
  });
  var venmoData = FormData.fromMap({
    'social_id': socialId,
    'social_link': venmoUserName,
    'social_link_2': venmoShareLink,
  });
  NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
  var response = await NetworkDioHttp.postDioHttpMethod(context, url: ADD_USER_SOCIAL_LINK, data: socialId == '17' ? venmoData : data);
  if (response != null) {
    userdata = response['body'];
    if (userdata['status'] == 1) {
      Navigator.pop(context);
      refreshData();
    }
  } else {
    showToast('Something went wrong', context);
  }
  return;
}
