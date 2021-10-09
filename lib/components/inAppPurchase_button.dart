import 'package:flutter/material.dart';

class InAppPurchaseButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Color shadowColor, buttonColor;
  final TextStyle textStyle;
  final Function onTap;

  InAppPurchaseButton({
    this.text,
    this.height,
    this.width,
    this.onTap,
    this.shadowColor,
    this.buttonColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
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
                    text,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
