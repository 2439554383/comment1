import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/http_api.dart';
import '../../../common/loading.dart';

class AiFaceCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  var sourceImage ;
  var faceImage;
  var sourceImagePath ;
  var faceImagePath;
  var generatedImage;
  Future? myFuture;
  Widget defaultWidget = Text("我是你的换脸助手");
  pickImage(String type) async{
    Loading.show();
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image!=null){
      if(type=="source"){
        sourceImagePath = image.path;
        sourceImage = File(image.path);
      }
      else if(type=="face"){
        faceImagePath = image.path;
        faceImage = File(image.path);
      }
      update();
    }
    Loading.dismiss();
  }
  generate() async {
    final response = await http_api().post_aiface("http://134.175.230.215:8005/comment/post_aiface/", sourceImagePath,faceImagePath);
    if(response!=null){
      print("收到图片");
      final bytes = base64Decode(response);
      generatedImage = bytes;
      update();
      return Future.value(true);
    }
    else{
      print("没有收到图片");
      return Future.error("error");
    }
  }
}