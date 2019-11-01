import 'package:flutter/material.dart';
import 'package:ta/res/Strings.dart';

import '../tools.dart';

abstract class BetterState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    updateNavigationBarBrightness();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state==AppLifecycleState.resumed){
      updateNavigationBarBrightness();
    }
  }

  @override
  Widget build(BuildContext context) {
    updateNavigationBarBrightness(context: context);
    Strings.updateCurrentLanguage(context);
    return null;
  }
}