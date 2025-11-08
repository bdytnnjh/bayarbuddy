import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushNamed(context, '/boarding');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/imgs/app_logo_only_blue.png', width: 150),
                Text(
                  "BayarBuddy",
                  style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Color(0xFFFF1F70)),
                ),
                Text("Your Best Money Transfer Partner.", style: TextStyle(fontSize: 13, color: Color(0xFF5063BF))),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Secured by",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF878787)),
                  ),
                  Text(
                    "TransferMe.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF5063BF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
