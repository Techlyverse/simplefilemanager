import 'package:flutter/cupertino.dart';

bool isMobileView(BuildContext context) {
  return MediaQuery.of(context).size.width <= 480;
}