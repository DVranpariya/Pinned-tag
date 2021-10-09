import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';

class InputFieldSimpleGrey extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefix;
  final TextInputType type;
  final bool readonly;
  final double width;

  InputFieldSimpleGrey(
      {this.controller,
      this.hintText,
      this.prefix,
      this.type,
      this.readonly,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: width,
      height: 55,
      child: TextFormField(
        maxLines: 5,
        minLines: 1,
        readOnly: readonly == null ? false : readonly,
        enabled: readonly == null ? true : false,
        keyboardType: type,
        style: kEditText,
        controller: controller,
        autofocus: false,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: kHeadLabelSmallText,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: kLightSilverColor,
          )),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kLightSilverColor)),
        ),
      ),
    );
  }
}
