import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  Loading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 35.0
      ..lineWidth = 2
      ..radius = 13.5
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.6)
      ..userInteractions = true
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.custom;
  }

  static void reset() {
    EasyLoading.instance
      ..textColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      );
  }

  static void show([String? text]) {
    reset();
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: text, maskType: EasyLoadingMaskType.clear);
  }

  static Future<void> toast(
    String? text, {
    EasyLoadingToastPosition position = EasyLoadingToastPosition.bottom,
  }) async {
    reset();
    if (text == null) return;
    await EasyLoading.showToast(
      text,
      maskType: EasyLoadingMaskType.clear,
      toastPosition: position,
    );
  }

  static Future<void> success(String? text) async {
    if (text == null) return;
    reset();
    await EasyLoading.showSuccess(text);
  }

  static Future<void> error(String? text) async {
    if (text == null) return;
    reset();
    await EasyLoading.showError(text);
  }

  static void dismiss() {
    EasyLoading.instance.userInteractions = true;
    EasyLoading.dismiss();
  }

  static void customToast(
    String? text, {
    EasyLoadingToastPosition position = EasyLoadingToastPosition.top,
    Color? textColor = Colors.black,
    Color? backgroundColor = Colors.white,
  }) async {
    if (text == null) return;

    EasyLoading.instance
      ..textColor = textColor ?? Colors.white
      ..backgroundColor = backgroundColor ?? Colors.black.withOpacity(0.7)
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 30.0,
      );
    await EasyLoading.showToast(
      text,
      toastPosition: position,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static void showW([String? text]) {
    EasyLoading.instance
      ..textColor = const Color(0xFF585858)
      ..backgroundColor = Colors.white
      ..indicatorColor = const Color(0xFFA3A3A3)
      ..contentPadding = const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      );
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(status: text, maskType: EasyLoadingMaskType.clear);
  }
}
