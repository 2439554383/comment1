import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ShowCenterDialog {
  ShowCenterDialog({
    String? title,
    String? content,
    String? cancelText,
    String? confirmText,
    VoidCallback? confirm,
    VoidCallback? cancel,
  }) : assert(title != null || content != null) {
    Widget? titleWidget;
    Widget? contentWidget;

    if (title != null) {
      titleWidget = Text(
        title,
        style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),
      );
    }

    if (content != null) {
      contentWidget = Text(
        content,
        style: TextStyle(fontSize: 14),
      );
    }

    showCupertinoDialog(
      context: Get.context!,
      builder: (_) => CupertinoAlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: [
          _button(
            onTap: () {
              Get.back();
              cancel?.call();
            },
            child: Text(
              cancelText ?? '取消',
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (confirm != null)
            _button(
              onTap: () {
                Get.back();
                confirm();
              },
              child: Text(
                confirmText ?? '确定',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _button({required Widget child, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 44,
          ),
          child: Semantics(
            button: true,
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
                child: child,
              ),
            ),
          ),
        ),
      );
}

