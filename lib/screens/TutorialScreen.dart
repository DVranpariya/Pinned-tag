import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/DrawerCustom.dart';
import 'package:plnned/screens/HomeScreen.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  GlobalKey<PageContainerState> key = GlobalKey();
  PageController _c;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(
        currentIndex: 5,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [kColorDark, kPrimaryColor],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.9])),
        child: Tutorial(
            deviceName: Platform.isIOS ? 'To Iphone' : 'To Android',
            imageString: 'assets/ic_android_tag_read.png',
            showText: Platform.isIOS
                ? 'Tap on the Pinned to the very top of the back of another iphone to share your profile with iphone'
                : 'Tap on the Pinned to the Middle back of the another android to share your profile with androids'),

        // PageIndicatorContainer(
        //   length: 2,
        //   key: key,
        //   indicatorSelectorColor: Colors.white,
        //   indicatorColor: Color(0xffB7DCF5),
        //   shape: IndicatorShape.circle(size: 7),
        //   align: IndicatorAlign.bottom,
        //   indicatorSpace: 5.0,
        //   child: PageView(
        //     onPageChanged: (newPage) {},
        //     controller: _c,
        //     children: <Widget>[
        //       Tutorial(
        //         deviceName: 'To Iphone',
        //         imageString: 'assets/ic_android_tag_read.png',
        //         showText:
        //             'Tap on the Pinned to the very top of the back of another iphone to share your profile with iphone',
        //       ),
        //   /*    if (Platform.isAndroid)
        //         Tutorial(
        //           deviceName: 'To Android',
        //           imageString: 'assets/ic_ios_tag_write.png',
        //           showText:
        //               'Tap on the Pinned to the Middle back of the another android to share your profile with Androids',
        //         ),*/
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

class Tutorial extends StatelessWidget {
  String imageString;
  String showText;
  String deviceName;

  Tutorial({this.imageString, this.showText, this.deviceName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [kColorDark, kPrimaryColor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.3, 0.9])),
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  })
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              height: size.height / 2 - 50,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imageString), fit: BoxFit.fitHeight)),
            ),
          ),
          Container(
            child: Column(
              children: [
                Text(
                  deviceName,
                  style: TextStyle(
                      fontFamily: 'flatosemiboald',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: size.width / 2,
                  child: Text(
                    showText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'bold',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
