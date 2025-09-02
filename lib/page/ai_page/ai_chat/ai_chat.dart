import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/app_component.dart';
import 'ai_chat_ctrl.dart';

class AiChat extends StatelessWidget {
  const AiChat({super.key});

  @override
  build(BuildContext context) {
    final ctrl = Get.find<AiChatCtrl>();
    return GetBuilder(
      init: ctrl,
      builder: (AiChatCtrl ctrl) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(ctrl.title),
        ),
        body: Column(
          children: [
            SizedBox(height: 15.h,),
            generatedItem(context, ctrl),
            SizedBox(height: 15.h,),
            nextButton(context, ctrl),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  Widget generatedItem(BuildContext context, AiChatCtrl ctrl) {
    return Expanded(
      child: StreamBuilder(
        stream: ctrl.streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(child: CircularProgressIndicator()),
                SizedBox(height: 5,),
                AutoSizeText("正在思考中…")
              ],
            ));
          }
          else if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.hasData){
              ctrl.text  += snapshot.data;
              WidgetsBinding.instance.addPostFrameCallback((v){
                if(ctrl.scrollController.hasClients){
                  ctrl.scrollController.jumpTo(
                    ctrl.scrollController.position.maxScrollExtent,
                  );
                }
              });

            }
            else if(snapshot.hasError){
              ctrl.text = "获取失败";
            }
          }
          return ctrl.isStart?Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Markdown(
              controller: ctrl.scrollController,
              data: ctrl.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                  textScaler: TextScaler.linear(1.3)
              ),),
          ):Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  ClipRRect(child: Image.asset("assets/images/appicon.png",width: 55,height: 55,fit: BoxFit.cover,),borderRadius: BorderRadius.circular(25),),
                  Text(ctrl.desc,style: TextStyle(fontSize: 23),),
                  ctrl.type=="智能助手"?Text("我可以帮你答疑、写作、搜索、分析、快来跟我聊天吧",style: TextStyle(color: Colors.grey.shade600),):SizedBox.shrink()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget nextButton(BuildContext context, AiChatCtrl ctrl) {
    return Container(
      margin: EdgeInsets.only(left: 15.w,right: 15.w,top: 0,bottom: 0),
      child: Column(
        children: [
          ['生成菜单','查热量'].contains(ctrl.type)?GestureDetector(
            onTap: () async{
              ctrl.pickImage();
            },
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              child: ctrl.hasImage?ClipRRect(borderRadius:BorderRadius.circular(10),child: Image.file(ctrl.file!,width: 45,height: 45,fit: BoxFit.cover,)):Icon(Icons.add_photo_alternate,size: 50,color: Theme.of(context).primaryColor,),
            ),
          ):SizedBox.shrink(),
          Container(
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
                  hintText: ctrl.hintText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: TextButton(style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor)),onPressed: (){
                    ctrl.text = "";
                    ctrl.isStart =true;
                    FocusScope.of(context).unfocus();
                    if(['姓名打分','起名','智能助手'].contains(ctrl.type)){
                      ctrl.postText();
                    }
                    else if(['生成菜单','查热量'].contains(ctrl.type)){
                      if(ctrl.image==null){
                        showToast("请上传食物图");
                      }
                      else{
                        ctrl.postImage();
                        ctrl.hasImage = false;
                        ctrl.textEditingController.clear();
                      }
                    }
                  }, child: Text("发送",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.white)))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
