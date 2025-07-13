import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width <= 480;
}
