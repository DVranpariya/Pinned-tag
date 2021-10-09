  import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/components/Input_Field_Simple_Grey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String labelText, mainText;
  final int type;
  String keyName;
  String preferenceKey;

  EditProfileScreen(
      {this.labelText,
      this.mainText,
      this.type,
      this.keyName,
      this.preferenceKey});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController username = new TextEditingController();
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      username = TextEditingController(text: widget.mainText);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0.0,
          backgroundColor: kPrimaryColor,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: kEditProfileText,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/ic_back.png',
              height: 20,
              width: 20,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    saveUserProfile(widget.type, data);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        'Save',
                        style: kEditProfileText,
                      )),
                ),
              ],
            )
          ],
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InputFieldSimpleGrey(
              width: size.width * 0.9,
              controller: username,
              hintText: widget.labelText,
              prefix: '',
              type: TextInputType.text,
            ),
          ),
        ),
      ),
    );
  }

  Future saveUserProfile(int type, var sendData) async {
    var userdata;
    var data;
    data = FormData.fromMap({
      widget.keyName: username.text,
    });
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context,
        url: UPDATE_PROFILE, data: data);
    print(response);
    if (response != null) {
      userdata = response['body'];

      if (userdata['status'] == 1) {
        print(username.text);
        Navigator.of(context).pop();
      }
    } else {
      showToast('Something went wrong', context);
    }
    return;
  }

  Future savePreferenceData({String key, value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
