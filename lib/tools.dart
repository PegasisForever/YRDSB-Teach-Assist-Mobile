import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void adjustNavColor(BuildContext context){
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      systemNavigationBarIconBrightness:
//      Theme.of(context).brightness == Brightness.dark
//          ? Brightness.light
//          : Brightness.dark,
//      systemNavigationBarDividerColor: Colors.black,
//      systemNavigationBarColor: Theme.of(context).canvasColor));
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler(this.resumeCallBack);

  final AsyncCallback resumeCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state==AppLifecycleState.resumed){
      await resumeCallBack();
    }
    return;
  }
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  Scaffold.of(context).showSnackBar(snackBar);
}