import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/common/app_component.dart';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/mixin/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';
import 'ai_face_ctrl.dart';

class AiFace extends StatelessWidget {
  const AiFace({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: AiFaceCtrl(),
      builder: (AiFaceCtrl ctrl) => Scaffold(
        body: Scaffold(
          appBar: AppBar(
            title: AutoSizeText("Ai换脸"),
          ),
          body: Container(
            margin: EdgeInsets.only(left: 15.w,right: 15.w,top: 0,bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                generatedImage(context, ctrl),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text("内容由Ai生成")
                ),
                SizedBox(height: 10.h,),
                nextButton(context, ctrl),
                SizedBox(height: 40.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sourceImage(BuildContext context, AiFaceCtrl ctrl) {
    return GestureDetector(
      onTap: () async {
        ctrl.pickImage("source");
      },
      child: Container(
        width: 200.w,
        height: 200.h,
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: CupertinoColors.secondarySystemBackground.withOpacity(0.5)
        ),
        child: ctrl.sourceImage!=null?Image.file(
          ctrl.sourceImage,
          width: double.infinity,
          height: double.infinity,
          // color: ctrl.isChanging?Colors.black.withOpacity(0.5):null,
          colorBlendMode: BlendMode.dstATop,
          fit: BoxFit.cover,):AutoSizeText("上传模版图"),
      ),
    );
  }
  Widget changeIcon(BuildContext context, AiFaceCtrl ctrl){
    return Container(
      child: Center(child: RotatedBox(quarterTurns: 1,
      child: Image.asset("assets/images/translate.png",width: 40.w,height: 40.w,))),
    );
  }
  Widget faceImage(BuildContext context, AiFaceCtrl ctrl){
    return GestureDetector(
      onTap: () async {
        ctrl.pickImage("face");
      },
      child: Container(
        width: 200.w,
        height: 200.h,
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: CupertinoColors.secondarySystemBackground.withOpacity(0.5)
        ),
        child: ctrl.faceImage!=null?Image.file(
            ctrl.faceImage,
            width: double.infinity,
            height: double.infinity,
            // color: ctrl.isChanging?Colors.black.withOpacity(0.5):null,
            colorBlendMode: BlendMode.dstATop,
            fit: BoxFit.cover,
        ):AutoSizeText("上传人脸图"),
      ),
    );
  }
  
  Widget generatedImage(BuildContext context, AiFaceCtrl ctrl){
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white
          ),
          child: FutureBuilder(
              future: ctrl.myFuture,
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.none){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sourceImage(context, ctrl),
                      SizedBox(height: 30.h,),
                      changeIcon(context, ctrl),
                      SizedBox(height: 30.h,),
                      faceImage(context, ctrl),
                    ],
                  );
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sourceImage(context, ctrl),
                      SizedBox(height: 30.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: ctrl.animationController,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.rotate(
                                angle:ctrl.animationController.value*2*3.1415926,
                                child: Container(
                                  child: Center(child: RotatedBox(quarterTurns: 1,
                                      child: Image.asset("assets/images/translate.png",width: 40.w,height: 40.w,))),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 5.w,),
                          Text("正在合成中")
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      faceImage(context, ctrl),
                    ],
                  );
                  // return Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CircularProgressIndicator(),
                  //     SizedBox(height: 10,),
                  //     AutoSizeText("正在生成中～")
                  //   ],
                  // );
                }
                else if(snapshot.hasData){
                  return Column(
                    children: [
                      SizedBox(height: 10.h,),
                      GestureDetector(
                        onTap: () async{
                          // 使用兼容不同Android版本的权限请求
                          final hasPermission = await checkStoragePermission(type: 'image');
                          if(hasPermission){
                            final save_image = VisionGallerySaver.saveImage(
                                ctrl.generatedImage
                            );
                            save_image.whenComplete((){
                              showToast("保存成功");
                            });
                          }
                          else{
                            print("没有获取到权限");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.file_download),
                              AutoSizeText("下载")
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Center(
                        child: Stack(children: [
                          Image.memory(ctrl.generatedImage),
                          Positioned(
                              bottom: 10.h,
                              right: 10.w,
                              child: Text("内容由Ai生成")
                          )
                        ],),
                      )),
                    ],
                  );
                }
                else if(snapshot.hasError){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText("很遗憾，换脸失败",style: TextStyle(fontSize: 16.sp),),
                      SizedBox(height: 15.h,),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.white)
                          ),
                          onPressed: (){
                            ctrl.myFuture = null;
                            ctrl.update();
                          },
                          child: Text("继续换脸",style: TextStyle(fontSize: 14.sp,color: CustomColors.getMainColor(context)),)
                      )
                    ],
                  );
                }
                else{
                  return Column(
                    children: [
                      sourceImage(context, ctrl),
                      SizedBox(height: 30.h,),
                      changeIcon(context, ctrl),
                      SizedBox(height: 30.h,),
                      faceImage(context, ctrl),
                    ],
                  );
                };
              }
          )
      ),
    );
  }
  
  Widget nextButton(BuildContext context, AiFaceCtrl ctrl){
    return Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(CustomColors.getMainColor(context))
          ),
          onPressed: (){
            if(UserData().isLogin){
              ctrl.myFuture =  ctrl.generate();
              ctrl.update();
            }
            else{
              showToast("请您先登录");
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.magic),
              SizedBox(width: 5.w,),
              AutoSizeText("换脸",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white))
            ],
          ),
        )
    );
  }
}