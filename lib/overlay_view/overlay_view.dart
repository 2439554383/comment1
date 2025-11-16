import 'dart:convert';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../common/app_preferences.dart';
import '../network/dio_util.dart';
import '../old_network/dio_util.dart';
import 'overlay_view_ctrl.dart';

class OverlayView extends StatelessWidget {
  const OverlayView({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: OverlayViewCtrl(),
      builder: (OverlayViewCtrl ctrl) => Scaffold(
        backgroundColor: Colors.transparent,
        body: ctrl.openDetail ? item2(context, ctrl):item1(context, ctrl),
      ),
    );
  }

  Widget item1(BuildContext context, OverlayViewCtrl ctrl) {
    return Center(
      child: SafeArea(
        child: GestureDetector(
          onTap: () async{
            try {
              final screenWidth = 300.0; // 物理屏幕宽度（像素）
              final screenHeight = 750.0; // 物理屏幕高度（像素）
              await FlutterOverlayWindow.resizeOverlay(1.0,screenHeight,false);
              // 先更新 flag，确保窗口可见
              await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
        
              // 再等待一下，确保 resize 完成
              await Future.delayed(Duration(milliseconds: 200));
        
              // 切换窗口状态
              ctrl.switchWindows(true);
              // // 点击变大：宽度保持屏幕宽度，高度变为屏幕的一半（从顶部到屏幕的一半）
              // // 关键：不能使用 MediaQuery，因为悬浮窗的 context 返回的是悬浮窗尺寸，不是屏幕尺寸
              // // 使用 PlatformDispatcher 获取真实的物理屏幕尺寸（像素值）
              // final window = ui.PlatformDispatcher.instance.views.first;
              // final physicalSize = window.physicalSize;
              // final devicePixelRatio = window.devicePixelRatio;
              //
              // // 物理像素 = 逻辑像素 * devicePixelRatio
              // // 但 WindowManager 需要的就是物理像素
        
              //
              // // 调试信息
              // print("点击变大 - 物理屏幕宽度: $screenWidth, 物理屏幕高度: $screenHeight");
              // print("点击变大 - devicePixelRatio: $devicePixelRatio");
              // print("点击变大 - 调整后宽度: $screenWidth, 调整后高度: $expandedHeight");
              //
              // // 先更新 flag，确保窗口可见
              // await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
              //
              // // 等待一小段时间，确保 flag 更新完成
              // await Future.delayed(Duration(milliseconds: 100));
              //
              // // 调整大小到屏幕宽度和屏幕高度的一半
              // // 传入的是实际物理像素值（>1000），所以会直接使用，不会转换
              // await OverlayViewCtrl.resizeOverlayWithScreenUtil(screenWidth, expandedHeight, false);
              //
              // // 再等待一下，确保 resize 完成
              // await Future.delayed(Duration(milliseconds: 200));
              //
              // // 切换窗口状态
            } catch (e) {
              print("点击变大失败: $e");
              // 即使失败也切换窗口状态
              ctrl.switchWindows(true);
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey
                  )
                ]
            ),
            alignment: Alignment.center,
            child: Text("评论",style: TextStyle(color: Colors.white),)
          ),
        ),
      ),
    );
  }
  Widget item2(BuildContext context, OverlayViewCtrl ctrl) {
    return Center(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+5,bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey
                )
              ]
          ),
          child: Column(
              children: [
                Flexible(
                  flex: 5,
                  child: ctrl.hasList?Container(
                    padding: EdgeInsets.only(top: 10),
                    child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: ctrl.selectList.length,
                        itemBuilder: (conntext,index){
                          return GestureDetector(
                            onTap: (){
                              ctrl.changeStatus(index);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AbsorbPointer(
                                  child: Transform.scale(
                                    scale: 0.8,
                                    child: Checkbox(
                                      value: ctrl.selectList[index].isCheck,
                                      onChanged: (value){},
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ),
                                Expanded(child: Text(ctrl.selectList[index].typeName,softWrap: true,))
                              ],
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,childAspectRatio:8/3)),
                  ):Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()),
                ),
                // Flexible(
                //     flex: 2,
                //     child: TextField(
                //       controller: ctrl.textEditingController1,
                //       decoration: InputDecoration(
                //         contentPadding:EdgeInsets.symmetric(horizontal: 8, vertical: 8) ,
                //         hintText: "自定义提示词",
                //         hintStyle: TextStyle(fontStyle: FontStyle.italic,),
                //       ),
                //       onChanged: (value){
                //         ctrl.selectList.forEach((e)=>e.isCheck=false);
                //         ctrl.update();
                //       },
                //     )
                // ),
                Flexible(
                    flex: 2,
                    child: TextField(
                      controller: ctrl.tcCount,
                      decoration: InputDecoration(
                        hintText: "字数",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        contentPadding:EdgeInsets.symmetric(horizontal: 8, vertical: 8) ,
                      ),
                    )
                ),
                Flexible(
                  flex: 5,
                  child:StreamBuilder(
                        stream: ctrl.streamController.stream,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(child: CircularProgressIndicator()),
                                SizedBox(height: 2,),
                                AutoSizeText("正在思考中…")
                              ],
                            ));
                          }
                          else if(snapshot.connectionState == ConnectionState.active){
                            if (snapshot.hasError) {
                              ctrl.textEditingController.text = "获取失败";
                            }
                            else if (snapshot.hasData) {
                              final dynamic chunk = snapshot.data;
                              String decodedString = "";
                              if (chunk is List<int>) {
                                decodedString = utf8.decode(chunk, allowMalformed: true);
                              } else if (chunk is String) {
                                decodedString = chunk;
                              } else if (chunk != null) {
                                decodedString = chunk.toString();
                              }
                              ctrl.textEditingController.text += decodedString;
                            }
                          }
                          return Column(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: ctrl.textEditingController,
                                  maxLines: 10,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      contentPadding:EdgeInsets.symmetric(horizontal: 8, vertical: 4) ,
                                      hintStyle: TextStyle(fontStyle: FontStyle.italic),
                                      hintText: "https://v.douyin.com/2mOjGQQiqm0/",
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h,),
                              Container(
                                  padding: EdgeInsets.only(right: 20.w),
                                  alignment: Alignment.centerRight,
                                  child: Text("内容由Ai生成")
                              ),
                              SizedBox(height: 5.h,),
                              Container(
                                color: Colors.black54,
                                height: 1,
                              ),
                            ],
                          );
                        },
                      )
                ),
                SizedBox(height: 10.h,),
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 30,right: 30),
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(onPressed: () async{
                            FocusScope.of(context).unfocus();
                            ctrl.postComment();
                            ctrl.showFloatingMessage(context,"真棒！又发了一条评论");
                          },
                            child: FittedBox(child: Text("生成")),
                            style: ButtonStyle(
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: TextButton(
                        //       onPressed: (){
                        //         ctrl.reset();
                        //       },
                        //       child: FittedBox(child: Text("重置"))
                        //   ),
                        // ),
                        // Expanded(
                        //   child: TextButton(
                        //       onPressed: ()async{
                        //         // await content_provider.post_content("");
                        //         showDialog(
                        //             context: context,
                        //             builder: (context){
                        //               return Center(
                        //                 child: Dialog(
                        //                   child: Material(
                        //                     borderRadius: BorderRadius.circular(20),
                        //                     type: MaterialType.card,
                        //                     elevation: 10,
                        //                     color: CupertinoColors.secondarySystemBackground,
                        //                     child: Container(
                        //                       height:350.h,
                        //                       width: 150.w,
                        //                       padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 15.h,bottom: 15.h),
                        //                       child:Column(
                        //                         children: [
                        //                           Expanded(
                        //                             child: ListView.builder(
                        //                                 itemCount: ctrl.contentlist.length,
                        //                                 itemBuilder: (context,index){
                        //                                   return GestureDetector(
                        //                                     onTap: () async {
                        //                                         ctrl.copyContent(index);
                        //                                     },
                        //                                     child: Container(
                        //                                       margin: EdgeInsets.all(5),
                        //                                       height: 35.h,
                        //                                       alignment: Alignment.center,
                        //                                       decoration: BoxDecoration(
                        //                                         borderRadius: BorderRadius.circular(30),
                        //                                         color: Colors.white,
                        //                                       ),
                        //                                       child: Text(ctrl.contentlist[index]),
                        //                                     ),
                        //
                        //                                   );
                        //                                 }),
                        //                           ),
                        //                           Container(
                        //                             height: 45.h,
                        //                             child: TextField(
                        //                               controller: ctrl.textEditingController3,
                        //                               decoration: InputDecoration(
                        //                                   filled: true,
                        //                                   fillColor: Colors.white,
                        //                                   contentPadding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 0),
                        //                                   enabledBorder: OutlineInputBorder(
                        //                                       borderRadius: BorderRadius.circular(20),
                        //                                       borderSide: BorderSide(color: CupertinoColors.secondarySystemBackground)
                        //                                   ),
                        //                                   focusedBorder: OutlineInputBorder(
                        //                                       borderRadius: BorderRadius.circular(20),
                        //                                       borderSide: BorderSide(color: CupertinoColors.secondarySystemBackground)
                        //                                   ),
                        //                                   suffixIcon: TextButton(onPressed: (){
                        //                                     FocusScope.of(context).unfocus();
                        //                                     // content_provider.post_content(textEditingController3.text);
                        //                                     ctrl.textEditingController3.clear();
                        //                                     Navigator.pop(context);
                        //                                   }, child: Text("添加"))
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           SizedBox(height: 5,),
                        //                         ],
                        //                       )
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             });
                        //       },
                        //       child: FittedBox(child: Text("常用语句"))),
                        // ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              ctrl.copy();
                            },
                            child: FittedBox(child: Text("复制")),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async{
                              ctrl.paste();
                            },
                            child: FittedBox(child: Text("粘贴")),
                          ),
                        ),
                        // Expanded(
                        //   child: TextButton(
                        //     style: ButtonStyle(
                        //     ),
                        //     onPressed: () async{
                        //       ctrl.textEditingController.clear();
                        //     },
                        //     child: FittedBox(child: Text("清空")),
                        //   ),
                        // ),
                        Expanded(
                          child: TextButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () async{
                                try {
                                  ctrl.streamController.close();
                                  ctrl.clear();
                                  final overlayWidth = 200.w;
                                  final overlayHeight = 200.h;
                                  ctrl.switchWindows(false);
                                  await Future.delayed(Duration(milliseconds: 200));
                                  await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);
                                  // 先恢复初始大小
                                  await FlutterOverlayWindow.resizeOverlay(2.0, overlayHeight, false);

                                  // 更新 flag

        
                                  // 最后切换窗口状态

                                } catch (e) {
                                  print("最小化失败: $e");
                                  // 即使失败也切换窗口状态
                                  ctrl.switchWindows(false);
                                }
                              }, child: FittedBox(child: Text("最小化"))),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
