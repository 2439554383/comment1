import 'dart:convert';

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
          await FlutterOverlayWindow.resizeOverlay(1, 1,false);
          await FlutterOverlayWindow.updateFlag(OverlayFlag.focusPointer);
          Future.delayed(Duration(milliseconds: 500),(){
            ctrl.switchWindows(true);
          });
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
    );
  }
  Widget item2(BuildContext context, OverlayViewCtrl ctrl) {
    return Center(
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
                flex: 7,
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
                            children: [
                              Expanded(
                                child: AbsorbPointer(child: Checkbox(value: ctrl.selectList[index].isCheck, onChanged: (value){})),
                              ),
                              Expanded(child: Container(child: Text(ctrl.selectList[index].typeName,softWrap: true,)))
                            ],
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,childAspectRatio:6/3)),
                ):Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
              ),
              Flexible(
                  flex: 2,
                  child: TextField(
                    controller: ctrl.textEditingController1,
                    decoration: InputDecoration(
                      contentPadding:EdgeInsets.symmetric(horizontal: 8, vertical: 8) ,
                      hintText: "自定义提示词",
                      hintStyle: TextStyle(fontStyle: FontStyle.italic,),
                    ),
                  )
              ),
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
                flex: 4,
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
                            final String decodedString = utf8.decode(snapshot.data!);
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
              SizedBox(height: 3,),
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
                      Expanded(
                        child: TextButton(
                            onPressed: (){
                              ctrl.reset();
                            },
                            child: FittedBox(child: Text("重置"))
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: ()async{
                              // await content_provider.post_content("");
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return Center(
                                      child: Dialog(
                                        child: Material(
                                          borderRadius: BorderRadius.circular(20),
                                          type: MaterialType.card,
                                          elevation: 10,
                                          color: CupertinoColors.secondarySystemBackground,
                                          child: Container(
                                            height:350.h,
                                            width: 150.w,
                                            padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 15.h,bottom: 15.h),
                                            child:Column(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                      itemCount: ctrl.contentlist.length,
                                                      itemBuilder: (context,index){
                                                        return GestureDetector(
                                                          onTap: () async {
                                                              ctrl.copyContent(index);
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.all(5),
                                                            height: 35.h,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(30),
                                                              color: Colors.white,
                                                            ),
                                                            child: Text(ctrl.contentlist[index]),
                                                          ),

                                                        );
                                                      }),
                                                ),
                                                Container(
                                                  height: 45.h,
                                                  child: TextField(
                                                    controller: ctrl.textEditingController3,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 0),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(color: CupertinoColors.secondarySystemBackground)
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            borderSide: BorderSide(color: CupertinoColors.secondarySystemBackground)
                                                        ),
                                                        suffixIcon: TextButton(onPressed: (){
                                                          FocusScope.of(context).unfocus();
                                                          // content_provider.post_content(textEditingController3.text);
                                                          ctrl.textEditingController3.clear();
                                                          Navigator.pop(context);
                                                        }, child: Text("添加"))
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                              ],
                                            )
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: FittedBox(child: Text("常用语句"))),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3,),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: 30,right: 30),
                  child: Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                          ),
                          onPressed: () async{
                            ctrl.textEditingController.clear();
                          },
                          child: FittedBox(child: Text("清空")),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                            ),
                            onPressed: () async{
                              ctrl.streamController.close();
                              ctrl.clear();
                              ctrl.switchWindows(false);
                              await FlutterOverlayWindow.resizeOverlay(150, 150,false);
                              await FlutterOverlayWindow.updateFlag(OverlayFlag.defaultFlag);
                            }, child: FittedBox(child: Text("最小化"))),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
