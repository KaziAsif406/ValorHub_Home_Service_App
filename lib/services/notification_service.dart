import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    /// REQUEST PERMISSION
    await FirebaseMessaging.instance.requestPermission();

    /// ANDROID INIT
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    /// iOS INIT
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _localNotifications.initialize(settings: settings);

    /// FOREGROUND MESSAGE
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification == null) return;

      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'Chat Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });

    // Save current token (if user already logged in)
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await saveFCMToken(token: token);
      }
    } catch (e, st) {
      dev.log('Failed to fetch/save initial FCM token: $e',
          error: e, stackTrace: st, name: 'NotificationService');
    }

    // Listen for token refreshes and save them
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        if (newToken.isNotEmpty) await saveFCMToken(token: newToken);
      } catch (e, st) {
        dev.log('Failed to save refreshed FCM token: $e',
            error: e, stackTrace: st, name: 'NotificationService');
      }
    });
  }

  /// Saves the provided FCM [token] into the current user's Firestore document.
  /// If no user is signed in the token is ignored.
  static Future<void> saveFCMToken({required String token}) async {
    try {
      if (token.isEmpty) return;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        dev.log('No signed-in user; skipping saving FCM token',
            name: 'NotificationService');
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp()
      }, SetOptions(merge: true));

      dev.log('Saved FCM token for user ${user.uid}',
          name: 'NotificationService');
    } catch (e, st) {
      dev.log('Error saving FCM token: $e',
          error: e, stackTrace: st, name: 'NotificationService');
    }
  }
}
