import 'dart:ui';

import 'package:flutter/material.dart';

mixin CustomColors {
  static const Color fontGrey = Color.fromRGBO(153, 153, 153, 1);
  static const Color bgGrey = Color.fromRGBO(203, 203, 203, 1);
  static const Color deepOrange = Colors.deepOrange;
  static const Color range = Colors.orange;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color largeblue = Color.fromRGBO(
      0, 33, 64, 1.0);
  static Color getMainColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }
}