import 'package:comment1/network/dio_util.dart';
import 'package:comment1/old_network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';

import '../../../api/http_api.dart';
import '../../../common/app_component.dart';
import '../../../common/loading.dart';
import '../../../network/apis.dart';
import '../../../old_network/apis.dart';

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
    final data = {
      "text":text
    };
    final response = await OldHttpUtil().post(OldApi.getImage,data: data);
    print("${response.data}");
    image= response.data;
    if(image!=null){
      point();
      update();
      return image;
    }
    else{
      return Future.error("error");
    }

  }
  point() async {
    final data = {
      "template_id":1
    };
    final r = await HttpUtil().post(Api.point,data: data);
  }
  download() async {
    Loading.show();

    // 使用兼容不同Android版本的权限请求
    final hasPermission = await checkStoragePermission(type: 'image');

    if (hasPermission) {
      final response = await http.get(Uri.parse(image));

      final result = await VisionGallerySaver.saveImage(response.bodyBytes);

      if (result != null) {
        showToast("保存成功");
      } else {
        showToast("保存失败");
      }
    } else {
      showToast("没有权限");
    }

    Loading.dismiss();
  }

}
