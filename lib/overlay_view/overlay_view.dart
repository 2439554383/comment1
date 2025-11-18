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
      child: GestureDetector(
        onTap: () async{
          try {
            final screenWidth = 300.0*ctrl.widthRatio; // 物理屏幕宽度（像素）
            final screenHeight = 1050.0*ctrl.heightRatio; // 物理屏幕高度（像素）
            ctrl.resizeing = true;
            ctrl.update();
            await FlutterOverlayWindow.resizeOverlay(1.0,screenHeight,false);
            // 先更新 flag，确保窗口可见
            await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
            // 再等待一下，确保 resize 完成
            await Future.delayed(Duration(milliseconds: 200));
            // 切换窗口状态
            ctrl.switchWindows(true);
          } catch (e) {
            print("点击变大失败: $e");
            // 即使失败也切换窗口状态
            ctrl.switchWindows(true);
          }
        },
        child: AnimatedContainer(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15 * ctrl.widthRatio),
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey
                )
              ]
          ),
          alignment: Alignment.center,
          duration: Duration(milliseconds: 500),
          child: Text("评论",style: TextStyle(color: Colors.white,fontSize: ctrl.resizeing==true?25*ctrl.widthRatio:12*ctrl.widthRatio),)
        ),
      ),
    );
  }
  Widget item2(BuildContext context, OverlayViewCtrl ctrl) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20 * ctrl.widthRatio), bottomRight: Radius.circular(20 * ctrl.widthRatio)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey
              )
            ]
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 5 * ctrl.heightRatio,bottom: 10 *ctrl.heightRatio),
            child: Column(
                children: [
                  Container(
                    height: 100*ctrl.heightRatio,
                    child: ctrl.hasList?Container(
                      padding: EdgeInsets.only(top: 10 * ctrl.heightRatio),
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
                              child: Center(
                                child: Container(
                                  height: 45*ctrl.heightRatio,
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
                                      Expanded(child: Text(ctrl.selectList[index].typeName,softWrap: true,style: TextStyle(fontSize: 14 * ctrl.widthRatio),))
                                    ],
                                  ),
                                ),
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
                  SizedBox(height: 5 * ctrl.heightRatio,),
                  Flexible(
                      flex: 2,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: ctrl.tcCount,
                        style: TextStyle(
                          fontSize: 14 * ctrl.widthRatio,
                          height: 1.0, // 设置行高为1，避免额外的行间距
                        ),
                        cursorHeight: 14 * ctrl.widthRatio, // 游标高度与字体大小一致
                        decoration: InputDecoration(
                          hintText: "字数",
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14 * ctrl.widthRatio,
                            height: 1.0, // hintText 也设置相同的行高
                          ),
                          isDense: true, // 减少默认内边距
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8 * ctrl.widthRatio,
                            vertical: 8 * ctrl.heightRatio, // 垂直内边距设为0，让 textAlignVertical 生效
                          ),
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
                                  SizedBox(height: 2 * ctrl.heightRatio,),
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
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                      fontSize: 14 * ctrl.widthRatio,
                                      height: 1.0, // 设置行高为1，避免额外的行间距
                                    ),
                                    cursorHeight: 14 * ctrl.widthRatio, // 游标高度与字体大小一致
                                    controller: ctrl.textEditingController,
                                    maxLines: 10,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14 * ctrl.widthRatio,
                                          height: 1.0, // hintText 也设置相同的行高
                                        ),
                                        hintText: "https://v.douyin.com/2mOjGQQiqm0/",
                                        isDense: true, // 减少默认内边距
                                        border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8 * ctrl.widthRatio,
                                        vertical: 8 * ctrl.heightRatio, // 垂直内边距设为0，让 textAlignVertical 生效
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5 * ctrl.heightRatio,),
                                Container(
                                    padding: EdgeInsets.only(right: 20 * ctrl.widthRatio),
                                    alignment: Alignment.centerRight,
                                    child: Text("内容由Ai生成",style: TextStyle(fontSize: 12 * ctrl.widthRatio),)
                                ),
                                SizedBox(height: 5 * ctrl.heightRatio,),
                                Container(
                                  color: Colors.black54,
                                  height: 1 * ctrl.heightRatio,
                                ),
                              ],
                            );
                          },
                        )
                  ),
                  SizedBox(height: 10 * ctrl.heightRatio,),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 30 * ctrl.widthRatio, right: 30 * ctrl.widthRatio),
                      child: Row(
                        spacing: 20 * ctrl.widthRatio,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

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
                              onPressed: () async{
                                ctrl.paste();
                              },
                              child: FittedBox(child: Text("粘贴",style: TextStyle(fontSize: 14 * ctrl.widthRatio),)),
                            ),
                          ),
                          Expanded(
                            child: TextButton(onPressed: () async{
                              FocusScope.of(context).unfocus();
                              ctrl.postComment();
                              ctrl.showFloatingMessage(context,"真棒！又发了一条评论");
                            },
                              child: FittedBox(child: Text("生成",style: TextStyle(fontSize: 14 * ctrl.widthRatio),)),
                              style: ButtonStyle(
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                ctrl.copy();
                              },
                              child: FittedBox(child: Text("复制",style: TextStyle(fontSize: 14 * ctrl.widthRatio),)),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                                style: ButtonStyle(
                                ),
                                onPressed: () async{
                                  try {
                                    ctrl.streamController.close();
                                    ctrl.clear();
                                    final overlayWidth = 200 * ctrl.widthRatio;
                                    final overlayHeight = 200 * ctrl.heightRatio;
                                    ctrl.switchWindows(false);
                                    await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);
                                    // 先恢复初始大小
                                    ctrl.resizeing = false;
                                    ctrl.update();
                                    await FlutterOverlayWindow.resizeOverlay(2.0, overlayHeight, false);

                                    // 更新 flag


                                    // 最后切换窗口状态

                                  } catch (e) {
                                    print("最小化失败: $e");
                                    // 即使失败也切换窗口状态
                                    ctrl.switchWindows(false);
                                  }
                                }, child: FittedBox(child: Text("最小化",style: TextStyle(fontSize: 14 * ctrl.widthRatio),))),
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

                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
