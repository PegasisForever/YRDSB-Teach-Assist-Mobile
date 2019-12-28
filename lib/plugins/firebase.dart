import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ta/plugins/dataStore.dart';

final _firebaseMessaging = FirebaseMessaging();
var firebaseInited = false;

void initFirebaseMsg() {
  _firebaseMessaging.configure();
  _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(
    sound: true,
    badge: true,
    alert: true,
  ));
  _firebaseMessaging.getToken().then((String token) {
    firebaseInited = true;
    if (token != null) {
      Config.firebaseToken = token;
    }
  });
}

bool supportsGooglePlay() {
  if (firebaseInited) {
    return Config.firebaseToken != null;
  } else {
    return null;
  }
}
