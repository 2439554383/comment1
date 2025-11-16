import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:comment1/page/ai_page/ai_chat/ai_chat_ctrl.dart';
import 'package:comment1/page/home/home_ctrl.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../../common/app_component.dart';
import '../../overlay_view/overlay_view_ctrl.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeCtrl(),
      builder: (HomeCtrl ctrl)=>
        Scaffold(
          body: Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.5),
                      CupertinoColors.secondarySystemBackground
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment(0, 0)
                )
            ),
            child: SafeArea(
              child: ListView(
                children: [
                  SizedBox(height: 15.h,),
                  homeHeader(context, ctrl),
                  SizedBox(height: 25.h,),
                  notice(context, ctrl),
                  SizedBox(height: 25.h,),
                  carousel(context, ctrl),
                  SizedBox(height: 25.h,),
                  functionGrid(context, ctrl),
                  SizedBox(height: 25.h,),
                  commentButton(context, ctrl),
                  SizedBox(height: 20.h,),
                  aiButton(context, ctrl),
                  SizedBox(height: 25.h,),
                  // ...functionListView(context, ctrl),
                  // SizedBox(height: 20.h,),
                ],
              ),
            ),
          ),
        ),
    );
  }
  homeHeader(BuildContext context, HomeCtrl ctrl){
    return Row(
      spacing: 10.w,
      children: [
        AnimatedBuilder(
          animation: ctrl.aniIcon,
          builder: (BuildContext context, Widget? child) {
            return  Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(ctrl.aniIcon.value* 2 * 3.1415926),
              child: Container(
                child: ClipRRect(child: Image.asset("assets/images/appicon.png",width: 60.w,height: 60.h,fit: BoxFit.cover,),borderRadius: BorderRadius.circular(25.r),),
              ),
            );},
        ),
        Text("AI评论员",style: TextStyle(fontSize: 25.sp),)
      ],
    );
  }
  notice(BuildContext context, HomeCtrl ctrl){
    return  Container(
      height: 20.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.volume_up),
          SizedBox(width: 10.h,),
          Expanded(child: Marquee(text: "一款基于deep seek一键生成高质量趣评的工具！趣评点击率高会自动置顶，让更多人看到你！"))
        ],
      ),
    );
  }
  carousel(BuildContext context, HomeCtrl ctrl){
    return Container(
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: PageView.builder(
          itemCount: ctrl.pageText.length,
          controller: ctrl.pageController,
          itemBuilder: (context,index){
            return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15.r),
                child: AutoSizeText(
                    ctrl.pageText[index]
                )
            );
          }),
    );
  }
  functionGrid(BuildContext context, HomeCtrl ctrl){
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r)
      ),
      clipBehavior: Clip.hardEdge,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio:1,
        ),
        itemCount: ctrl.iconList.length,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: ctrl.routeList[index],
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(child:ctrl.iconList[index],),
                SizedBox(height: 10.h,),
                AutoSizeText(ctrl.textList[index],style: TextStyle(color: Colors.black),maxLines: 1,minFontSize: 8,)
              ],
            ),
          );
        },
      ),
    );
  }
  commentButton(BuildContext context, HomeCtrl ctrl){
    return Container(
      height: 100.h,
      child: ElevatedButton(
        onPressed: () {
          if(UserData().isLogin){
            showDialog(
                context: context,
                builder: (context){
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: GetBuilder(
                      init: ctrl,
                      builder: (HomeCtrl ctrl)=>
                          Container(
                            width: 250.w,
                            height: 200.h,
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(ctrl.openOverlay?Theme.of(context).primaryColor:Colors.grey),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40.r)
                                            )
                                        )
                                    ),
                                    onPressed: () async{
                                      if(ctrl.openOverlay == false){
                                        final isgranted = await FlutterOverlayWindow.isPermissionGranted();
                                        if(!isgranted){
                                          await FlutterOverlayWindow.requestPermission();
                                          final isgranted1 = await FlutterOverlayWindow.isPermissionGranted();
                                          if(!isgranted1){
                                            showDialog(context: context, builder: (context){
                                              return AlertDialog(
                                                title: Text("提示"),
                                                content: Text("请前往系统设置中手动开启“悬浮窗权限"),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    FlutterOverlayWindow.requestPermission();
                                                    Navigator.pop(context);
                                                  }, child: Text("前往")),
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: Text("取消"))
                                                ],
                                              );
                                            });
                                          }
                                        }
                                        else{

                                          Navigator.pop(context);
                                          // 使用 ScreenUtil 的值，确保可以传入 200.w 和 200.h
                                          final overlayWidth = 200.w;
                                          final overlayHeight = 200.h;
                                          // 保存初始大小
                                          OverlayViewCtrl.initialOverlayWidth = overlayWidth;
                                          OverlayViewCtrl.initialOverlayHeight = overlayHeight;
                                          await FlutterOverlayWindow.showOverlay(
                                            width: OverlayViewCtrl.convertToDp(overlayWidth, isWidth: true),
                                            height: OverlayViewCtrl.convertToDp(overlayHeight, isWidth: false),
                                            enableDrag: false,
                                            alignment :OverlayAlignment.topRight,
                                            positionGravity: PositionGravity.auto,
                                            startPosition: OverlayPosition(0,MediaQuery.of(context).size.height/8),
                                          );
                                          await ctrl.updateList();
                                          await FlutterOverlayWindow.shareData({
                                            "type":"listview",
                                            "type_overlay_list":ctrl.cueList,
                                            "token":HttpUtil().Mytoken
                                          });
                                          ctrl.openOverlay = true;
                                          ctrl.update();
                                        }
                                      }
                                      else{
                                        ctrl.openOverlay = false;
                                        await FlutterOverlayWindow.closeOverlay();
                                        await FlutterOverlayWindow.shareData({
                                          "type":"switch_window"
                                        });
                                      }
                                      ctrl.update();
                                    },
                                    child: ctrl.openOverlay?Row(
                                      spacing: 15,
                                      children: [
                                        SizedBox(),
                                        Icon(CupertinoIcons.checkmark_alt_circle,size: 35,),
                                        Text("关闭悬浮窗",style: TextStyle(fontSize: 20),)
                                      ],
                                    ):Row(
                                      spacing: 15,
                                      children: [
                                        SizedBox(),
                                        Icon(Icons.block,size: 35,),
                                        Text("开启悬浮窗",style: TextStyle(fontSize: 20),)
                                      ],
                                    ),

                                  ),
                                ),
                                SizedBox(height: 20.h,),
                                Container(
                                  height: 50.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Froute.push(Froute.settingCue);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40.r)
                                            )
                                        )
                                    ),
                                    child: Row(
                                      spacing: 15.w,
                                      children: [
                                        SizedBox(),
                                        Icon(CupertinoIcons.settings_solid,size: 35.r,),
                                        Text("设置提示词",style: TextStyle(fontSize: 20.sp),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    ),
                  );
                });
          }
          else{
            showToast("请您先登录");
          }
        },
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
            )
        ),
        child: Row(
          spacing: 15,
          children: [
            SizedBox(),
            Icon(HugeIcons.strokeRoundedComment01,size: 35,),
            Text("生成趣评",style: TextStyle(fontSize: 22),)
          ],
        ),
      ),
    );
  }
  aiButton(BuildContext context, HomeCtrl ctrl){
    return Container(
            height: 100.h,
            child: ElevatedButton(
              onPressed: () {
                if (Get.isRegistered<AiChatCtrl>()) {
                  Get.delete<AiChatCtrl>();
                }
                Get.put(AiChatCtrl("智能助手"));
                Froute.push(Froute.aiChat);
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                  shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  )
              ),
              child: Row(
                spacing: 15.w,
                children: [
                  SizedBox(),
                  Icon(HugeIcons.strokeRoundedAiChat02,size: 35.r,),
                  Text("智能助手",style: TextStyle(fontSize: 22.sp),)
                ],
              ),
            ),
          );
  }
  functionListView(BuildContext context, HomeCtrl ctrl){
    return List.generate(ctrl.titleList.length, (index){
      return GestureDetector(
        onTap: (){
          if (Get.isRegistered<AiChatCtrl>()) {
            Get.delete<AiChatCtrl>();
          }
          Get.put(AiChatCtrl(ctrl.typeList[index]));
          Froute.push(Froute.aiChat);
        },
        child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  spacing: 20,
                  children: [
                    ctrl.iconList1[index],
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ctrl.titleList[index],style: TextStyle(fontSize: 20),),
                          SizedBox(height: 5,),
                          Text(ctrl.describeList[index],softWrap: true,style: TextStyle(color: Theme.of(context).shadowColor),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,)
            ]
        ),
      );
    }
    );
  }
}
