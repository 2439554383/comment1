import 'package:comment1/page/person/to_login/to_login_ctrl.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ToLogin extends StatelessWidget {
  const ToLogin({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: ToLoginCtrl(),
      builder: (ToLoginCtrl ctrl) =>
          Container(
            padding: EdgeInsets.only(left: 15.w,right: 15.w),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.5),
                      CupertinoColors.secondarySystemBackground
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment(0, 0)
                )
            ),
            child: Column(
              children: [
                Spacer(),
                Image.asset("assets/images/notice.png",width: 200.w,height: 200.h,),
                SizedBox(height: 70.h,),
                item1(context, ctrl),
                SizedBox(height: 30.h,),
                item2(context, ctrl),
                SizedBox(height: 30.h,),
                item3(context, ctrl),
                SizedBox(height: 30.h,),
                nextButton(context, ctrl),
                SizedBox(height: 200.h,),
              ],
                    ),
          ),
    );
  }

  Widget item1(BuildContext context, ToLoginCtrl ctrl) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.support_agent,color: Colors.orange,size: 35.r,),
          Text("让AI成为你的得力助手",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.black)),
        ]
      ),
    );
  }
  Widget item2(BuildContext context, ToLoginCtrl ctrl) {
    return Container(
      child: Row(
          children: [
            Icon(Icons.functions,color: Colors.blue,size: 35.r,),
            Text("智能时代的新生产力工具，让想法快速落地",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.black)),
          ]
      ),
    );
  }
  Widget item3(BuildContext context, ToLoginCtrl ctrl) {
    return Container(
      child: Row(
          children: [
            Icon(Icons.electric_meter_sharp,color: Colors.greenAccent,size: 35.r,),
            Text("用 AI 释放你的创造力，轻松应对各种挑战",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.black)),
          ]
      ),
    );
  }
  nextButton(BuildContext context, ToLoginCtrl ctrl){
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
            Froute.push(Froute.login);
          },
          child: Text("注册 | 登录",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white)
          )
      ),
    );
  }
}
