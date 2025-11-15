import 'package:app/core/configs/firebase_options.dart';
import 'package:app/core/themes/base_theme.dart';
import 'package:app/presentation/screens/boarding/boarding_screen.dart';
import 'package:app/presentation/screens/login/login_screen.dart';
import 'package:app/presentation/screens/main/wrapper_screen.dart';
import 'package:app/presentation/screens/register/register_screen.dart';
import 'package:app/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
