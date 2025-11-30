import 'package:flutter/cupertino.dart';

class PopupMenuModel {
  const PopupMenuModel({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}
