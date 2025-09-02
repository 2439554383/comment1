import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';

import '../../../api/http_api.dart';
import '../../../common/app_component.dart';

class AiImageCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  var text ;
  var image ;
  var defaultHint = "告诉我你想生成什么样的图片";
  Widget defaultWidget = Text("我是ai图片");
  Future? imageFuture;
  ImagePicker imagePicker = ImagePicker();
  late TextEditingController textEditingController = TextEditingController();

  postImage(var text) async{
    image= await http_api().post_aiimage("http://134.175.230.215:8005/comment/get_aiimage/", text);
    if(image!=null){
      update();
      return image;
    }
    else{
      return Future.error("error");
    }

  }
  download() async {
    final status = await Permission.photos.request();
    if(status.isGranted){
      final response = await http.get(Uri.parse(image));
      print(response.bodyBytes);
      final save_image = VisionGallerySaver.saveImage(
          response.bodyBytes
      );
      save_image.whenComplete((){
        showToast("保存成功");
      });
    }
    else{
      showToast("保存失败");
      print("没有获取到权限");
    }
  }
}
