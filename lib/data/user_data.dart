//全局数据 使用方式 UserData().
import 'dart:convert';
import 'package:comment1/common/app_component.dart';
import 'package:comment1/model/user_response.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/app_preferences.dart';
import '../common/loading.dart';
import '../network/apis.dart';
import '../network/dio_util.dart';
import '../util/event_bus.dart';

class UserData {
  static UserData? _instance;
  List<String> stockHistoryList = [];
  bool isLogin = false;
  bool isFirstLogin = true;
  UserResponse userResponse = UserResponse();
  init()async{
    getAppPreferences();
  }


  loginSuccess(token) async {
    removeAppPreferences();
    HttpUtil().setToken(token);
    isLogin = true;
    AppPreferences.setString(FStorageKey.token, token);
    await loadDashboardDataConcurrently();
    Loading.dismiss();

    // 使用 `WidgetsBinding.instance.addPostFrameCallback` 确保路由操作在下一帧执行
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Froute.offAll(Froute.tabPage);

      // 判断是否首次登录
      bool isFirstLogin = await AppPreferences.getBool("isFirstLogin") ?? true;
      if (isFirstLogin) {
        // 弹出教学弹窗
        showTeachingDialog();

        // 设置为已登录过，下次不再弹
        await AppPreferences.setBool("isFirstLogin", false);
      }
    });

    showToast("登录成功");
  }

  void showTeachingDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("欢迎使用"),
        content: Text("这里是教学提示内容，可以告诉用户如何使用APP。"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("我知道了"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> loadDashboardDataConcurrently () async {
    final List<dynamic> results = await Future.wait([
      getUserInfo(),
    ]);
  }

  logOut() async {
    Loading.show();
    clear();
    removeAppPreferences();
    HttpUtil().cleanToken();
    showToast("退出登录");
    Loading.dismiss();
    // 使用 `addPostFrameCallback` 确保跳转在下一帧执行
    WidgetsBinding.instance.addPostFrameCallback((_) {

      Froute.offAll(Froute.tabPage);
    });
  }
  clear() {
    isLogin = false;
    userResponse= UserResponse();
  }

  getUserInfo()async{
    try{
      var r = await HttpUtil().get(Api.userInfo);
      if(r.isSuccess){
        userResponse = UserResponse.fromJson(r.data);
        AppPreferences.setString(FStorageKey.userResponse,json.encode(userResponse.toJson()));
        return userResponse;
      }
    }catch(e){}
  }

  getAppPreferences() async {
    final token = AppPreferences.getString(FStorageKey.token);
    if(token!=null){
      HttpUtil().setToken(token);
      isLogin = true;
      final userResponseValue = AppPreferences.getString(FStorageKey.userResponse);
      if(userResponseValue!=null){
        userResponse = UserResponse.fromJson(json.decode(userResponseValue));
      }
    }
  }

  removeAppPreferences(){
    AppPreferences.removeString(FStorageKey.token);
    AppPreferences.removeString(FStorageKey.userResponse);
    print("remover");
  }




  factory UserData() {
    _instance ??= UserData._();
    return _instance!;
  }

  UserData._() : super();
}
