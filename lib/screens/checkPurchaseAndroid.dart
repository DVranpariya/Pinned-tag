import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:plnned/Utils/updateAndroidPurchase.dart';

Future checkInAppPurchase() async {
  var result = await FlutterInappPurchase.instance.initConnection;
  print('result: $result');
  try {
    String msg = await FlutterInappPurchase.instance.consumeAllItems;
    print('consumeAllItems: $msg');
  } catch (err) {
    print('consumeAllItems error: $err');
  }

  List<PurchasedItem> purchaseHistory =
      await FlutterInappPurchase.instance.getAvailablePurchases();

  PurchaseState purchaseStatus = PurchaseState.purchased;
  if (purchaseHistory.isNotEmpty) {
    if (purchaseHistory[0].purchaseStateAndroid == purchaseStatus) {
      print('Purchased');
      updatePurchaseState(purchaseState: '1');
    } else {
      print('Purchase Not Available');
      updatePurchaseState(purchaseState: '0');
    }
  } else {
    print('value Not Available');
    updatePurchaseState(purchaseState: '0');
  }

  print(purchaseHistory);
}
