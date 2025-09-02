import 'package:comment1/model/cue/cue_item.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/apis.dart';

class SettingCueCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  String? code ;
  bool hasList = false;
  var cueList = [
    CueItem(name: "有趣",isSet: true,isCheck: true),
    CueItem(name: "搞笑",isSet: true,isCheck: true),
    CueItem(name: "严肃",isSet: true,isCheck: true)
  ];

  getCueList()async{
    final response = HttpUtil().get(Api.cueList);
  }
  changeCue() async {

  }
  changeStatus() async {

  }
}
