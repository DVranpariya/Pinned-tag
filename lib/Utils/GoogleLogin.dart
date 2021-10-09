import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/process_indicator.dart';

Future<GoogleSignInAccount> googleLogin(BuildContext context) async {
  Circle processIndicator = Circle();

  processIndicator.show(context);

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  try {
    await _googleSignIn.signIn();
    bool isSigned = await _googleSignIn.isSignedIn();

    if (isSigned == true) {
      return _googleSignIn.currentUser;
    } else {
      processIndicator.hide(context);

      showToast('Signin to Continue', context);
    }
  } catch (error) {
    // showToast(error.toString(), context);
    print(error);
    processIndicator.hide(context);
  }
  return null;
}
