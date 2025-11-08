import 'package:app/core/configs/firebase_options.dart';
import 'package:app/presentation/screens/boarding/boarding_screen.dart';
import 'package:app/presentation/screens/home/home_screen.dart';
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
      title: "Bayar Buddy",
      initialRoute: '/',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.pink,
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color(0xFFFF1F70),
          primary: Color(0xFFFF1F70),
          secondary: Color(0xFF5664BB),
          surface: Colors.white,
          onSurface: Colors.black87,
          onPrimary: Colors.white,
        ),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/boarding': (context) => BoardingScreen(),
      },
    );
  }
}
