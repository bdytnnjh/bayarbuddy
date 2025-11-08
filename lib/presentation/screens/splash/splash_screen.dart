import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), (){
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/imgs/app_logo_only_blue.png', width: 150),
                Text(
                  'Bayar Buddy',
                  style: TextStyle(
                    fontFamily: 'Amaranth',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF1F70),
                  ),
                ),
                Text(
                  'Your Best Money Transfer Partner.',
                  style: TextStyle(
                    fontFamily: 'Amaranth',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5063BF),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            child: Row(
              children: [
                Text("Secured by ", style: TextStyle(fontFamily: 'Poppins')),
                Text(
                  "TransfeMe.",
                  style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF5063BF)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}