import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'Constant.dart';
import 'internet_error.dart';
import 'process_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkDioHttp {
  static Dio _dio;
  static String endPointUrl;
  static DioCacheManager _dioCacheManager;
  static Options _cacheOptions =
      buildCacheOptions(Duration(days: 2), forceRefresh: true);
  static Circle processIndicator = Circle();
  NetworkCheck networkCheck = new NetworkCheck();
  static InternetError internetError = new InternetError();

  static Future<Map<String, String>> _getHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      return {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer' + ' ' + '$token',
      };
    } else {
      return {
        'Accept': 'application/json',
      };
    }
  }

  static dynamic getheaderdatamultipart({String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('token');
    dynamic headerdata;
    if (data != null) {
      headerdata = {
        HttpHeaders.authorizationHeader: 'Bearer' + ' ' + '$data',
        'Accept': 'application/json',
      };
    } else {
      headerdata = {
        'Accept': 'application/json',
      };
    }

    return headerdata;
  }

  static dynamic  Option() async {
    dynamic option = Options(
      headers: await getheaderdatamultipart(),
      method: 'Post',
      responseType: ResponseType.json,
      receiveDataWhenStatusError: true,
    );
    return option;
  }

  static setDynamicHeader({@required String endPoint}) async {
    endPointUrl = endPoint;
    /*BaseOptions options =
        BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    _dioCacheManager = DioCacheManager(CacheConfig());
    final token = await getheaderdatamultipart();
    options.headers.addAll(token);
    _dio = Dio();
    _dio.interceptors.add(_dioCacheManager.interceptor);*/
  }

  //Get Method
  static Future<Map<String, dynamic>> getDioHttpMethod(context,
      {@required String url}) async {
    if (context != null) processIndicator.show(context);
    try {
      Response response =
          await _dio.get("$endPointUrl$url", options: _cacheOptions);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = {
          'body': jsonEncode(response.data),
          'headers': response.headers,
          'error_description': null,
        };
        if (context != null) processIndicator.hide(context);
        return data;
      } else {
        if (context != null) processIndicator.hide(context);
        return {
          'body': null,
          'headers': null,
          'error_description': "Something Went Wrong",
        };
      }
    } catch (error) {
      print("=====================$error");
      Map<String, dynamic> responseData = {
        'body': null,
        'headers': null,
        'error_description': _handleError(error),
      };
      if (context != null) processIndicator.hide(context);
      return responseData;
    }
  }

  static Future<Map<String, dynamic>> putDioHttpMethod(context,
      {@required String url, Map<String, dynamic> data}) async {
    final token = await _getHeaders();
    print("??????$token????????");
    if (context != null) processIndicator.show(context);
    try {
      Response response = await _dio.put("$endPointUrl$url",
          data: data, options: _cacheOptions);
      print("$endPointUrl$url");
      print("########${response.headers}#########");
      if (response.statusCode == 200) {
        if (context != null) processIndicator.hide(context);
        return {
          'body': json.encode(response.data),
          'headers': response.headers,
          'error_description': null,
        };
      } else {
        if (context != null) processIndicator.hide(context);
        return {
          'body': null,
          'headers': null,
          'error_description': "Something Went Wrong",
        };
      }
    } catch (error) {
      print("error === $error");
      Map<String, dynamic> responseData = {
        'body': null,
        'headers': null,
        'error_description': _handleError(error),
      };
      if (context != null) processIndicator.hide(context);
      return responseData;
    }
  }

  static fetchPrefrence(bool isNetworkPresent) {
    if (isNetworkPresent) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //Post Method
  static Future<Map<String, dynamic>> postDioHttpMethod(context,
      {@required String url, data}) async {
    var internet = await check();
    if (internet != null && internet) {
      if (context != null) processIndicator.show(context);

      try {
        Dio _dio = Dio();
        final response = await _dio.post(
          "$endPointUrl$url",
          data: data,
          options: await Option(),
          //options: _cacheOptions,
        );

        print("response -->$response");
        print(response.statusCode);
        if (response.statusCode == 200) {
          if (context != null) processIndicator.hide(context);
          return {
            'body': response.data,
            'headers': response.headers,
            'error_description': null,
          };
        } else {
          print(response.statusCode.toString() +
              'Status Code ====================================');
          if (context != null) processIndicator.hide(context);
          return {
            'body': null,
            'headers': null,
            'error_description': "Something Went Wrong",
          };
        }
      } catch (error) {
        print(error);
        if (error is DioError) {
          DioError dioError = error;
          Map<String, dynamic> responseData = {
            'body': null,
            'headers': null,
            'error_description': _handleError(error),
          };

          var response = jsonDecode(dioError.response.toString());
          print(response.toString());
          print(dioError.response.toString());
          // showToast('${response['msg']}', context);
          if (context != null) processIndicator.hide(context);
          // processIndicator.isShow;
          return responseData;
        } else {
          Map<String, dynamic> responseData = {
            'body': null,
            'headers': null,
            'error_description': null,
          };
          return responseData;
        }
      }
    } else {
      Map<String, dynamic> responseData = {
        'body': null,
        'headers': null,
        'error_description': "Internet Error",
      };
      internetError.addOverlayEntry(context);
      return responseData;
      // func(false);
    }

    // final result = await InternetAddress.lookup('google.com');
    // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
  }

  static Future<Map<String, dynamic>> tempPostDioHttpMethod(
      {@required String url, data, context}) async {
    var internet = await check();
    if (internet != null && internet) {
      if (context != null) processIndicator.show(context);

      try {
        Dio _dio = Dio();
        final response = await _dio.post(
          "$endPointUrl$url",
          data: data,
          options: await Option(),
          //options: _cacheOptions,
        );

        print("response -->$response");
        print(response.statusCode);
        if (response.statusCode == 200) {
          if (context != null) processIndicator.hide(context);
          return {
            'body': response.data,
            'headers': response.headers,
            'error_description': null,
          };
        } else {
          print(response.statusCode.toString() +
              'Status Code ====================================');
          if (context != null) processIndicator.hide(context);
          return {
            'body': null,
            'headers': null,
            'error_description': "Something Went Wrong",
          };
        }
      } catch (error) {
        print(error);
        if (error is DioError) {
          DioError dioError = error;
          Map<String, dynamic> responseData = {
            'body': null,
            'headers': null,
            'error_description': _handleError(error),
          };

          var response = jsonDecode(dioError.response.toString());
          print(response.toString());
          print(dioError.response.toString());
          // showToast('${response['msg']}', context);
          if (context != null) processIndicator.hide(context);
          // processIndicator.isShow;
          return responseData;
        } else {
          Map<String, dynamic> responseData = {
            'body': null,
            'headers': null,
            'error_description': null,
          };
          return responseData;
        }
      }
    } else {
      Map<String, dynamic> responseData = {
        'body': null,
        'headers': null,
        'error_description': "Internet Error",
      };
      internetError.addOverlayEntry(context);
      return responseData;
      // func(false);
    }

    // final result = await InternetAddress.lookup('google.com');
    // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
  }

  //Multiple Concurrent
  static Future<Map<String, dynamic>> multipleConcurrentDioHttpMethod(context,
      {@required String getUrl,
      @required String postUrl,
      @required Map<String, dynamic> postData}) async {
    try {
      if (context != null) processIndicator.show(context);
      List<Response> response = await Future.wait([
        _dio.post("$endPointUrl/$postUrl",
            data: postData, options: _cacheOptions),
        _dio.get("$endPointUrl/$getUrl", options: _cacheOptions)
      ]);
      if (response[0].statusCode == 200 || response[0].statusCode == 200) {
        if (response[0].statusCode == 200 && response[1].statusCode != 200) {
          if (context != null) processIndicator.hide(context);
          return {
            'getBody': null,
            'postBody': json.decode(response[0].data),
            'headers': response[0].headers,
            'error_description': null,
          };
        } else if (response[1].statusCode == 200 &&
            response[0].statusCode != 200) {
          if (context != null) processIndicator.hide(context);
          return {
            'getBody': null,
            'postBody': json.decode(response[0].data),
            'headers': response[0].headers,
            'error_description': null,
          };
        } else {
          if (context != null) processIndicator.hide(context);
          return {
            'postBody': json.decode(response[0].data),
            'getBody': json.decode(response[0].data),
            'headers': response[0].headers,
            'error_description': null,
          };
        }
      } else {
        if (context != null) processIndicator.hide(context);
        return {
          'postBody': null,
          'getBody': null,
          'headers': null,
          'error_description': "Something Went Wrong",
        };
      }
    } catch (error) {
      Map<String, dynamic> responseData = {
        'postBody': null,
        'getBody': null,
        'headers': null,
        'error_description': _handleError(error),
      };
      if (context != null) processIndicator.hide(context);
      return responseData;
    }
  }

  //Sending FormData
  static Future<Map<String, dynamic>> sendingFormDataDioHttpMethod(context,
      {@required String url, @required Map<String, dynamic> data}) async {
    try {
      if (context != null) processIndicator.show(context);
      FormData formData = new FormData.fromMap(data);
      Response response = await _dio.post("$endPointUrl$url",
          data: formData, options: _cacheOptions);
      if (response.statusCode == 200) {
        if (context != null) processIndicator.hide(context);
        return {
          'body': json.decode(response.data),
          'headers': response.headers,
          'error_description': null,
        };
      } else {
        if (context != null) processIndicator.hide(context);
        return {
          'body': null,
          'headers': null,
          'error_description': "Something Went Wrong",
        };
      }
    } catch (error) {
      Map<String, dynamic> responseData = {
        'body': null,
        'headers': null,
        'error_description': _handleError(error),
      };
      if (context != null) processIndicator.hide(context);
      return responseData;
    }
  }

  //Handle Error
  static Future<String> _handleError(DioError error) async {
    String errorDescription = "";
    try {
      print("In side try");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("In side internet condition");
        if (error is DioError) {
          DioError dioError = error;
          switch (dioError.type) {
            case DioErrorType.CANCEL:
              errorDescription = "Request to API server was cancelled";
              print(errorDescription);
              break;
            case DioErrorType.CONNECT_TIMEOUT:
              errorDescription = "Connection timeout with API server";
              print(errorDescription);
              break;
            case DioErrorType.DEFAULT:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              print(errorDescription);
              break;
            case DioErrorType.RECEIVE_TIMEOUT:
              errorDescription =
                  "Receive timeout in connection with API server";
              print(errorDescription);
              break;
            case DioErrorType.RESPONSE:
              errorDescription =
                  "Received invalid status code: ${dioError.response.statusCode}";
              print(errorDescription);
              break;
            case DioErrorType.SEND_TIMEOUT:
              errorDescription = "Send timeout in connection with API server";
              print(errorDescription);
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
          print(errorDescription);
        }
      }
    } on SocketException catch (_) {
      errorDescription = "Please check your internet connection";
      print(errorDescription);
    }

    return errorDescription;
  }
}

class NetworkCheck {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  dynamic checkInternet(bool func) {
    check().then((intenet) {
      if (intenet != null && intenet) {
        // func(true);
        return true;
      } else {
        return false;
        // func(false);
      }
    });
  }
}
