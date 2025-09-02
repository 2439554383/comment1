import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ai_image_ctrl.dart';

class AiImage extends StatelessWidget {
  const AiImage({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: AiImageCtrl(),
      builder: (AiImageCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Ai生图"),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15.w,right: 15.w,top: 0,bottom: 0),
          child: Column(
            children: [
              SizedBox(height: 15.h,),
              imageItem(context, ctrl),
              SizedBox(height: 15.h,),
              generatedButtom(context, ctrl),
              SizedBox(height: 20.h,),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageItem(BuildContext context, AiImageCtrl ctrl) {
    return Expanded(
      child: GestureDetector(
          onTap: () async {
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder(
                        future: ctrl.imageFuture,
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10,),
                                AutoSizeText("正在生成图片～")
                              ],
                            );
                          }
                          else if(snapshot.hasData){
                            return Column(
                              children: [
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () async{
                                    ctrl.download();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.file_download),
                                      AutoSizeText("下载")
                                    ],
                                  ),
                                ),
                                Expanded(child: Image.network(ctrl.image)),
                              ],
                            );
                          }
                          else if(snapshot.hasError){
                            return AutoSizeText("获取失败");
                          }
                          else{
                            return AutoSizeText("「生成的图片将在这里显示」");
                          }
                          ;
                        }
                    )
                ),
              ),
            ],
          )
      ),
    );
  }
  Widget generatedButtom(BuildContext context, AiImageCtrl ctrl) {
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
            hintText: ctrl.defaultHint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white,),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: TextButton(style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),onPressed: () async{
              var post_text = ctrl.textEditingController.text;
              ctrl.textEditingController.clear();
              ctrl.image = null;
              FocusScope.of(context).unfocus();
              ctrl.imageFuture =  ctrl.postImage(post_text);
            }, child: AutoSizeText("生成",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white)))
        ),
      ),
    );
}
}
