import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/components/FildWhite.dart';
import 'package:plnned/components/InputShadowCabin.dart';
import 'package:plnned/components/Login_Shadow_button.dart';
import 'package:plnned/components/Simple_Button.dart';
import 'package:plnned/components/inputField_editdialog.dart';
import 'package:plnned/screens/ProfileScreen.dart';

class EditSocialLink extends StatefulWidget {
  final String socialLink, socialName, socialId, socialMediaName;
  final Function refreshData;

  EditSocialLink({this.socialLink, this.socialName, this.refreshData, this.socialId, this.socialMediaName});

  @override
  _EditSocialLinkState createState() => _EditSocialLinkState();
}

class _EditSocialLinkState extends State<EditSocialLink> {
  TextEditingController edtText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    edtText.text = widget.socialMediaName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kColorDark.withOpacity(0.4), kPrimaryColor.withOpacity(0.4)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.9],
              ),
            ),
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
                          height: 15,
                          width: 15,
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
                  'Enter Your ${widget.socialName} User Name',
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
                    'assets/social_icn/' + widget.socialLink.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.socialName,
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
                    controller: edtText,
                    hintText: '${widget.socialName} Username',
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
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (edtText.text.isNotEmpty) {
                          if (widget.socialId == '17') {
                            Navigator.of(context).pop();
                            /*venmoUserSheet(
                                venmoUserName: username.text,
                                userSocialName: widget.venmoSHareUrl ?? ' ',
                                socialId: widget.socialIdl,
                                context: widget.context,
                                inputHint: widget.inputHint,
                                socialMediaName: widget.socialPlatformNName,
                                socialIcon: widget.socialIcon.replaceAll('https://app.pinned.eu/pinned/public/social_icon/', ''));*/
                          } else {
                            addSocialLink(refreshData: widget.refreshData, socialId: widget.socialId, socialLink: edtText.text, context: context);
                          }
                        } else {
                          showToast('Enter social Link', context);
                        }
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
                              )),
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*void venmoUserSheet(
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
}*/

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
