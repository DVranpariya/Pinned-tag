import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/screens/HomeScreen.dart';

import 'Constant.dart';

Future unLinkPinnedTag({BuildContext context, int isLinkActive}) async {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Unlink",
      style: TextStyle(fontFamily: 'flatosemiboald'),
    ),
    onPressed: () async {
      deActiveTag(context: context, isLinkActive: isLinkActive);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Unlink Pinned",
      style: kLogoutTextBlack,
    ),
    content: Text(
      "Are you sure you want to Unlink Pinned?",
      style: kLoginButtonTextBlack,
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future linkPinnedTag({BuildContext context, int isLinkActive}) async {
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Active",
      style: TextStyle(fontFamily: 'flatosemiboald'),
    ),
    onPressed: () async {
      deActiveTag(context: context, isLinkActive: isLinkActive);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(
      "Activate Pinned",
      style: kLogoutTextBlack,
    ),
    content: Text(
      "Are you sure you want Activate Pinned?",
      style: kLoginButtonTextBlack,
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future deActiveTag({BuildContext context, int isLinkActive}) async {
  var data = FormData.fromMap({'is_link_active': isLinkActive});
  var userdata;
  NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
  var response = await NetworkDioHttp.postDioHttpMethod(context, url: UNLINK_TAG, data: data);

  if (response != null) {
    userdata = response['body'];
    if (userdata['status'] == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
      showToast('${userdata['msg']}', context);
    }
  } else {
    showToast('Something went wrong', context);
  }

  return;
}
