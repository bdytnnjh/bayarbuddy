import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

enum ButtonType { primary, secondary, gradient, disable }

class ButtonWidget {
  static Widget rectangle({
    required BuildContext context,
    required String text,
    required ButtonType type,
    Color? textColor,
    Color? iconColor,
    Color? backgroundColor,
    double? width,
    double? height = 50,
    IconData? leftIcon,
    IconData? rightIcon,
    double? fontSize,
    Function()? onPressed,
    MainAxisAlignment? alignment,
  }) {
    Decoration? decoration;
    Color buttonColor;
    Color overlayColor;

    if (type == ButtonType.primary) {
      buttonColor = backgroundColor ?? AppTheme.colors.primary;
      overlayColor = AppTheme.colors.overlay;
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(50));
    } else if (type == ButtonType.gradient) {
      buttonColor = Colors.transparent;
      overlayColor = AppTheme.colors.overlay;
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: AppTheme.colors.gradientPrimary(context),
      );
    } else if (type == ButtonType.secondary) {
      textColor = textColor ?? AppTheme.colors.primary;
      iconColor = iconColor ?? AppTheme.colors.primary;
      buttonColor = backgroundColor ?? Colors.white;
      overlayColor = Colors.black12;
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 1.5, color: AppTheme.colors.primary),
      );
    } else {
      buttonColor = backgroundColor ?? Colors.grey[400]!;
      overlayColor = Colors.grey[700]!;
      decoration = BoxDecoration(borderRadius: BorderRadius.circular(50));
    }

    assert(type == ButtonType.disable ? onPressed == null : true);
    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return overlayColor;
          }
          return null;
        }),
        onTap: onPressed,
        child: IntrinsicWidth(
          child: Container(
            width: width,
            height: height,
            decoration: decoration,
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Row(
              mainAxisAlignment: alignment ?? MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (leftIcon != null) {
                      return Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          leftIcon,
                          size: 25,
                          color: iconColor ?? Colors.white,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize ?? 18,
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (rightIcon != null) {
                      return Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          rightIcon,
                          size: 25,
                          color: iconColor ?? Colors.white,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget circle({
    required BuildContext context,
    required ButtonType type,
    required Widget child,
    Function()? onPressed,
    Color? backgroundColor,
    Color? borderColor,
    double size = 60,
    double borderWidth = 2,
  }) {
    Color buttonColor;
    Color overlayColor;
    Color finalBorderColor;

    if (type == ButtonType.primary) {
      buttonColor = backgroundColor ?? AppTheme.colors.primary;
      overlayColor = AppTheme.colors.overlay;
      finalBorderColor = borderColor ?? AppTheme.colors.primary;
    } else if (type == ButtonType.gradient) {
      buttonColor = backgroundColor ?? Colors.transparent;
      overlayColor = AppTheme.colors.overlay;
      finalBorderColor = borderColor ?? Colors.transparent;
    } else if (type == ButtonType.secondary) {
      buttonColor = backgroundColor ?? Colors.white;
      overlayColor = AppTheme.colors.primary.withValues(alpha: 0.8);
      finalBorderColor = borderColor ?? Colors.grey[400]!;
    } else {
      buttonColor = backgroundColor ?? Colors.transparent;
      overlayColor = Colors.grey[700]!;
      finalBorderColor = borderColor ?? Colors.grey[400]!;
    }

    assert(type == ButtonType.disable ? onPressed == null : true);
    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return overlayColor;
          }
          return null;
        }),
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: finalBorderColor, width: borderWidth),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
