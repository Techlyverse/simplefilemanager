import 'package:filemanager/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/enums.dart';

extension ContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  bool get isDesktopView => MediaQuery.sizeOf(this).width > mobileMaxWidth;

  ViewType get viewType {
    final width = MediaQuery.sizeOf(this).width;
    if (width <= mobileMaxWidth) {
      return ViewType.mobile;
    } else if (width <= tabletMaxWidth) {
      return ViewType.tablet;
    } else {
      return ViewType.desktop;
    }
  }
  bool get isMobile => MediaQuery.of(this).size.width <= 480;
  double get widthOfScreen => MediaQuery.of(this).size.width;
}
