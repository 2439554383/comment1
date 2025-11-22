//全局数据 使用方式 UserData().
import 'dart:convert';
import 'package:comment1/common/app_component.dart';
import 'package:comment1/model/user_response.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/http_api.dart';
import '../common/app_preferences.dart';
import '../common/loading.dart';
import '../model/comment_type.dart';
import '../network/apis.dart';
import '../network/dio_util.dart';
import '../util/event_bus.dart';

class UserData {
  static UserData? _instance;
  List<String> stockHistoryList = [];
  List<CommentType> typeList = [];
  bool isLogin = false;
  bool isFirstLogin = true;
  UserResponse userResponse = UserResponse();

  bool isActive = false;

  String activeCode = "";
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

      }
    });

    showToast("登录成功");
  }
  saveFirstLogin() async {
    isFirstLogin = false;
    await AppPreferences.setBool("isFirstLogin", false);
  }
  saveActive(bool value,String code) async {
    isActive = value;
    activeCode = code;
    await AppPreferences.setBool(FStorageKey.isActive, value);
    await AppPreferences.setString(FStorageKey.code, code);
  }

  saveTypeList(List<CommentType> list) {
    typeList = list;
    // 转成 Map 列表
    final dataList = list.map((e) => e.toJson()).toList();

    // 转成 String 存本地（因为 SharedPreferences 不能直接存 List<Map>）
    final jsonString = jsonEncode(dataList);

    // 存储
    AppPreferences.setString(FStorageKey.typeList, jsonString);
  }

  void showTeachingDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("欢迎使用"),
        content: Text("请先注册并登录，然后点击主页可以开始使用我们的工具啦~"),
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


  getActive(String code) async{
    bool isSuccess = await post_active(code);
    if(isSuccess==true){
      print("激活卡还未过期");
    }
    else{
      saveActive(false,"");
      logOut();
    }
  }

  post_active(String text) async{
    var ssl = 'uLeQd9rHTh0GQG7RDiSzF8gJjvpVKxbFPy411f7djE9JC2P8eefOxLaO/BdnbmMejYFjN6NYDE6F2H+N6IaPXCRVpj89SPeY4yTbE4QIwg0DczGzxU0VE+cK4DHKa/uIrlCNL5tdJPL5hJ+NHFA3G6jNw8uhfB4g/rjeF+W/gmCkNWmXQ+TKzJOh7M5+jfcXc3/ew1Us5CM8Rui/mlpMMAQX8C/a+fEQpi1QguYDnGtWr+H7A5MZtaiMAn+heCfr1U4EgcBemc2/ehjOp3tELRKrOMQFS3dVKP8EWBTWbvIqlVZlxV0xM8LjyYhKbVFUgMb9Bg9XUC+IyJLl4lVdsXYQuyXT1ncT2nnzrhz3NPwFx/FGAt/Nw6jHIp7b+3uMwkdNaL8WHNPuA/FKbbg5AoYdF16+FNdid15e3bEJwiPl9Wc4/Pbx0/o66HxSLiw/7w60AcWvRET0DQJXq8hVVA==';
    var url = 'http://www.aiply.top/AppEn.php?appid=12345678&m=3b10dc6194ecc6add629061e45790a68';
    var mutualkey = '03a9f86fc3b6278af71785dd98ec3db7';
    var date = DateTime.now().toString();
    var api = 'login.ic';
    var appsafecode='';
    var md5 = '';
    var icid=text;
    var icpwd="";
    var key="";
    var maxoror='10';
    var post_url = '$url&api=$api&BSphpSeSsL=$ssl&date=$date&mutualkey=$mutualkey&appsafecode=$appsafecode&md5=$md5&icid=$icid&icpwd=$icpwd&key=$key&maxoror=$maxoror';
    print(post_url);
    final response = await http_api().post_active(
        post_url,
        text
    );
    if(response == true){
      return true;
    }
    else{
      return false;
    }
  }

  getAppPreferences() async {
    final token = AppPreferences.getString(FStorageKey.token);
    isActive = AppPreferences.getBool(FStorageKey.isActive)??false;
    activeCode = AppPreferences.getString(FStorageKey.code)??"";
    if(isActive==true){
      getActive(activeCode);
    }
    if(token!=null){
      HttpUtil().setToken(token);
      isLogin = true;
      final userResponseValue = AppPreferences.getString(FStorageKey.userResponse);
      if(userResponseValue!=null){
        userResponse = UserResponse.fromJson(json.decode(userResponseValue));
      }
      final jsonString = AppPreferences.getString(FStorageKey.typeList);
      print("jsonString${jsonString}");
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonData = jsonDecode(jsonString);
      print("jsonData${jsonData}");
      typeList =  jsonData.map((e) => CommentType.fromJson(e)).toList();
      print("typeList${typeList}");
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
