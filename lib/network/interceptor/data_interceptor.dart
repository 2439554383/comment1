import 'package:comment1/network/dio_util.dart';
import 'package:dio/dio.dart';
import '../../common/app_preferences.dart';
import '../../data/user_data.dart';

//数据拦截器
class DataInterceptors extends InterceptorsWrapper {
  // 内存缓存token，避免每次请求都读取SharedPreferences
  // 注意：这个缓存会在每次请求时与SharedPreferences同步，确保悬浮窗能获取最新token

  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从SharedPreferences读取最新token（SharedPreferences内部有缓存，读取很快）
    // 同时更新内存缓存，下次请求时如果token没变化，可以直接使用
    // final token = AppPreferences.getString(_tokenKey);
    //
    // // 如果token变化了，更新缓存
    // if (_cachedToken != token) {
    //   _cachedToken = token;
    // }
    //
    // // 使用最新的token设置请求头
    // if (token != null && token.isNotEmpty) {
    //   HttpUtil().setToken(token);
    // } else {
    //   // 如果没有token，确保清除Authorization头
    //   options.headers.remove('Authorization');
    // }
    super.onRequest(options, handler);
  }
  
  // // 清除缓存的token（当收到401错误时调用）
  // static void clearTokenCache() {
  //   _cachedToken = null;
  // }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async{
    var code = response.data['code'];
    print(response.data['msg']);
    if(response.data['msg']=="Token has expired"){
      print("可以退出登录");
      UserData().logOut();
      return;
    }
     switch (code) {
      case 401:
        // 清除token缓存
        // clearTokenCache();
        UserData().logOut();
        break;
      default:
    }
    super.onResponse(response, handler);

  }
}