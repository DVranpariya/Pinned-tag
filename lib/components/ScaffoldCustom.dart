import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plnned/Utils/DrawerCustom.dart';

class ScaffoldCustom extends StatelessWidget {
  final Widget child;
  final Widget appbar;
  final Widget bottomSheet;
  final bool isDrawer;

  ScaffoldCustom(
      {@required this.child, this.appbar, this.bottomSheet, this.isDrawer});

  @override
  Widget build(BuildContext context) {
/*
    final rtl = ZoomDrawer.isRTL();
*/
    return GestureDetector(
      /* onPanUpdate: (details) {
        if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
          isDrawer ??  ZoomDrawer.of(context).toggle();
        }
      },*/
      child: Scaffold(
        drawer: DrawerCustom(),
        appBar: appbar,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: child,
        ),
        bottomSheet: bottomSheet,
      ),
    );
  }
}
