import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  int notificationId = 0;

  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationService._internal();

  Future<NotificationService> init() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return this; // Disable notification handling for unsupported platforms
    }

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(settings);
    return this;
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return; // Skip showing notifications for unsupported platforms
    }

    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Messages',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      details,
    );

    notificationId++;
  }
}
