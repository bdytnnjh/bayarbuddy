import 'package:app/presentation/shared/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay eksekusi sampai setelah frame pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSplash();
    });
  }

  Future<void> _initializeSplash() async {
    // Dapatkan instance AppProvider tanpa mendengarkan perubahan
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    // Panggil inisialisasi aplikasi
    await appProvider.initializeApp();

    // Simulasikan waktu loading selama 3 detik
    await Future.delayed(const Duration(seconds: 3));

    // Dapatkan rute awal berdasarkan status
    if (mounted) {
      final route = await appProvider.getInitialRoute();
      if (mounted) {
        Navigator.pushReplacementNamed(context, route);
      }
    }
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
                ),
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
          ),
        ],
      ),
    );
  }
}
