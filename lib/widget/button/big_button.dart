
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/color_standard.dart';
import 'opacity_button.dart';

class BigButton extends StatelessWidget {
  final Color? backColor;
  final Color? borderColor;
  final String title;
  final VoidCallback onTap;
  final Color? fontColor;
  final double? borderRadius;
  final double? width;
  final double? height;
  final TextStyle? titleTS;
  const BigButton(
      {
      required this.title,
      required this.onTap,
      this.borderColor,
        this.backColor,
        this.fontColor,
        this.borderRadius,
        this.width,
        this.height,
        this.titleTS,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      onTap: onTap,
      child: Container(
        width: width ?? 303,
        height: height ?? 44.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??100),
          color: backColor ?? ColorStandard.minor,
          border: Border.all(color: borderColor ?? backColor ?? ColorStandard.minor, width: 0.5),
        ),
        child: Text(
          title,
          style: titleTS ?? TextStyle(color: fontColor ?? Colors.white),
        ),
      ),
    );
  }
}


class FTextButton extends StatelessWidget {
  final Color? backColor;
  final Color? borderColor;
  final String title;
  final VoidCallback onTap;
  final Color? fontColor;
  final double? borderRadius;
  final double? width;
  const FTextButton(
      {
        required this.title,
        required this.onTap,
        this.borderColor,
        this.backColor,
        this.fontColor,
        this.borderRadius,
        this.width,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      onTap: onTap,
      child: Container(
        width: width??40,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??5),
          color: backColor ?? Colors.white ,
        ),
        child: Text(
          title,
          style: TextStyle(fontSize:12.sp,color: fontColor ?? ColorStandard.main),
        ),
      ),
    );
  }
}