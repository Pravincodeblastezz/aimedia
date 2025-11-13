import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  static Future<void> initializeFCM() async {
    await _fcm.requestPermission();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _local.show(
          0,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails('ai_media', 'AI Media Notifications'),
          ),
        );
      }
    });
  }

  static Future<void> showLoginNotification() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('login_channel', 'Login Notifications'),
    );
    await _local.show(0, 'Login Successful', 'Welcome to AI Media!', details);
  }
}
