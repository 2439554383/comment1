import 'dart:io';
import 'package:comment1/common/app_component.dart';
import 'package:comment1/common/loading.dart';
import 'package:comment1/network/apis.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:comment1/util/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackReportCtrl extends GetxController {
  late TextEditingController contentController;
  late TextEditingController contactController;
  
  int feedbackType = 0; // 0: 意见反馈, 1: 举报
  List<String> selectedImages = [];
  bool isSubmitting = false;

  @override
  void onInit() {
    super.onInit();
    contentController = TextEditingController();
    contactController = TextEditingController();
    // 监听内容变化，更新字符计数
    contentController.addListener(() {
      update();
    });
  }

  @override
  void dispose() {
    contentController.dispose();
    contactController.dispose();
    super.dispose();
  }

  // 切换反馈类型
  void setFeedbackType(int type) {
    feedbackType = type;
    update();
  }

  // 选择图片
  Future<void> selectImages() async {
    final int remainingSlots = 5 - selectedImages.length;
    if (remainingSlots <= 0) {
      showToast("最多只能上传5张图片");
      return;
    }
    
    final List<String>? images = await ImageUtils.selectImage(remainingSlots, Get.context!);
    if (images != null && images.isNotEmpty) {
      selectedImages.addAll(images);
      if (selectedImages.length > 5) {
        selectedImages = selectedImages.sublist(0, 5);
        showToast("最多只能上传5张图片");
      }
      update();
    }
  }

  // 删除图片
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      update();
    }
  }

  // 验证表单
  bool validateForm() {
    if (contentController.text.trim().isEmpty) {
      showToast("请填写问题描述或反馈内容");
      return false;
    }
    if (contentController.text.trim().length < 10) {
      showToast("问题描述至少需要10个字符");
      return false;
    }
    if (contentController.text.trim().length > 1000) {
      showToast("问题描述不能超过1000个字符");
      return false;
    }
    return true;
  }

  // 提交反馈
  Future<void> submitFeedback() async {
    if (!validateForm()) {
      return;
    }

    if (isSubmitting) {
      return;
    }

    isSubmitting = true;
    Loading.show();
    update();

    try {
      final Map<String, dynamic> data = {
        "type": feedbackType, // 0: 意见反馈, 1: 举报
        "content": contentController.text.trim(),
        "contact": contactController.text.trim(),
        "images": selectedImages, // 图片路径数组
      };

      final result = await HttpUtil().post(
        Api.feedbackReport,
        data: data,
      );

      Loading.dismiss();
      isSubmitting = false;
      update();

      if (result.isSuccess) {
        showToast("提交成功，我们会尽快处理您的反馈");
        // 清空表单
        contentController.clear();
        contactController.clear();
        selectedImages.clear();
        feedbackType = 0;
        update();
        // 延迟返回上一页
        Future.delayed(Duration(milliseconds: 1500), () {
          Get.back();
        });
      } else {
        showToast(result.message ?? "提交失败，请稍后重试");
      }
    } catch (e) {
      Loading.dismiss();
      isSubmitting = false;
      update();
      showToast("提交失败，请稍后重试");
    }
  }
}

