import 'package:app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AppBarGlobal extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarGlobal({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: AppTheme.colors.primary, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get PreferredSize => Size.fromHeight(kToolbarHeight);
}