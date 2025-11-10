import 'package:flutter/material.dart';

class ColorsTheme {
  const ColorsTheme();

  // Theme
  Color get primary => const Color(0xFFFF1F70);
  Color get secondary => const Color(0xFF5664BB);
  Color get overlay => const Color(0xFFC40047);

  Color get white => const Color(0xFFFEFEFE);
  Color get grey => const Color(0xFFACACAC);
  Color get red => const Color(0xFFEF476F);
  Color get green => const Color(0xFF06D6A0);
  Color get yellow => const Color(0xFFFFD166);

  Color get bgPink => const Color(0xFFFFC0CB);
  Color get bgLight => const Color(0xFFFFFFFF);

  Color get divider => const Color(0xFFBDBDBD);

  Color get textPrimary => const Color(0xFF222834);
  Color get textSecondary => const Color(0xFF353F54);

  LinearGradient gradientPrimary(BuildContext context) {
    return LinearGradient(
      stops: const [0.0, 1.0],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1, 0.0),
      colors: [primary, secondary],
      tileMode: TileMode.clamp,
    );
  }

  LinearGradient gradientBgScreen(BuildContext context) {
    return LinearGradient(
      colors: [primary.withValues(alpha: 0.45), bgLight],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const[0, 0.6],
    );
  }
}