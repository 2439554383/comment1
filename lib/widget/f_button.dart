import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final double? h;
  final double? w;
  final bool enabled;
  final double radius;
  final List<Color>? gradient;
  final double fontSize;
  const FButton({super.key, required this.title, required this.onTap, this.h, this.w,this.enabled = true,this.radius = 15,this.gradient,this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: enabled ? LinearGradient(
            colors: gradient ?? [
              Color(0xff5DD1FF),
              Color(0xff304FFF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ) : null,
          color: enabled ? null : Color(0xffDFE4FF)
        ),
        height: h ?? 44.h,
        width: w ?? MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Text(title,style: TextStyle(fontSize: fontSize.sp,color: Colors.white,fontWeight: FontWeight.w500)),
      ),
    );
  }
}
