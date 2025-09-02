import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AgreementWidget extends StatelessWidget {
  const AgreementWidget({super.key, this.onAgreementTap, this.onPrivacyTap});

  final void Function()? onAgreementTap;
  final void Function()? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 8),
      child: SafeArea(
        child: Text.rich(TextSpan(children: [
          TextSpan(
              text: '注册或登录即代表已阅读并同意'.tr,
              style: TextStyle(color: Color(0xff343434 ), fontSize: 10.sp)),
          TextSpan(
              text: '服务协议'.tr,
              style: TextStyle(color: Colors.purple, fontSize: 10.sp),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onAgreementTap?.call();
                }),
          TextSpan(
              text: '和'.tr,
              style: TextStyle(color: Color(0xff343434 ), fontSize: 10.sp)),
          TextSpan(
              text: '隐私政策'.tr,
              style: TextStyle(color: Colors.purple, fontSize: 10.sp),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onPrivacyTap?.call();
                }),
        ]),
      ),
      ),
    );
  }
}
