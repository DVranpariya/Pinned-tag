import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';

class TextContainer extends StatelessWidget {
  final String labelText, mainText, isUsername;

  TextContainer(this.labelText, this.mainText,this.isUsername);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: kLabelText,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mainText,
                  maxLines: 2,
                  style: kMainText,
                ),
              ),
              SizedBox(width: 10,),
              isUsername != null ?Image.asset(
                'assets/ic_arrow.png',
                height: 10,
                width: 10,
              ) : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                height: 1,
                color: kLightSilverColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
