import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:plnned/Utils/Constant.dart';
import 'package:plnned/Utils/network_dio.dart';
import 'package:plnned/Utils/process_indicator.dart';
import 'package:plnned/Utils/updateAndroidPurchase.dart';
import 'package:plnned/components/inAppPurchase_button.dart';
import 'package:plnned/screens/HomeScreen.dart';

class InAppPurchaseScreen extends StatefulWidget {
  @override
  _InAppPurchaseScreenState createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  static Circle processIndicator = Circle();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _platformVersion = 'Unknown';
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;
  final List<String> _productLists = Platform.isAndroid ? ['in_app_purchase'] : ['Pinnedmonthlyplan'];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() async {
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
    await FlutterInappPurchase.instance.endConnection;
  }

  Future _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(_productLists);
    print('========items======');
    print("items: $items");
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      if (Platform.isAndroid) {
        print('Purchased');
        print(productItem);
        updateAndroidPurchase(context: context);
      } else {
        print('this is a ios platform subscription!');
        print('purchase Item 88 : $productItem');
        if (productItem.transactionId != null) {
          sendReceiptToServer();
          print('sdbfh dhfj dshf sdfhfs:${productItem.transactionId}');
        }
      }
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      processIndicator.hide(context);
    });
  }

  _requestPurchase(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestPurchase(item.productId);
      /*  print('my transaction id is ' + purchased.transactionId);
      if (purchased.transactionId != null) {
        print('inside if condition!');
        // processIndicator.hide(context);
        //sendReceiptToServer();
      } else {
        print('outside of else condition!');
      }*/
      processIndicator.hide(context);
    } on Exception catch (e) {
      showToast('Something went wrong please try again later', context);
      print(e);
    }
  }

  Future sendReceiptToServer({String receipt}) async {
    List<PurchasedItem> items = await FlutterInappPurchase.instance.getAvailablePurchases();
    print(items.first);

    var responseData;
    var data = FormData.fromMap({'receipt_data': items.first.transactionReceipt});
    print('-----------2-------------');
    NetworkDioHttp.setDynamicHeader(endPoint: BASE_URL);
    var response = await NetworkDioHttp.postDioHttpMethod(context, url: ADD_RECIEPT, data: data);
    print(response);
    if (response != null) {
      setState(() {
        responseData = response['body'];
      });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kColorDark, kPrimaryColor],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text('Switch To Business', style: kBusinessBold),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/ic_cancel.png'))),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 50.0,
                // ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BusinessInfoTile(
                      icon: 'ic_card.png',
                      headText: 'BUSINESS MODE',
                      info: 'When you enable Business mode, you gain access to all links as well as the Business profile option.',
                    ),
                    BusinessInfoTile(
                      icon: 'solution.png',
                      headText: 'BUSINESS SOLUTION',
                      info:
                          'We value and support small businesses. Excel, PDF file, CSV file, Google Docs, Google Sheets, Google Slides. Welcome to modern networking.',
                    ),
                    BusinessInfoTile(
                      icon: 'Ic_link_2.png',
                      headText: 'PINNED RECOMMENDED LINKS',
                      info: 'Amazon, Fiverr, Shopify, eToro, Bitcoin, Ethereum, Etsy, Website, Alibaba, Calendly, Linktree, Embedded Video.',
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text('€1.99 a per month', style: kMyLinksBigText),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: InAppPurchaseButton(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        androidPurchase(context: context);
                      } else {
                        processIndicator.show(context);
                        await _getProduct();
                        _requestPurchase(_items[0]);
                      }
                    },
                    height: 45.0,
                    textStyle: kPurchaseBusiness,
                    text: 'Go Business',
                    shadowColor: kColorPurchaseButton,
                    buttonColor: kColorPurchaseButton,
                    width: MediaQuery.of(context).size.width - 100,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchASURL(url: 'https://app.pinned.eu/pinned/terms_of_use');
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Terms of Use', style: kBusinessTerms, textAlign: TextAlign.center),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchASURL(url: 'https://app.pinned.eu/pinned/privacy_policy');
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Privacy Policy',
                          style: kBusinessTerms,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future androidPurchase({BuildContext context}) async {
    Circle processIndicator = Circle();

    processIndicator.show(context);
    await getProductForAndroid();
    processIndicator.hide(context);
    print(_items[0].productId);
    print('-----------------------------------');
    _requestPurchase(_items[0]);
  }

  Future getProductForAndroid() async {
    List items = await FlutterInappPurchase.instance.getProducts(_productLists);
    print('========items======');
    print(items);
    for (var item in items) {
      _items.add(item);
    }
  }
}

class BusinessInfoTile extends StatelessWidget {
  final String headText;
  final String info;
  final String icon;

  BusinessInfoTile({this.headText, this.icon, this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50.0,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/$icon"))),
          ),
          SizedBox(
            width: 30.0,
          ),
          Text(
            headText,
            textAlign: TextAlign.center,
            style: kBusinessBold,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            info,
            textAlign: TextAlign.center,
            style: kMyLinksBigText,
          ),
        ],
      ),
    );
  }
}
