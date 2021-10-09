import 'package:flutter/material.dart';

class InternetError {
  static final _instance = new InternetError.internal();
  factory InternetError() => _instance;
  InternetError.internal();

  static OverlayEntry entry;

  void show(context, page) => addOverlayEntry(context);
  void hide() => removeOverlay();

  bool get isShow => entry != null;

  addOverlayEntry(context) {
    if (entry != null) return;
    entry = new OverlayEntry(builder: (BuildContext context) {
      return LayoutBuilder(builder: (_, BoxConstraints constraints) {
        return new Material(
          color: Colors.white,
          child: new Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Image.asset(
                  'assets/no-internet.gif',
                  height: 250,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Please check your internet conncetion!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0)),
                    color: Colors.black.withOpacity(0.1),
                    onPressed: () {
                      removeOverlay();
                    },
                    child: Text(
                      "Okay",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });

    addoverlay(entry, context);
  }

  addoverlay(OverlayEntry entry, context) async {
    Overlay.of(context).insert(entry);
  }

  removeOverlay() {
    entry?.remove();
    entry = null;
  }
}
