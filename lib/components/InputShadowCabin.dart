import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';

class InputShadowCabin extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefix;
  final TextInputType type;
  final bool readonly;
  final double height;
  final bool obscureText;
  final bool autofocus;

  InputShadowCabin({this.controller, this.hintText, this.prefix, this.type, this.readonly, this.height, this.obscureText, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        /* margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kGreyColor, width: 1)),*/
        width: size.width * 0.9,
        height: height,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              obscureText: obscureText == null ? false : true,
              keyboardType: type,
              style: kInputTextStyleCabin,
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              autofocus: autofocus,
              cursorColor: Colors.black,
              decoration: prefix == ''
                  ? InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: hintText,
                      border: InputBorder.none,
                      labelStyle: kInputTextStyleCabin,
                    )
                  : InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Tab(
                            icon: Image.asset(
                              prefix,
                              height: 18,
                              fit: BoxFit.contain,
                              width: 18,
                            ),
                          ),
                        ),
                      ),
                      isDense: true,
                      hintText: hintText,
                      border: InputBorder.none,
                      labelStyle: kInputTextStyleCabin,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
