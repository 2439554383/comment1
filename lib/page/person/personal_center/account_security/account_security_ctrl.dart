import 'package:comment1/common/app_component.dart';
import 'package:comment1/common/loading.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../network/apis.dart';

class AccountSecurityCtrl extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureCurrentPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // 切换密码可见性
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
    update();
  }

  // 切换确认密码可见性
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
    update();
  }

  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.value = !obscureCurrentPassword.value;
    update();
  }

// 密码验证 - 必须包含字母和数字
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度至少6位';
    }

    // 检查是否包含字母
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);
    // 检查是否包含数字
    final hasDigits = RegExp(r'[0-9]').hasMatch(value);

    if (!hasLetters) {
      return '密码必须包含字母';
    }
    if (!hasDigits) {
      return '密码必须包含数字';
    }

    return null;
  }

// 确认密码验证
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != passwordController.text) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  // 修改密码
  void changePassword() async {
    Loading.show();
    if (formKey.currentState!.validate()) {
      isLoading.value = false;
      final data = {
        "current_password": currentPasswordController.text,   // 必填 - 当前密码，用于验证身份
        "new_password": passwordController.text,       // 必填 - 新密码，6-20位字符
        "confirm_password": confirmPasswordController.text   // 必填 - 确认新密码，必须与new_password一致
      };
      final response = await HttpUtil().put(Api.putPassword,data: data);
      if (response.isSuccess) {
        Get.back();
        showToast("修改成功");
      } else {
        showToast("${response.error?.message??"修改失败"}");
      }
    }
    Loading.dismiss();
  }
}