import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/mixin/color.dart';
import 'package:comment1/page/person/personal_center/user_account/user_account_ctrl.dart';
import 'package:comment1/page/person/personal_center/user_information/user_information_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserAccount extends StatelessWidget {
  const UserAccount({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder<UserAccountCtrl>(
      init: UserAccountCtrl(),
      builder: (ctrl) => Scaffold(
        appBar: AppBar(
          title: AutoSizeText("账户信息"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5.h,),
              // 余额信息
              _buildSection("余额信息", ctrl.balanceInfoItems, ctrl.getBalanceFieldValue, context, ctrl),
              SizedBox(height: 20.h),

              // 积分信息
              _buildSection("积分信息", ctrl.pointsInfoItems, ctrl.getPointsFieldValue, context, ctrl),
              SizedBox(height: 20.h),

              // 评论信息
              _buildSection("评论信息", ctrl.commentInfoItems, ctrl.getCommentFieldValue, context, ctrl),
              SizedBox(height: 20.h),

              // 邀请信息
              _buildSection("邀请信息", ctrl.inviteInfoItems, ctrl.getInviteFieldValue, context, ctrl),
              SizedBox(height: 20.h),

              // 系统信息
              _buildSection("系统信息", ctrl.systemInfoItems, ctrl.getSystemFieldValue, context, ctrl),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // 构建信息区块
  Widget _buildSection(String title, List<Map<String, dynamic>> items,
      Function(String) getValue, BuildContext context, UserAccountCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 5.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900]
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++)
                Column(
                  children: [
                    _buildInfoItem(items[i], getValue, context, ctrl),
                    if (i < items.length - 1)
                      Divider(height: 1, indent: 16.w),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // 构建信息项
  Widget _buildInfoItem(Map<String, dynamic> item, Function(String) getValue,
      BuildContext context, UserAccountCtrl ctrl) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(
            item["icon"],
            size: 24.r,
            color: Colors.orange,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              item["title"],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900]
              ),
            ),
          ),
          Text(
            getValue(item["value"]),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}