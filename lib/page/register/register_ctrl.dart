import 'package:comment1/network/dio_util.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../common/app_component.dart';
import '../../common/loading.dart';
import '../../network/apis.dart';

class RegisterCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    industryCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  final formKeyRegister = GlobalKey<FormState>();
  late TextEditingController phone = TextEditingController();
  late TextEditingController password = TextEditingController();

  final usernameCtrl = TextEditingController();
  final industryCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final inviteIdCtrl = TextEditingController();
  final formKeyData = GlobalKey<FormState>();

  register() async {
    try{
      Loading.show();
      final data = {
        "phone": phone.text,
        "password":password.text,
        "confirm_password":password.text,
        "username": usernameCtrl.text,   // 用户名 (必填)
        "industry": industryCtrl.text,   // 行业 (可选)
        "city": cityCtrl.text,       // 城市 (可选)
        "invite_code":inviteIdCtrl.text
      };
      final response = await HttpUtil().post(Api.register,data: data);
      print("response = $response");
      print("rawValue = ${response.rawValue}");
      if(response.isSuccess){
        Froute.offAll(Froute.login);
        showToast("注册成功");
        Loading.dismiss();
      }
      else{
        showToast("${response.error!.message}");
        Loading.dismiss();
      }
    }
    catch(e){
      print("e = $e");
      showToast("注册失败");
      Loading.dismiss();
    }
  }
}
