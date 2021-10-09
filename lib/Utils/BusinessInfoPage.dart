import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/DrawerCustom.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/components/Inputborder.dart';
import 'package:plnned/components/Round_Corner_Image.dart';
import 'package:plnned/components/Simple_Button.dart';
import 'package:plnned/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant.dart';
import 'DrawerCustom.dart';

class getBusinessInfo extends StatefulWidget {
  @override
  _getBusinessInfoState createState() => _getBusinessInfoState();
}

class _getBusinessInfoState extends State<getBusinessInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var userdata;

  String userDisplayName = '';
  String userName = '';

  String fullName = '';
  String userBio = '';
  File _image;

  String userProfile = '';
  TextEditingController businessName = new TextEditingController();
  TextEditingController bEmail = new TextEditingController();
  TextEditingController bWeb = new TextEditingController();
  TextEditingController bPhoneNumber = new TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    getUserProfileData();
    super.initState();
  }

  Future getUserProfileData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userDisplayName = pref.getString('username');
    userName = pref.getString('userdisplayname');
    userProfile = pref.getString('userprofile');
    userBio = pref.getString('bio');

    setState(() {
      // userProfileStatic = userProfile;
    });

    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response =
        await NetworkDioHttp.postDioHttpMethod(context, url: GET_BUSINESS_INFO);

    if (response != null) {
      setState(() {
        userdata = response['body']['data'];
      });
      print(userdata.toString() + '--------------------->');
      if (userdata != null) {
        businessName =
            TextEditingController(text: userdata['business_name'] ?? '');
        bEmail = TextEditingController(text: userdata['business_email'] ?? '');
        bWeb = TextEditingController(text: userdata['business_website'] ?? '');
        bPhoneNumber =
            TextEditingController(text: userdata['business_phone'] ?? '');
        userProfile = userdata['business_profile_pic'] ?? ' ';
      }
    } else {
      showToast('Something went wrong', context);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: kPrimaryColor,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Business Profile',
          style: kEditProfileText,
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
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    isEdit = true;
                  });
                },
                child: Visibility(
                  visible: isEdit ? false : true,
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        'Edit',
                        style: kEditProfileText,
                      )),
                ),
              ),
            ],
          )
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
                stops: [0.3, 0.9])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*    Container(
                height: 130,
                width: 130,
                padding: const EdgeInsets.all(12.0),
                child: RoundCornerImage(
                    height: 120,
                    width: 120,
                    image: _image != null ? '' : userProfile ?? ' ',
                    circular: 100,
                    placeholder: 'ic_profile_placeholder.png',
                    fileImage: _image != null ? _image : null),
              ),*/
              isEdit
                  ? GestureDetector(
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
                            /* userProfile == '' ||*/ _image != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: _image != null
                                          ? Image.file(
                                              _image,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/ic_profile_placeholder.png',
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  )
                                : Container(
                                    child: RoundCornerImage(
                                      height: 120,
                                      width: 120,
                                      image: userProfile ?? ' ',
                                      circular: 100,
                                      placeholder: 'ic_profile_placeholder.png',
                                      // fileImage: _image != null ? _image : null,
                                    ),
                                  ),
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
                    )
                  : GestureDetector(
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
                                      image: _image != null
                                          ? ''
                                          : userProfile ?? ' ',
                                      circular: 100,
                                      placeholder: 'ic_profile_placeholder.png',
                                      fileImage: _image != null ? _image : null,
                                    ),
                                  )
                                : RoundCornerImage(
                                    height: 120,
                                    width: 120,
                                    image: _image != null
                                        ? ''
                                        : userProfile ?? ' ',
                                    circular: 100,
                                    placeholder: 'ic_profile_placeholder.png',
                                    fileImage: _image != null ? _image : null),
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  businessName.text ?? 'Business Name',
                  style: kTextStyleLightBlackMedium,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SocialLInkTile(
                labelText: 'Name',
                controller: businessName,
                textInputType: TextInputType.text,
                hint: 'Enter business Name',
                redOnly: isEdit == true ? false : true,
              ),
              SocialLInkTile(
                labelText: 'Phone Number',
                controller: bPhoneNumber,
                textInputType: TextInputType.number,
                hint: 'Enter business Phone Number',
                redOnly: isEdit == true ? false : true,
              ),
              SocialLInkTile(
                labelText: 'Email',
                controller: bEmail,
                textInputType: TextInputType.emailAddress,
                hint: 'Enter business Email',
                redOnly: isEdit == true ? false : true,
              ),
              SocialLInkTile(
                labelText: 'Website',
                controller: bWeb,
                textInputType: TextInputType.emailAddress,
                hint: 'Enter business Website',
                redOnly: isEdit == true ? false : true,
              ),
              SizedBox(
                height: 30,
              ),
              Visibility(
                visible: isEdit ? true : false,
                child: SimpleButton(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    Timer(Duration(seconds: 5), () {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          duration: Duration(days: 365),
                          /*     action: SnackBarAction(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => getBusinessInfo()));
                            },
                            label: 'cancel',
                            textColor: Colors.white,
                          ),*/
                          content: Text(
                            'Your Internet Connection is weak please wait until it\'s finished',
                          ),
                        ),
                      );
                      /*   showToast(
                          'Your Internet Connection is week please wait until its finished',
                          context);*/
                    });
                    saveUserProfile(
                      bEmail: bEmail.text,
                      bName: businessName.text,
                      bPhoneNumber: bPhoneNumber.text,
                      bWeb: bWeb.text,
                    );
                  },
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  shadowColor: kButtonColor,
                  buttonColor: kButtonColor,
                  textStyle: kLoginButtonText,
                  text: 'Done',
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerCustom(
          currentIndex: 2,
          onTap: () {
            Navigator.pop(context);
          }),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    await newCropImage(image);
  }

  Future newCropImage(var image) async {
    File cropImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        iosUiSettings: IOSUiSettings(
            aspectRatioLockEnabled: false,
            minimumAspectRatio: 5,
            rectX: 500,
            rectY: 500,
            rectHeight: 500,
            rectWidth: 500,
            title: 'Cropper'));

    setState(() {
      if (cropImage != null) {
        _image = cropImage;
      }
    });
  }

  Future saveUserProfile(
      {String bName, bWeb, bPhoneNumber, bEmail, var bProfilePic}) async {
    var userdata;
    var data;
    var imageWithData;
    data = FormData.fromMap({
      'business_name': bName,
      'business_website': bWeb,
      'business_phone': bPhoneNumber,
      'business_email': bEmail,
    });
    imageWithData = FormData.fromMap({
      'business_name': bName,
      'business_website': bWeb,
      'business_phone': bPhoneNumber,
      'business_email': bEmail,
      'business_profile_pic':
          _image != null ? await MultipartFile.fromFile('${_image.path}') : ' ',
    });
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context,
        url: ADD_PROFILE_INFO, data: _image == null ? data : imageWithData);
    print(response);
    if (response != null) {
      userdata = response['body']['data'];
      if (response['body']['status'] == 1) {
        savePreferenceData(
            key: 'userprofile', value: userdata['business_profile_pic']);
        savePreferenceData(key: 'bio', value: userdata['business_website']);
        savePreferenceData(
            key: 'userdisplayname', value: userdata['business_name']);
        setState(() {
          businessProfileStatic = userdata['business_profile_pic'];
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        );
      }
    } else {
      showToast('Something went wrong', context);
    }
    return;
  }
}

class SocialLInkTile extends StatelessWidget {
  final String labelText, hint;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool redOnly;

  SocialLInkTile(
      {this.labelText,
      this.controller,
      this.hint,
      this.textInputType,
      this.redOnly});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
                labelText,
                style: kHeadLabelText,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child:
              /*InputFieldSimpleGrey(
            width: size.width * 0.9,
            controller: controller,
            hintText: hint,
            prefix: '',
            type: textInputType,
          ),*/
              InputBoarder(
            height: 55,
            controller: controller,
            readonly: redOnly,
            hintText: hint,
            prefix: '',
            type: TextInputType.text,
          ),
        ),
      ],
    );
  }
}
