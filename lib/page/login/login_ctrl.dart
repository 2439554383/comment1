import 'package:comment1/common/loading.dart';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/app_component.dart';
import '../../network/apis.dart';
import '../../route/route.dart';

class LoginCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKeyLogin = GlobalKey<FormState>();
  late TextEditingController phone = TextEditingController();
  late TextEditingController password = TextEditingController();

  login() async {
    try{
      Loading.show();
      final data = {
        "phone": phone.text,
        "password":password.text,
        "user_type":"user"
      };
      final response = await HttpUtil().post(Api.login,data: data);
      if(response.isSuccess){
        await UserData().loginSuccess(response.rawValue!['access_token']);
      }
      else{
        showToast("手机号或密码错误");
        Loading.dismiss();
      }
    }
    catch(e){
      print("e = $e");
      Loading.dismiss();
    }
  }
}
