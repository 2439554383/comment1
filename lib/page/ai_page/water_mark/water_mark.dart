
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/page/ai_page/water_mark/water_mark_ctrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../common/app_component.dart';
import '../../../data/user_data.dart';

class WaterMark extends StatelessWidget {
  const WaterMark({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: WaterMarkCtrl(),
      builder: (WaterMarkCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: AutoSizeText("一键去水印"),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15.w,right: 15.w,top: 0,bottom: 0),
          child: Column(
            children: [
              SizedBox(height: 15.h,),
              generatedVideo(context, ctrl),
              SizedBox(height: 15.h,),
              nextButton(context, ctrl),
              SizedBox(height: 20.h,),
            ],
          ),
        ),
      ),
    );
  }

  Widget generatedVideo(BuildContext context, WaterMarkCtrl ctrl) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if(ctrl.videoPlayerController.value.isPlaying){
            ctrl.videoPlayerController.pause();
          }
          else{
            ctrl.videoPlayerController.play();
          }
        },
        child:
        Container(
          alignment: Alignment.center,
          child: FutureBuilder(
              future: ctrl.myFuture,
              builder: (context,snapshot){
                if(snapshot.connectionState ==ConnectionState.waiting){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10,),
                      AutoSizeText("努力去水印中，请稍候～")
                    ],
                  );
                }
                else if(snapshot.hasData) {
                  if(ctrl.videoPlayerController.value.isInitialized){
                    return Column(
                      children: [
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () async{
                              ctrl.saveFile();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.file_download),
                              AutoSizeText("下载")
                            ],
                          ),
                        ),
                        Expanded(child: VideoPlayer(ctrl.videoPlayerController)),
                      ],
                    );
                  }
                  else{
                    return AutoSizeText("「处理后的视频将在这里展示」");
                  }
                }
                else if(snapshot.hasError){
                  return AutoSizeText("去水印失败");
                }
                else{
                  print("else not hasdata");
                  return AutoSizeText("「处理后的视频将在这里展示」");
                }
              }
          ),
        ),

      ),
    );
  }
  Widget nextButton(BuildContext context, WaterMarkCtrl ctrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: CupertinoColors.systemGrey5,
                blurRadius: 0.5,
                spreadRadius:1
            )
          ]
      ),
      clipBehavior: Clip.hardEdge,
      child: TextField(
        controller: ctrl.textEditingController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true ,
            hintText: "粘贴视频链接（抖音、快手等）",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white,),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: TextButton(
                style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),
                onPressed: () async{
                    if(UserData().isLogin){
                      ctrl.setFuture(context);
                    }
                    else{
                      showToast("请您先登录");
                    }
                  },
                child: AutoSizeText("去水印",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white)))
        ),
      ),
    );
  }
}
