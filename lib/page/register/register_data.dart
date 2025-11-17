import 'package:comment1/common/app_component.dart';
import 'package:comment1/mixin/color.dart';
import 'package:comment1/mixin/validate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'Register_ctrl.dart';

class RegisterData extends StatelessWidget with FormValidationMixin{
  const RegisterData({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RegisterCtrl(),
      builder: (RegisterCtrl ctrl) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("填写信息"),
          centerTitle: true,
        ),
        body: Form(
          key: ctrl.formKeyData,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: ListView(
              children: [
                inputField(
                  label: "用户名",
                  hint: "请输入您的用户名",
                  controller: ctrl.usernameCtrl,
                ),
                SizedBox(height: 15.h),
                selectItem(ctrl: ctrl, label: "行业", hint: "请选择行业", controller: ctrl.industryCtrl),
                SizedBox(height: 15.h),
                inputField(
                  label: "城市",
                  hint: "请输入您所在的城市",
                  controller: ctrl.cityCtrl,
                ),
                SizedBox(height: 15.h),
                unInputField(
                  label: "邀请人id",
                  hint: "请输入邀请人id",
                  controller: ctrl.inviteIdCtrl,
                ),
                SizedBox(height: 30.h),
                nextButton(context, ctrl)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 封装的输入框
  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,color: Colors.black)),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          validator: (value){
            return validateRequired(value, label);
          },
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            hintStyle: TextStyle(color: CustomColors.fontGrey),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          ),
        ),
      ],
    );
  }
  /// 封装的输入框
  Widget selectItem({
    required RegisterCtrl ctrl,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,color: Colors.black)),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: (){
            showPicker(ctrl.industoryList, (value){
              ctrl.selectIndustory(value.first);
            });
          },
          behavior: HitTestBehavior.opaque,
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: (value){
                return validateRequired(value, label);
              },
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                hintStyle: TextStyle(color: CustomColors.fontGrey),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                suffixIconConstraints: BoxConstraints(),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 15.w),
                  child: Icon(CupertinoIcons.chevron_compact_down,size:20.sp,color: Colors.grey),
                )
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget unInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,color: Colors.black)),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            hintStyle: TextStyle(color: CustomColors.fontGrey),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          ),
        ),
      ],
    );
  }
  nextButton(BuildContext context, RegisterCtrl ctrl){
    return Container(
      width: 327.w,
      margin: EdgeInsets.only(left: 24.w,right: 24.h),
      height: 44.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepOrange
              ])
      ),
      child: TextButton(
          onPressed: (){
            if(ctrl.formKeyData.currentState!.validate()){
              ctrl.register();
            }
          },
          child: Text("确定",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1))
          )
      ),
    );
  }
}
