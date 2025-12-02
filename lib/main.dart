import 'package:app/core/configs/firebase_options.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/themes/base_theme.dart';
import 'package:app/presentation/screens/boarding/boarding_screen.dart';
import 'package:app/presentation/screens/login/login_screen.dart';
import 'package:app/presentation/screens/main/transfer/notification_full_intent_screen.dart';
import 'package:app/presentation/screens/main/transfer/providers/transfer_provider.dart';
import 'package:app/presentation/screens/main/wrapper_screen.dart';
import 'package:app/presentation/screens/register/providers/register_providers.dart';
import 'package:app/presentation/screens/register/register_screen.dart';
import 'package:app/presentation/screens/set_pin/set_pin_screen.dart';
import 'package:app/presentation/screens/set_pin/verify_pin_screen.dart';
import 'package:app/presentation/screens/splash/splash_screen.dart';
import 'package:app/presentation/shared/providers/app_provider.dart';
import 'package:app/presentation/shared/providers/transfer_history_provider.dart';
import 'package:app/presentation/shared/providers/user_profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Global navigator key untuk navigation dari notification handler
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Store initial notification globally
RemoteMessage? _initialNotificationMessage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Check for initial notification before app starts
  _initialNotificationMessage = await FirebaseMessaging.instance.getInitialMessage();

  await NotificationService.instance.initialize(onNotificationTap: _handleNotificationTap);

  runApp(const MyApp());
}

/// Handle notification tap - Navigate to appropriate screen
void _handleNotificationTap(Map<String, dynamic> data) {
  debugPrint('Notification tapped with payload: $data');

  // Check notification type
  final type = data['type'] as String?;

  if (type == 'help_request' || type == 'scam_detection') {
    // Navigate to NotificationFullIntentScreen
    _navigateToHelpRequestScreen(data);
  } else {
    debugPrint('Unknown notification type: $type');
  }
}

/// Navigate to NotificationFullIntentScreen for help requests
void _navigateToHelpRequestScreen(Map<String, dynamic> data) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator context is null, cannot navigate');
    return;
  }

  // Parse data
  final amount = data['amount'] as String?;
  final recipientName = data['recipientName'] as String?;
  final recipientPhone = data['recipientPhone'] as String?;
  final senderName = data['senderName'] as String?;
  final senderUid = data['senderUid'] as String?;
  final timestampStr = data['timestamp'] as String?;
  final timestamp = timestampStr != null ? DateTime.tryParse(timestampStr) : null;

  // Navigate to full intent screen
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => NotificationFullIntentScreen(
        amount: amount,
        recipientName: recipientName,
        recipientPhone: recipientPhone,
        senderName: senderName,
        senderUid: senderUid,
        timestamp: timestamp,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String _getInitialRoute() {
    // Check if app was opened from notification
    if (_initialNotificationMessage != null) {
      final notificationType = _initialNotificationMessage!.data['type'] as String?;
      if (notificationType == 'help_request' || notificationType == 'scam_detection') {
        debugPrint('App opened from emergency notification - routing to /notification');
        return '/notification';
      }
    }
    // Default route
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => TransferProvider()),
        ChangeNotifierProvider(create: (_) => TransferHistoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // ✅ Add navigator key
        title: 'Bayar Buddy',
        initialRoute: _getInitialRoute(),
        theme: buildBaseTheme(),
        // Static route definitions
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => WrapperScreen(),
          '/boarding': (context) => BoardingScreen(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterScreen(),
          '/set-pin': (context) => SetPinScreen(),
          '/verify-pin': (context) => VerifyPinScreen(),
          '/notification': (context) {
            // Parse notification data and pass to screen
            if (_initialNotificationMessage != null) {
              final data = _initialNotificationMessage!.data;
              final amount = data['amount'] as String?;
              final recipientName = data['recipientName'] as String?;
              final recipientPhone = data['recipientPhone'] as String?;
              final senderName = data['senderName'] as String?;
              final senderUid = data['senderUid'] as String?;
              final timestampStr = data['timestamp'] as String?;
              final timestamp = timestampStr != null ? DateTime.tryParse(timestampStr) : null;

              return NotificationFullIntentScreen(
                amount: amount,
                recipientName: recipientName,
                recipientPhone: recipientPhone,
                senderName: senderName,
                senderUid: senderUid,
                timestamp: timestamp,
              );
            }
            // Fallback if no notification data
            return const NotificationFullIntentScreen();
          },
        },
      ),
    );
  }
}
