import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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