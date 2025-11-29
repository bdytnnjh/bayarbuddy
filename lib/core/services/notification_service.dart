import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../configs/firebase_options.dart';

typedef NotificationTapCallback = void Function(Map<String, dynamic> data);

const AndroidNotificationChannel _defaultAndroidChannel = AndroidNotificationChannel(
  'sidhiq_default_channel',
  'SIDHIQ Notifications',
  description: 'General SIDHIQ notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool _initialized = false;
  bool _localPluginInitialized = false;
  NotificationTapCallback? _onNotificationTap;

  Future<void> initialize({NotificationTapCallback? onNotificationTap}) async {
    if (onNotificationTap != null) {
      _onNotificationTap = onNotificationTap;
    }

    if (_initialized) {
      return;
    }

    await _configureForegroundPresentation();
    await _ensureLocalNotificationsInitialized();
    await _requestPermissions();

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    _messaging.onTokenRefresh.listen((token) {
      debugPrint('FCM token refreshed: $token');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTapPayload(initialMessage.data);
    }

    _initialized = true;
  }

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM token: $token');
      return token;
    } catch (error, stackTrace) {
      debugPrint('Failed to get FCM token: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }

  void registerOnNotificationTap(NotificationTapCallback callback) {
    _onNotificationTap = callback;
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        debugPrint('Subscribed to topic: $topic');
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to subscribe to topic $topic: $error');
      debugPrint('$stackTrace');
      rethrow;
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        debugPrint('Unsubscribed from topic: $topic');
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to unsubscribe from topic $topic: $error');
      debugPrint('$stackTrace');
      rethrow;
    }
  }

  Future<void> showNotificationFromMessage(RemoteMessage message) async {
    await _ensureLocalNotificationsInitialized();

    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title == null && body == null) {
      debugPrint('RemoteMessage without title/body ignored');
      return;
    }

    final payload = message.data.isNotEmpty ? jsonEncode(message.data) : null;

    // ✅ Download image jika ada imageUrl
    BigPictureStyleInformation? bigPictureStyle;
    ByteArrayAndroidBitmap? largeIcon;

    final androidDetails = AndroidNotificationDetails(
      _defaultAndroidChannel.id,
      _defaultAndroidChannel.name,
      channelDescription: _defaultAndroidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: notification?.android?.smallIcon ?? '@mipmap/launcher_icon',
      largeIcon: largeIcon, // ✅ Set large icon
      styleInformation: bigPictureStyle, // ✅ Set big picture style
      channelShowBadge: true,
    );

    const darwinDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: darwinDetails),
      payload: payload,
    );
  }

  /// Send notification to a specific device using FCM token
  /// Note: This requires a server-side implementation or Cloud Functions
  /// This method prepares the notification data structure
  Future<Map<String, dynamic>> sendNotificationByToken({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      // Prepare notification payload
      final payload = {
        'to': token,
        'notification': {'title': title, 'body': body, if (imageUrl != null) 'image': imageUrl},
        'data': data ?? {},
        'priority': 'high',
        'android': {
          'priority': 'high',
          'notification': {'channel_id': _defaultAndroidChannel.id, 'sound': 'default'},
        },
        'apns': {
          'payload': {
            'aps': {'sound': 'default', 'badge': 1},
          },
        },
      };

      debugPrint('Notification payload prepared for token: $token');
      debugPrint('Payload: $payload');

      // Return the payload - actual sending should be done via server/Cloud Functions
      return {
        'success': true,
        'payload': payload,
        'message': 'Notification payload prepared. Send this via your backend server.',
      };
    } catch (error, stackTrace) {
      debugPrint('Failed to prepare notification: $error');
      debugPrint('$stackTrace');
      return {'success': false, 'message': error.toString()};
    }
  }

  Future<void> _configureForegroundPresentation() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification permission status: ${settings.authorizationStatus}');

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localPluginInitialized) {
      return;
    }

    const androidInitialization = AndroidInitializationSettings('@mipmap/launcher_icon');
    final darwinInitialization = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initializationSettings = InitializationSettings(android: androidInitialization, iOS: darwinInitialization);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_defaultAndroidChannel);

    _localPluginInitialized = true;
  }

  void _onMessage(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Foreground message received: ${message.messageId}');
    }
    showNotificationFromMessage(message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Notification opened from background/terminated: ${message.messageId}');
    }
    _handleMessageTapPayload(message.data);
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint('Local notification tapped: ${response.payload}');
    }
    handleNotificationResponsePayload(response.payload);
  }

  void handleNotificationResponsePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }

    final data = _decodePayload(payload);
    if (data != null) {
      _dispatchNotificationTap(data);
    }
  }

  void _handleMessageTapPayload(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return;
    }
    _dispatchNotificationTap(data);
  }

  void _dispatchNotificationTap(Map<String, dynamic> data) {
    if (_onNotificationTap != null) {
      _onNotificationTap!(data);
    } else {
      debugPrint('Notification tap callback not registered. Payload: $data');
    }
  }

  Map<String, dynamic>? _decodePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (error, stackTrace) {
      debugPrint('Failed to decode notification payload: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  NotificationService.instance.handleNotificationResponsePayload(response.payload);
}
