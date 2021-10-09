import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';

class InputFieldEditDialog extends StatelessWidget {
  final int gradientStart, gradientEnd;
  final TextEditingController controller;
  final String prefix;
  final TextInputType type;
  final double width;
  final BuildContext context;

  InputFieldEditDialog({
    this.controller,
    this.prefix,
    this.context,
    this.type,
    this.width,
    this.gradientEnd,
    this.gradientStart,
  });

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[3],
        borderRadius: BorderRadius.circular(50.0),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(gradientStart),
            Color(gradientEnd),
          ],
        ),
      ),
      child: TextField(
        controller: controller,
        style: kEditInput,
        keyboardType: type,
        autocorrect: false,
        cursorColor: kColorAppleButton,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(360.0),
              child: Image.asset(prefix, width: 50, height: 50, fit: BoxFit.fill),
            ),
          ),
          suffixIcon: Tab(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.clear();
              },
              child: Image.asset(
                'assets/ic_cancel.png',
                width: 10,
                fit: BoxFit.contain,
                height: 10,
              ),
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
