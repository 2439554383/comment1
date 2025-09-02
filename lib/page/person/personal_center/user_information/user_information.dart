import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/page/person/personal_center/user_information/user_information_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder<UserInformationCtrl>(
      init: UserInformationCtrl(),
      builder: (ctrl) => Scaffold(
        appBar: AppBar(
          title: AutoSizeText("用户信息"),
        ),
        body: Column(
          children: [
            SizedBox(height: 15.h),
            // 遍历所有用户信息项
            for (int i = 0; i < ctrl.userInfoItems.length; i++)
              Column(
                children: [
                  item1(context, ctrl, i),
                  if (i < ctrl.userInfoItems.length - 1)
                    SizedBox(height: 15.h),
                ],
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget item1(BuildContext context, UserInformationCtrl ctrl, int index) {
    Map item = ctrl.userInfoItems[index];
    bool isEditable = item["editable"]!;

    return GestureDetector(
      onTap: isEditable ? () => ctrl.showEditDialog(index, context) : null,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item["title"]!,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  ctrl.getFieldValue(item["value"]!),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                if (isEditable)
                  SizedBox(width: 8.w),
                if (isEditable)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.r,
                    color: Colors.grey,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}