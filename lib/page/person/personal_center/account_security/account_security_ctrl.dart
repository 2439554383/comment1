import 'package:comment1/common/app_component.dart';
import 'package:comment1/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSecurityCtrl extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
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
      // 模拟API调用
      await Future.delayed(Duration(seconds: 2), () {
        isLoading.value = false;

        // 这里应该是实际的API调用
        // bool success = await UserApi.changePassword(passwordController.text);

        // 模拟成功
        bool success = true;

        if (success) {
          Get.back();
          showToast("密码修改成功");
        } else {
          Get.snackbar(
            '失败',
            '密码修改失败，请重试',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      });
      Loading.dismiss();
    }
  }
}