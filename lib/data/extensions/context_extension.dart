import 'package:filemanager/data/constants.dart';
import 'package:flutter/material.dart';

import '../enums.dart';

extension ContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isDesktopView => MediaQuery.of(this).size.width > mobileMaxWidth;

  LayoutType get layoutType {
    final width = MediaQuery.of(this).size.width;
    if (width <= mobileMaxWidth) {
      return LayoutType.mobile;
    } else if (width <= tabletMaxWidth) {
      return LayoutType.tablet;
    } else {
      return LayoutType.desktop;
    }
  }

  bool get isMobile => MediaQuery.of(this).size.width <= 480;
  double get widthOfScreen => MediaQuery.of(this).size.width;
}
