import 'dart:io';

import 'package:comment1/old_network/apis.dart';
import 'package:comment1/old_network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';

import '../../../api/http_api.dart';
import '../../../common/app_component.dart';
import '../../../common/loading.dart';
import '../../../network/apis.dart';
import '../../../network/dio_util.dart';

class WaterMarkCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Widget defaultWidget  = Text("我是你的去水印助手");
  ImagePicker imagePicker = ImagePicker();
  late TextEditingController textEditingController = TextEditingController();
  late VideoPlayerController videoPlayerController;
  Future? myFuture;
  var generatedVideo;
  var isinit;
  saveFile() async{
    Loading.show();
    try{
      final response = await http.get(Uri.parse(generatedVideo));
      final temporary = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final temporary_path = "${temporary.path}/temp_$timestamp.mp4";
      File file = File(temporary_path);
      await file.writeAsBytes(response.bodyBytes);
      final status = await Permission.videos.request();
      if(status.isGranted){
        final save_video  = VisionGallerySaver.saveFile(temporary_path);
        save_video.whenComplete(() async{
          showToast("保存成功");
          await file.delete();
        });
      }
      else{
        print("保存失败");
        showToast("保存失败");
      }
    }
    catch(e){
      print("${e}");
    }
    Loading.dismiss();
  }
  point() async {
    final data = {
      "template_id":1
    };
    final r = await HttpUtil().post(Api.point,data: data);
  }
  removeWatermark(String text) async{
    final data = {
      "text":text
    };
    final response = await OldHttpUtil().post(OldApi.removeMark,data: data);
    generatedVideo = response.data;
    print(generatedVideo);
    update();
    if(generatedVideo!=null){
      point();
      return generatedVideo;
    }
    else{
      return Future.error("error");
    }
  }
  setFuture(BuildContext context) async {
    var text = textEditingController.text;
    textEditingController.clear();
    FocusScope.of(context).unfocus();
    myFuture = () async {
      await removeWatermark(text);

      if (generatedVideo != null) {
        videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(generatedVideo));
        await videoPlayerController.initialize();
        update(); // GetX 刷新
      }

      return true;
    }();

  }
  clear(){
    defaultWidget = Text("我是你的去水印助手");
  }
}
