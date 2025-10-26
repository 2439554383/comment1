import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:comment1/old_network/apis.dart';
import 'package:comment1/old_network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../../api/http_api.dart';
import '../../../common/loading.dart';
import '../../../network/apis.dart';
import '../../../network/dio_util.dart';

class AiFaceCtrl extends GetxController with GetSingleTickerProviderStateMixin{
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
  late AnimationController animationController =AnimationController(vsync: this,duration: Duration(seconds: 1));
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
  bool isChanging = false;
  point() async {
    final data = {
      "template_id":324
    };
    final r = await HttpUtil().post(Api.point,data: data);
  }
  generate() async {
    animationController.repeat();
    isChanging = true;
    update();
    final formData = FormData.fromMap({
      "old_image": await MultipartFile.fromFile(
        sourceImagePath,
        filename: "old_image"
      ),
      "face_image": await MultipartFile.fromFile(
          faceImagePath,
          filename: "face_image"
      )
    });
    final response = await OldHttpUtil().post(OldApi.aiFace,data: formData);
    if(response.isSuccess){
      print("收到图片");
      final bytes = base64Decode(response.data['data']);
      generatedImage = bytes;
      point();
      update();
      animationController.stop();
      return Future.value(true);
    }
    else{
      print("没有收到图片");
      animationController.stop();
      return Future.error("error");
    }

  }
  startAnimate() {

  }
}