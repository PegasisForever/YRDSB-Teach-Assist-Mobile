import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_privacy_screen/flutter_privacy_screen.dart';
import 'package:ta/plugins/dataStore.dart';

final _firebaseMessaging = FirebaseMessaging();
var firebaseInited = false;

void initFirebaseMsg() {
  _firebaseMessaging.configure();
  _firebaseMessaging.getToken().then((String token) {
    firebaseInited = true;
    if (token != null) {
      Config.firebaseToken = token;
    }
  });
}

void firebaseRequestNotificationPermissions() async{
  FlutterPrivacyScreen.disablePrivacyScreen();
  await Future.delayed(const Duration(seconds: 1));
  _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(
    sound: true,
    badge: true,
    alert: true,
  ));
  if (Config.hideAppContent) {
    FlutterPrivacyScreen.enablePrivacyScreen();
  }
}

bool supportsGooglePlay() {
  if (firebaseInited) {
    return Config.firebaseToken != null;
  } else {
    return null;
  }
}
