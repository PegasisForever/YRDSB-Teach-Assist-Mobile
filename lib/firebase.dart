import 'package:firebase_messaging/firebase_messaging.dart';

//Firebase Cloud Messaging
final _firebaseMessaging = FirebaseMessaging();
var firebaseInited = false;
var firebaseToken;

void initFirebaseMsg() {
  _firebaseMessaging.configure();
  _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(
    sound: true,
    badge: true,
    alert: true,
  ));
  _firebaseMessaging.getToken().then((String token) {
    firebaseInited = true;
    firebaseToken = token;
  });
}

bool supportsGooglePlay() {
  return firebaseToken != null;
}
