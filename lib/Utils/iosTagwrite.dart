import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'Constant.dart';

Future iosWrite({String fireBessDynamicLink, BuildContext context}) async {
  NFCTag _tag;

  NFCAvailability availability;
  try {
    availability = await FlutterNfcKit.nfcAvailability;
  } on PlatformException {
    availability = NFCAvailability.not_supported;
  }

  if (NFCAvailability.available == availability) {
    try {
      NFCTag tag = await FlutterNfcKit.poll(
        iosAlertMessage: tagWriteMessage,
      );
      await FlutterNfcKit.writeNDEFRecords([ndef.UriRecord.fromString(fireBessDynamicLink)]);
      await FlutterNfcKit.finish(iosAlertMessage: 'Successfully activated your PINNED');
    } catch (e) {
      print(e);
    }
  } else {
    showToast('Your iphone does not support NFC', context);
  }
}
