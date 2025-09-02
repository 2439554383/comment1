import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../common/color_standard.dart';

class ShowBottomDialogContent {
  final Widget child;

  ShowBottomDialogContent({required this.child}) {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      barrierColor: ColorStandard.fontBlack.withOpacity(0.3),
      elevation: 3,
      builder: (_) {
        return _Box(child: child);
      },
    );
  }
}

class _Box extends StatelessWidget {
  final Widget child;

  const _Box({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(Get.context!).padding.bottom + 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(Get.context!).size.height * 4 / 5,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorStandard.back,
      ),
      child: child,
    );
  }
}
