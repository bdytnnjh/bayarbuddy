import 'package:app/core/configs/firebase_options.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/themes/base_theme.dart';
import 'package:app/presentation/screens/boarding/boarding_screen.dart';
import 'package:app/presentation/screens/login/login_screen.dart';
import 'package:app/presentation/screens/main/transfer/providers/tranfer_provider.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService.instance.initialize(
    onNotificationTap: (data) =>
        debugPrint('Notification tapped with payload: $data'),
  );

  print('TOKEN DEVICE: ${await FirebaseMessaging.instance.getToken()}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        title: 'Bayar Buddy',
        initialRoute: '/',
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
        },
      ),
    );
  }
}
