import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:plnned/screens/HomeScreen.dart';
import 'Constant.dart';

Future androidWrite({String fireBessDynamicLink, BuildContext context}) async {
  NFCTag _tag;

  NFCAvailability availability;
  try {
    availability = await FlutterNfcKit.nfcAvailability;
  } on PlatformException {
    availability = NFCAvailability.not_supported;
  }
  print(availability);
  if (NFCAvailability.available == availability) {
    try {
      if (Platform.isAndroid) {
        showNFCWriteDialog(context);
      }
      NFCTag tag = await FlutterNfcKit.poll(
        iosAlertMessage: tagWriteMessage,
      );
      await FlutterNfcKit.writeNDEFRecords([
        ndef.UriRecord.fromString(fireBessDynamicLink)
      ]).then((value) => {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            showToast('Tag write Succesfully', context)
          });
      await FlutterNfcKit.finish(
        iosAlertMessage: 'Successfully activated your Pinned',
      );
    } catch (e) {
      print(e);
    }
  } else {
    showToast('Your mobile does not support NFC', context);
  }
}

void showNFCWriteDialog(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    builder: (context) => Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    "Ready to Scan",
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
                    height: 90.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/ic_androidWrite.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Text(
                      'Hold your ncf tag to the middle back of your phone to activate it. Hold the nfc tag there until a success popup appears',
                      maxLines: 3,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
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
                        onPressed: () {
                          Navigator.pop(context);
                        }),
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
//                            controller: record.paylo  adController,
    // backgroundColor: Colors.yellow,
  );
}
