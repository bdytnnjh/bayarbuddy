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

const AndroidNotificationChannel _helpRequestChannel = AndroidNotificationChannel(
  'bayarbuddy_help_request',
  'Emergency Help Requests',
  description: 'Urgent help request notifications from trusted contacts',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
  enableLights: true,
  showBadge: true,
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

    // Check if this is a help_request for full-screen intent
    final isHelpRequest = message.data['type'] == 'help_request' || message.data['type'] == 'scam_detection';

    // Use appropriate channel based on notification type
    final channel = isHelpRequest ? _helpRequestChannel : _defaultAndroidChannel;

    // ✅ Download image jika ada imageUrl
    BigPictureStyleInformation? bigPictureStyle;
    ByteArrayAndroidBitmap? largeIcon;

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.max,
      icon: notification?.android?.smallIcon ?? '@mipmap/launcher_icon',
      largeIcon: largeIcon,
      styleInformation: bigPictureStyle,
      channelShowBadge: true,
      // ✅ Full-screen intent untuk help request
      fullScreenIntent: isHelpRequest,
      category: isHelpRequest ? AndroidNotificationCategory.call : null,
      visibility: isHelpRequest ? NotificationVisibility.public : null,
      ongoing: isHelpRequest,
      autoCancel: !isHelpRequest,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: darwinDetails),
      payload: payload,
    );
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
    await androidPlugin?.createNotificationChannel(_helpRequestChannel); // ✅ Create help request channel

    _localPluginInitialized = true;
  }

  void _onMessage(RemoteMessage message) {
    if (kDebugMode) {
      debugPrint('Foreground message received: ${message.messageId}');
    }

    // Check if this is a help_request or scam_detection
    final isHelpRequest = message.data['type'] == 'help_request' || message.data['type'] == 'scam_detection';

    if (isHelpRequest) {
      // For help request, immediately trigger the full screen intent
      debugPrint('Emergency notification received - showing full screen notification');
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

  /// Handle help request notification when app is in foreground
  /// This will be called automatically for full-screen intent notifications
  void handleHelpRequestInForeground(Map<String, dynamic> data) {
    debugPrint('Handling help request in foreground: $data');
    _dispatchNotificationTap(data);
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

  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Message data: ${message.data}');

  // Check if this is an emergency notification (help_request or scam_detection)
  final notificationType = message.data['type'];
  final isEmergency = notificationType == 'help_request' || notificationType == 'scam_detection';

  if (isEmergency) {
    debugPrint('Emergency notification in background - type: $notificationType');

    // Show full-screen intent notification even in background
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title != null || body != null) {
      final payload = message.data.isNotEmpty ? jsonEncode(message.data) : null;

      // Create full-screen intent notification for emergency
      final androidDetails = AndroidNotificationDetails(
        _helpRequestChannel.id,
        _helpRequestChannel.name,
        channelDescription: _helpRequestChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        icon: '@mipmap/launcher_icon',
        channelShowBadge: true,
        fullScreenIntent: true, // Full-screen intent for emergency
        category: AndroidNotificationCategory.call,
        visibility: NotificationVisibility.public,
        ongoing: true,
        autoCancel: false,
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
      );

      await _flutterLocalNotificationsPlugin.show(
        message.hashCode,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: darwinDetails),
        payload: payload,
      );

      debugPrint('Emergency notification shown in background');
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  NotificationService.instance.handleNotificationResponsePayload(response.payload);
}
