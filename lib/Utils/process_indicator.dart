import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'Constant.dart';
import 'internet_error.dart';


class Circle {
  static final _instance = new Circle.internal();
  factory Circle() => _instance;

  Circle.internal();
  static bool entry = false;
  static OverlayEntry viewEntry =
      new OverlayEntry(builder: (BuildContext context) {
    return ProcessIndicator();
  });

  InternetError internetError = new InternetError();

  show(context) async {

    return addOverlayEntry(context);
  }

  void hide(context) => removeOverlay();

  bool get isShow => isShowNetworkOrCircle();

  bool isShowNetworkOrCircle() {
    return internetError.isShow || entry == true;
  }

  addOverlayEntry(context) async {
    if (entry == true) return;
    entry = true;
    return addOverlay(viewEntry, context);
  }

  addOverlay(OverlayEntry entry, context) async {
    try {
      return Overlay.of(context).insert(entry);
    } catch (ex) {
//      print(ex.toString());
    }
  }

  removeOverlay() {
    try {
      entry = false;
      viewEntry?.remove();

    } catch (ex) {
      print(ex.toString());
    }
  }

}

class ProcessIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      ),
      inAsyncCall: true,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
            ),
          ),
        ),
      ),
    );
  }
}
