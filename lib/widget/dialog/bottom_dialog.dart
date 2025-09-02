import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/color_standard.dart';
import '../button/opacity_button.dart';

class ShowBottomContentDialog {
  ShowBottomContentDialog({required Widget child}) {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      backgroundColor: ColorStandard.back,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: child,
        );
      },
    );
  }
}

class ShowBottomDialog {
  ShowBottomDialog({
    required List<BottomDialogWidget> actions,
    String? title,
    VoidCallback? cancel,
  }) {
    Widget _title = const SizedBox();

    if (title != null) {
      _title = Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize:16.sp,color: ColorStandard.fontGrey2),
        ),
      );
    }

    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: ColorStandard.back,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title,
          Container(
            constraints: BoxConstraints(
              maxHeight: 300,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...actions.map((e) => Column(
                    children: [
                      e,
                      if (actions.indexOf(e) != actions.length - 1)
                         Divider(
                          height: 0.6,
                          thickness: 0.6,
                          color:  ColorStandard.divColor,
                        ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          Container(
            height: 10,
            color: ColorStandard.back2,
          ),
          BottomDialogWidget(
            title: '取消',
            color: ColorStandard.blue,
            onTap: () {
              cancel?.call();
            },
          ),
        ],
      ),
    );
  }
}

class BottomDialogWidget extends StatelessWidget {
  final String title;
  final String? remind;
  final VoidCallback onTap;
  final Widget? icon;
  final Color? color;

  const BottomDialogWidget({
    required this.title,
    required this.onTap,
    this.remind,
    this.icon,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 66,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        color: ColorStandard.back,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                Text(
                  title,
                  style: TextStyle(fontSize: 16.sp,
                      color: color ?? ColorStandard.fontBlack),
                )
              ],
            ),
            if (remind != null)
              Column(
                children: [
                  SizedBox(height: 6),
                  Text(
                    remind!,
                    style: TextStyle(fontSize:14.sp,color: ColorStandard.fontGrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
