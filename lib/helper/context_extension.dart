import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width <= 480;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  double get widthOfScreen => MediaQuery.of(this).size.width;
}
