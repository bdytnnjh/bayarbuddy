import 'package:flutter/material.dart';
import 'app_theme.dart';

ThemeData buildBaseTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppTheme.colors.bgLight,
    iconTheme: const IconThemeData(color: Colors.black),
    buttonTheme: const ButtonThemeData( alignedDropdown: true),
    typography: Typography.material2021(colorScheme: ColorScheme.light()),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppTheme.colors.primary,
      primary: AppTheme.colors.primary,
      secondary: AppTheme.colors.secondary,
      surface: Colors.white,
      onSurface: Colors.black87,
      onPrimary: Colors.white,
    ),
    
      appBarTheme: AppBarTheme(
        toolbarHeight: 70,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontFamily: AppTheme.typography.primary, color: AppTheme.colors.textPrimary),
        iconTheme: const IconThemeData(color: Colors.black, grade: 2),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.black,
          textColor: Colors.black,
          tileColor: AppTheme.colors.white,
          selectedColor: AppTheme.colors.primary,
          selectedTileColor: AppTheme.colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppTheme.colors.primary,
          foregroundColor: Colors.white,
        ),
        switchTheme: SwitchThemeData(
          trackOutlineWidth: const WidgetStatePropertyAll(.8),
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.colors.primary;
            }
            return AppTheme.colors.grey;
          }),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.colors.grey;
            }
            return Colors.grey;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.colors.grey.withValues(alpha: 0.3);
            }
            return AppTheme.colors.grey.withValues(alpha: 0.3);
          }),
          thumbIcon: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Icon(Icons.check, size: 8, color: AppTheme.colors.primary);
            }
            return Icon(Icons.close, size: 8, color: AppTheme.colors.grey);
          }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const UnderlineInputBorder(),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.colors.primary)),
      labelStyle: TextStyle(fontFamily: AppTheme.typography.primary, color: Colors.black54),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      suffixIconColor: Colors.black54,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
    )
  );
}