import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/components/Round_Corner_Image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCapture extends StatefulWidget {
  final userName, userProfile, link;

  QrCapture({this.userName, this.userProfile, this.link});

  @override
  _QrCaptureState createState() => _QrCaptureState();
}

class _QrCaptureState extends State<QrCapture> {
  GlobalKey globalKey = new GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

/*  screenShot() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    //   screenshotController.capture(delay: const Duration(seconds: 2), pixelRatio: 1024);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      Permission.storage.request();
    }

    screenshotController.capture().then((Uint8List image) {
      print('image');
      print(image);
    }).catchError((onError) {
      print('onError');
      print(onError);
    });
    print("File Saved to Gallery");
  }*/

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  String firstButtonText = 'Save Qr Code';
  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      // var image = await boundary.toImage();
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      print(image);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      if (file != null && file.path != null) {
        setState(() {
          firstButtonText = 'saving in progress...';
        });
        await GallerySaver.saveImage(file.path).then((path) {
          setState(() {
            firstButtonText = 'image saved!';
          });
        });
      }
      // await Share.files('esys images', {'pinQr.png': pngBytes}, '*/*',
      //     text: 'download qr code of my profile');
    } catch (e) {
      print(e.toString());
    }
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print('$info');
    //saveScreen();
    // _captureAndSharePng();
  }

  saveScreen() async {
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    if (boundary.debugNeedsPaint) {
      Timer(Duration(seconds: 5), () => saveScreen());
      return null;
    }
    // ui.Image image = await boundary.toImage();
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
    // await Share.files('esys images', {'esys.png': result}, '*/*', text: 'download qr code of my profile');
    // Navigator.of(context).pop();
    // print('$byteData ********** Saved to gallery *********** ${result.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    final size = 150.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          'My Qr Code',
          style: TextStyle(
            fontSize: 18.0,
            color: kColorAppleButton,
            fontFamily: 'PoppinsRegular',
            decoration: TextDecoration.none,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/ic_backl.png',
            height: 20,
            width: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [kColorDark, kPrimaryColor],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.9])),
        child: Column(
          children: [
            Expanded(
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [kColorDark, kPrimaryColor],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.3, 0.9])),
                  child: Column(
                    /*  mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,*/
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 0.0,
                            sigmaY: 0.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                              ),
                              child: Container(
                                height: 460,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey.shade100.withOpacity(0.00001),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 30,
                                        left: 30,
                                        right: 30,
                                      ),
                                      child: Column(
                                        children: [
                                          RoundCornerImage(
                                            height: 100,
                                            width: 100,
                                            image: widget.userProfile ?? '',
                                            circular: 100,
                                            placeholder:
                                                'ic_profile_placeholder.png',
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              widget.userName,
                                              style: kQrCodeUserName,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          QrImage(
                                            data: widget.link,
                                            version: QrVersions.auto,
                                            size: 180.0,
                                            foregroundColor: Colors.black,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            scanQrText,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontFamily: 'PoppinsRegular',
                                              decoration: TextDecoration.none,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
            GestureDetector(
              onTap: () async {
                await _captureAndSharePng();
                // await Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffE32863),
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
                child: Center(
                  child: Text(
                    firstButtonText,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
