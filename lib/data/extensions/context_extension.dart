import 'package:filemanager/data/constants.dart';
import 'package:flutter/material.dart';

import '../enums.dart';

extension ContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  LayoutType get layoutType {
    if (width <= mobileMaxWidth) {
      return LayoutType.mobile;
    } else if (width <= tabletMaxWidth) {
      return LayoutType.tablet;
    } else {
      return LayoutType.desktop;
    }
  }
}
