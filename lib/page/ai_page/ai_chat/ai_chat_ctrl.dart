import 'dart:async';
import 'dart:io';
import 'package:comment1/common/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../api/http_api.dart';

class AiChatCtrl extends GetxController {
  final type;
  AiChatCtrl(this.type);
  @override
  void onInit() {
    super.onInit();
    getType();
    update();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late TextEditingController textEditingController = TextEditingController();
  late ScrollController scrollController = ScrollController();
  StreamController streamController = StreamController.broadcast()..close();
  String text ="";
  String desc ="";
  String title ="";
  String hintText ="";
  XFile? image ;
  File? file;
  bool isStart = false;
  bool hasImage = false;

  getType(){
    switch (type) {
      case "生成菜单":
        title = "上传食物自动生成菜单";
        desc = "你好，我可以根据食材帮你搭配菜谱，轻松搞定一日三餐～";
        hintText = "输入您想要的菜品风格，如：健康、麻辣";
        break;

      case "查热量":
        title = "拍食物查热量";
        desc = "把食物告诉我，我来帮你快速查询热量，吃得健康又安心哦～";
        hintText = "选择图片发送";
        break;

      case "姓名打分":
        title = "名字打分";
        desc = "输入名字，我来为你解析名字寓意，看看它藏着哪些美好意义～";
        hintText = "输入您的姓名";
        break;

      case "起名":
        title = "起名（个人、商业）";
        desc = "输入您的姓氏，我来为您生成寓意美好、朗朗上口的名字～";
        hintText = "输入您的姓氏";
        break;
      case "智能助手":
        title = "智能助手";
        desc = "你好，我是你的AI助手，随时为你提供贴心又聪明的服务哦～";
        hintText = "发消息";
        break;
      default:
        title = "上传食物自动生成菜单";
        desc = "你好，我是你的AI助手，随时为你提供贴心又聪明的服务哦～";
        hintText = "发消息";
    }
  }

  postImage() async{
    streamController = StreamController.broadcast();
    final response = await http_api().postimage_api("http://139.196.235.10:8005/comment/get_image/", textEditingController.text, image!.path,type,streamController);
    update();
  }
  pickImage() async{
    Loading.show();
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image!=null){
      file = File(image!.path);
      hasImage = true;
      update();
    }
    Loading.dismiss();
  }
  postText() async{
    streamController = StreamController.broadcast();
    final response = await http_api().post_text("http://139.196.235.10:8005/comment/get_text/", textEditingController.text,type,streamController);
    textEditingController.clear();
    update();
  }

}
