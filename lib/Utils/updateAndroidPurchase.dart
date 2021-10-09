import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plnned/screens/HomeScreen.dart';

import 'Constant.dart';
import 'network_dio.dart';

Future updateAndroidPurchase({BuildContext context}) async {
  var responseData;
  var data = FormData.fromMap({'is_business_profile': '1'});
  print('-----------2-------------');
  NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
  var response = await NetworkDioHttp.postDioHttpMethod(context, url: UPDATE_SUBSCRIPTION, data: data);
  print(response);
  if (response != null) {
    responseData = response['body'];

    if (responseData != null) {
      if (responseData['status'] == 1) {
        saveSharedPrefData(key: 'switch', value: true);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showToast('${responseData['msg']}', context);
      }

      print('inapp---> ' + response['body'].toString());
    }
  } else {
    showToast('Something went wrong', context);
  }
}

Future updatePurchaseState({BuildContext context, String purchaseState}) async {
  var responseData;
  var data = FormData.fromMap({'is_business_profile': purchaseState});
  print('-----------2-------------');
  NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
  var response = await NetworkDioHttp.postDioHttpMethod(context, url: UPDATE_SUBSCRIPTION, data: data);
  print("Ankitupdate");
  print(response);
  if (response != null) {
    responseData = response['body'];

    if (responseData != null) {
      if (responseData['status'] == 1) {
      } else {
        showToast('${responseData['msg']}', context);
      }

      print('Purchase Updated ---------------------------------------------------------> ' + response['body'].toString());
    }
  } else {
    showToast('Something went wrong', context);
  }
}
