import 'package:firebase_messaging/firebase_messaging.dart';

class FcmInitial {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermission() async {
        await _firebaseMessaging.requestPermission();
  }

  Future<String?> getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print("Device Token: $token");
      return token;
    } catch (e) {
      print("Failed to get device token: $e");
      return null;
    }
  }

  void initializeNotificationListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Received a foreground notification: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened from background.");
    });
  }
}
