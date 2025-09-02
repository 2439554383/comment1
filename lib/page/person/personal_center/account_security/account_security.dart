import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'account_security_ctrl.dart';

class AccountSecurity extends StatelessWidget {
  const AccountSecurity({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder<AccountSecurityCtrl>(
      init: AccountSecurityCtrl(),
      builder: (ctrl) => Scaffold(
        appBar: AppBar(
          title: AutoSizeText("修改密码"),
        ),
        body: Form(
          key: ctrl.formKey,
          child: Column(
            children: [
              SizedBox(height: 30.h),
              // 密码输入框
              passwordInput(context, ctrl),
              SizedBox(height: 20.h),
              // 确认密码输入框
              confirmPasswordInput(context, ctrl),
              SizedBox(height: 30.h),
              // 确定按钮
              nextButton(context, ctrl),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // 密码输入框
  Widget passwordInput(BuildContext context, AccountSecurityCtrl ctrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: TextFormField(
        controller: ctrl.passwordController,
        obscureText: ctrl.obscurePassword.value,
        validator: ctrl.validatePassword,
        decoration: InputDecoration(
          labelText: '新密码',
          hintText: '请输入新密码（至少6位）',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          prefixIcon: Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              ctrl.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: ctrl.togglePasswordVisibility,
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  // 确认密码输入框
  Widget confirmPasswordInput(BuildContext context, AccountSecurityCtrl ctrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: TextFormField(
        controller: ctrl.confirmPasswordController,
        obscureText: ctrl.obscureConfirmPassword.value,
        validator: ctrl.validateConfirmPassword,
        decoration: InputDecoration(
          labelText: '确认密码',
          hintText: '请再次输入密码',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          prefixIcon: Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              ctrl.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: ctrl.toggleConfirmPasswordVisibility,
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  // 确定按钮
  Widget nextButton(BuildContext context, AccountSecurityCtrl ctrl) {
    return Container(
      width: 327.w,
      height: 44.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepOrange
              ]
          )
      ),
      child:TextButton(
          onPressed: ctrl.changePassword,
          child: Text(
              "确定修改",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(255, 255, 255, 1)
              )
          )
      ),
    );
  }
}