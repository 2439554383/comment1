import 'package:comment1/mixin/color.dart';
import 'package:comment1/mixin/validate.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'Register_ctrl.dart';

class Register extends StatelessWidget with FormValidationMixin{
  const Register({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: RegisterCtrl(),
      autoRemove: true,
      builder: (RegisterCtrl ctrl) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: 15.w),
          title: Text("注册"),
          leading: SizedBox.shrink(),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: (){
                Froute.offAll(Froute.tabPage);
              },
              child: Icon(Icons.close),
            )
          ],
        ),
        body: Form(
          key: ctrl.formKeyRegister,
          child: Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h,),
                imageHeader(context, ctrl),
                SizedBox(height: 15.h,),
                textHeader1(context, ctrl),
                SizedBox(height: 15.h,),
                textHeader2(context, ctrl),
                SizedBox(height: 20.h,),
                inputName(context, ctrl),
                SizedBox(height: 20.h,),
                inputPassword(context, ctrl),
                SizedBox(height: 30.h,),
                nextButton(context, ctrl),
                SizedBox(height: 20.h,),
                textNotice(context, ctrl),
                SizedBox(height: 20.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget imageHeader(BuildContext context, RegisterCtrl ctrl){
    return Center(child: ClipRRect(child: Image.asset("assets/images/register.png",width: 150.w,height: 150.h,),borderRadius: BorderRadius.circular(30.r),));
  }

  Widget textHeader1(BuildContext context, RegisterCtrl ctrl) {
    return Text("您好，",style: TextStyle(fontSize: 20.sp,height: 1,fontWeight: FontWeight.w500,color: CustomColors.largeblue),);
  }
  Widget textHeader2(BuildContext context, RegisterCtrl ctrl) {
    return Text("欢迎来到Ai评论员!",style: TextStyle(fontSize: 22.sp,height: 1,fontWeight: FontWeight.w500,color: CustomColors.largeblue),);
  }
  inputName(BuildContext context, RegisterCtrl ctrl){
    return Container(
      width: double.infinity,
      height: 58.h,
      child: TextFormField(
        controller: ctrl.phone,
        validator: (value){
          return validatePhone(value);
        },
        decoration: InputDecoration(
          hintStyle:TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(119, 119, 119, 1)),
          hintText: "手机号",
        ),
      ),
    );
  }
  inputPassword(BuildContext context, RegisterCtrl ctrl){
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        width: double.infinity,
        height: 58.h,
        child: TextFormField(
          controller: ctrl.password,
          validator: (value){
            return validatePassword(value);
          },
          decoration: InputDecoration(
            hintStyle:TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(119, 119, 119, 1)),
            hintText: "请输入密码",
          ),
        ),
      ),
    );
  }
  nextButton(BuildContext context, RegisterCtrl ctrl){
    return Container(
      width: 327.w,
      margin: EdgeInsets.only(left: 24.w,right: 24.h),
      height: 44.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepOrange
              ])
      ),
      child: TextButton(
          onPressed: (){
            if(ctrl.formKeyRegister.currentState!.validate()){
              Froute.push(Froute.registerData);
            }
          },
          child: Text("注册",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Color.fromRGBO(255, 255, 255, 1))
          )
      ),
    );
  }
  textNotice(BuildContext context, RegisterCtrl ctrl){
    return Container(
        padding: EdgeInsets.only(left: 24.w,right: 24.w),
        alignment: Alignment.center,
        child: Text.rich(
          TextSpan(
              text: "已经注册过，点击这里 ",
              style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(153, 153, 153, 1)),
              children: [
                TextSpan(
                  text: "登录"
                  ,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Colors.deepOrange),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    Get.back();
                  }
                )
              ]
          ),

        )
    );
  }
}
