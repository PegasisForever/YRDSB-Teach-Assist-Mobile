import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta/res/Strings.dart';

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

String getRoundString(double num,int digit){
  var str=num.toStringAsFixed(digit);
  while (str[str.length-1]=="0"){
    str=str.substring(0,str.length-1);

    if (str[str.length-1]=="."){
      str=str.substring(0,str.length-1);
      break;
    }
  }

  return str;
}

String testBlank(String str){
  if (str.isEmpty){
    return Strings.get("unknown");
  }else{
    return str;
  }
}

bool isZeroOrNull(num n){
  return n==0 || n==null;
}

String unGzip(Uint8List bytes){
  return Utf8Decoder().convert(GZipDecoder().decodeBytes(bytes));
}

double getBottomPadding(BuildContext context){
  var query=MediaQuery.of(context);
  return query.padding.bottom+query.viewInsets.bottom;
}

void updateNavigationBarBrightness(BuildContext context){
  var brightness=MediaQuery.of(context).platformBrightness;
  print(brightness);
  if (brightness==Brightness.light){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    print("set to light");
  }else{
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    print("set to dark");
  }
}

SystemUiOverlayStyle getSystemUiOverlayStyle(BuildContext context){
  var brightness=MediaQuery.of(context).platformBrightness;
  return brightness==Brightness.light?SystemUiOverlayStyle.light:SystemUiOverlayStyle.dark;
}

bool isLightMode(BuildContext context){
  return MediaQuery.of(context).platformBrightness==Brightness.light;
}

bool isSameDay(DateTime d1,DateTime d2){
  return d1.year==d2.year && d1.month==d2.month && d1.day==d2.day;
}