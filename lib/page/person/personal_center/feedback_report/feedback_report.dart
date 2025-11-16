import 'dart:io';
import 'package:comment1/page/person/personal_center/feedback_report/feedback_report_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FeedbackReport extends StatelessWidget {
  const FeedbackReport({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FeedbackReportCtrl(),
      builder: (FeedbackReportCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: Text(
            "举报与意见反馈",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                // 反馈类型选择
                _buildTypeSelector(context, ctrl),
                SizedBox(height: 20.h),
                // 问题描述
                _buildContentInput(context, ctrl),
                SizedBox(height: 20.h),
                // 图片上传
                _buildImageUpload(context, ctrl),
                SizedBox(height: 20.h),
                // 联系方式（选填）
                _buildContactInput(context, ctrl),
                SizedBox(height: 30.h),
                // 提交按钮
                _buildSubmitButton(context, ctrl),
                SizedBox(height: 20.h),
                // // 提示信息
                // _buildTips(context, ctrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 反馈类型选择器
  Widget _buildTypeSelector(BuildContext context, FeedbackReportCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "反馈类型",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => ctrl.setFeedbackType(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: ctrl.feedbackType == 0
                        ? Colors.deepPurple.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: ctrl.feedbackType == 0
                          ? Colors.deepPurple
                          : Colors.grey.withOpacity(0.3),
                      width: ctrl.feedbackType == 0 ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.feedback_outlined,
                        color: ctrl.feedbackType == 0
                            ? Colors.deepPurple
                            : Colors.grey,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "意见反馈",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: ctrl.feedbackType == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: ctrl.feedbackType == 0
                              ? Colors.deepPurple
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => ctrl.setFeedbackType(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: ctrl.feedbackType == 1
                        ? Colors.red.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: ctrl.feedbackType == 1
                          ? Colors.red
                          : Colors.grey.withOpacity(0.3),
                      width: ctrl.feedbackType == 1 ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.report_problem_outlined,
                        color: ctrl.feedbackType == 1 ? Colors.red : Colors.grey,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "举报",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: ctrl.feedbackType == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: ctrl.feedbackType == 1 ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 内容输入框
  Widget _buildContentInput(BuildContext context, FeedbackReportCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              ctrl.feedbackType == 0 ? "反馈内容" : "举报内容",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              " *",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: ctrl.contentController,
            maxLines: 8,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: ctrl.feedbackType == 0
                  ? "请详细描述您的问题或建议（至少10个字符）..."
                  : "请详细描述您要举报的内容（至少10个字符）...",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12.w),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        // Text(
        //   "${ctrl.contentController.text.length}/1000",
        //   style: TextStyle(
        //     fontSize: 12.sp,
        //     color: Colors.grey,
        //   ),
        // ),
      ],
    );
  }

  // 图片上传
  Widget _buildImageUpload(BuildContext context, FeedbackReportCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "上传图片（可选，最多5张）",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            // 显示已选图片
            ...ctrl.selectedImages.asMap().entries.map((entry) {
              int index = entry.key;
              String imagePath = entry.value;
              return Stack(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: GestureDetector(
                      onTap: () => ctrl.removeImage(index),
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            // 添加图片按钮
            if (ctrl.selectedImages.length < 5)
              GestureDetector(
                onTap: ctrl.selectImages,
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.grey,
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "添加",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // 联系方式输入
  Widget _buildContactInput(BuildContext context, FeedbackReportCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "联系方式（选填）",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        // SizedBox(height: 8.h),
        // Text(
        //   "便于我们与您联系，及时反馈处理结果",
        //   style: TextStyle(
        //     fontSize: 12.sp,
        //     color: Colors.grey,
        //   ),
        // ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: ctrl.contactController,
            keyboardType: TextInputType.emailAddress,

            decoration: InputDecoration(
              hintText: "请输入您的邮箱或手机号",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // 提交按钮
  Widget _buildSubmitButton(BuildContext context, FeedbackReportCtrl ctrl) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: ctrl.isSubmitting ? null : ctrl.submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: ctrl.isSubmitting
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                "提交反馈",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // 提示信息
  Widget _buildTips(BuildContext context, FeedbackReportCtrl ctrl) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "温馨提示",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "• 我们会在收到反馈后及时处理，通常在1-3个工作日内给予回复\n"
            "• 请如实填写反馈内容，恶意举报将被封号处理\n"
            "• 如需紧急处理，请通过客服邮箱联系我们：13356797958@163.com",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

