import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';

class ColorShadowButtonRound extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Color shadowColor, buttonColor;
  final TextStyle textStyle;
  final String icon;
  final String buttonText;

  ColorShadowButtonRound({this.text, this.height, this.width, this.shadowColor, this.buttonColor, this.textStyle, this.icon, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        gradient: LinearGradient(
          colors: [kColorDark, kPrimaryColor],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [-0.3, 0.6],
        ),
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
                text != null
                    ? Text(
                        text,
                        style: kDrawerTextPop,
                      )
                    : Image.asset(
                        icon,
                        height: 30,
                        width: 30,
                      ),
                buttonText != null
                    ? SizedBox(
                        width: 10,
                      )
                    : Container(),
                buttonText != null
                    ? Text(
                        buttonText,
                        style: kDrawerTextPop,
                      )
                    : Container()
              ],
            )),
          ),
        ),
      ),
    );
  }
}
