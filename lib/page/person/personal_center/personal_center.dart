
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/common/app_component.dart';
import 'package:comment1/page/person/personal_center/personal_center_ctrl.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalCenter extends StatelessWidget {
  const PersonalCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PersonalCenterCtrl(),
      builder: (PersonalCenterCtrl ctrl)=>
          Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(15.r),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userInfo(context,ctrl),
                      SizedBox(height:20.h),
                      memberItem(context,ctrl),
                      SizedBox(height:20.h),
                      ...List.generate(ctrl.itemName.length, (index){
                        return funcItem(context, ctrl, index);
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
  userInfo(BuildContext context, PersonalCenterCtrl ctrl){
    return Container(
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(child: Image.asset("assets/images/avatar.png",width: 65.w,height: 65.h,fit: BoxFit.cover,),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${ctrl.userInfo.nickname}",style: TextStyle(fontSize: 20.sp),)),
              SizedBox(height: 2.h,),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10.r),bottomRight: Radius.circular(10.r),topLeft: Radius.circular(10.r),bottomLeft: Radius.circular(10.r))
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Text("可用积分：${ctrl.pointsInfo.availablePoints}",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500,color: Color.fromRGBO(37, 38, 38, 1)))
              )
            ],
          ),
          Expanded(child: SizedBox()),
          AnimatedBuilder(
            animation: ctrl.animationController3,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                  children: [
                    ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            stops: [
                              ctrl.animationController3.value - 0.1, // 控制光带宽度和位置
                              ctrl.animationController3.value,
                            ],
                            colors: [
                              Colors.orange.withOpacity(0.7),
                              Colors.orange
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },

                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY( ctrl.animationController3.value* 2 * 3.1415926),
                            child: Icon(Icons.shield_moon_rounded,color:Colors.orange,size: 30.r,))),]
              );
            },
          ),
          AnimatedBuilder(
            animation: ctrl.animationController3,
            builder: (BuildContext context, Widget? child) {
              return RotationTransition(turns: Tween(begin: 0.0,end: 1.0).chain(CurveTween(curve: Curves.elasticOut)).animate(ctrl.animationController3),
                  child: Icon(CupertinoIcons.game_controller_solid,size: 30.r));
            },
          ),
          GestureDetector(onTap:(){
            Froute.push("service");
          },child: Icon(Icons.support_agent_rounded,size: 30.r,color:Colors.orange,))
        ],
      ),
    );
  }
  memberItem(BuildContext context, PersonalCenterCtrl ctrl){
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Color.fromARGB(255, 1, 54, 97)
        ),
        child: Column(
          spacing: 20.w,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_sharp,color: Colors.deepOrange,size: 20.r,),
                Text("VIP全新升级",style: TextStyle(fontSize: 16.sp),),
                Expanded(child: SizedBox()),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),topRight: Radius.circular(10.r),bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r),)
                  ),
                  child: TextButton(
                    onPressed:(){
                      showToast("暂未开放");
                      // Froute.push(Froute.open_member);
                    },
                    child:Row(
                      children: [
                        Text("立即充值",style: TextStyle(fontSize: 12.sp),),
                        Icon(Icons.play_circle,size: 15.r,)
                      ],
                    ),
                    style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(100.w,20.h))
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("评论生成",style: TextStyle(fontSize: 14.sp),),
                    Text("AI智能创作",style: TextStyle(fontSize: 12.sp),),
                  ],
                ),
                Column(
                  children: [
                    Text("图像生成",style: TextStyle(fontSize: 14.sp),),
                    Text("高清AI画作",style: TextStyle(fontSize: 12.sp),),
                  ],
                ),
                Column(
                  children: [
                    Text("声音克隆",style: TextStyle(fontSize: 14.sp),),
                    Text("声音自由创作",style: TextStyle(fontSize: 12.sp),),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.more, color: Colors.deepOrange,size: 20.r,),
                    Text("更多特权",style: TextStyle(fontSize: 12.sp),),
                  ],
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
  funcItem(BuildContext context, PersonalCenterCtrl ctrl,int index){
    return GestureDetector(
      onTap: ctrl.itemFunc[index],
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(ctrl.itemName[index],style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Color.fromRGBO(37, 38, 38, 1))),
      ),
    );
  }
}

