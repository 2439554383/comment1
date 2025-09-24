import 'package:comment1/data/user_data.dart';
import 'package:comment1/model/cue/cue_item.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/comment_type.dart';
import '../../../network/apis.dart';

class SettingCueCtrl extends GetxController {
  @override
  void onInit() {
    if(UserData().isLogin && UserData().typeList.isEmpty){
      getCueList();
    }
    else{
      typeList = UserData().typeList;
      hasList  =true;
    }
    update();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  String? code ;
  bool hasList = false;
  List<CommentType> typeList = [];
  late RefreshController refreshController = RefreshController();
  var cueList = [
    CueItem(name: "有趣",isSet: true,isCheck: true),
    CueItem(name: "搞笑",isSet: true,isCheck: true),
    CueItem(name: "严肃",isSet: true,isCheck: true)
  ];

  getCueList()async{
      final params = {
        'per_page':100
      };
    final response = await HttpUtil().get(Api.cueList,params: params);
    if(response.isSuccess){
      final rawList = response.rawValue?['comment_types'] as List? ?? [];
      final List<CommentType> types =
      rawList.map((e) => CommentType.fromJson(e)).toList();
      typeList = types;
      hasList = true;
    }
    else{
      print("获取失败");
      hasList = false;
    }
    update();
  }

  // favoriteList()async{
  //   final data = {
  //     'template_id':4
  //   };
  //   final response = await HttpUtil().post(Api.favoriteList,data: data);
  //   if(response.isSuccess){
  //     // final rawList = response.rawValue?['comment_types'] as List? ?? [];
  //     // final List<CommentType> types =
  //     // rawList.map((e) => CommentType.fromJson(e)).toList();
  //     // typeList = types;
  //     // hasList = true;
  //   }
  //   else{
  //     print("获取失败");
  //     hasList = false;
  //   }
  //   update();
  // }

  changeCue() async {
    UserData().saveTypeList(typeList);
    showToast("修改成功");
    Get.back();
  }
  changeStatus(int index) async {
    typeList[index].isSelect = !typeList[index].isSelect;
    update();
  }
}
