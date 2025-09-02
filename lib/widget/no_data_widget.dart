import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/app_component.dart';
import '../common/color_standard.dart';
import '../util/f_util.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;

  const NoDataWidget({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/nodata.png', width: 100.w,),
        SizedBox(height: 15.h,),
        if (FUtil.isNotEmptyString(title))
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Color(0xffEEEEEE)),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Text(
              title ?? "",
              style: TextStyle(fontSize: 14.sp, color: ColorStandard.textColor),
            ),
          )
      ],
    );
  }
}
