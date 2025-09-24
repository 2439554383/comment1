import 'package:dio/dio.dart';
import '../../../data/user_data.dart';

//数据拦截器
class DataInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var data = response.data;

    if (data is Map<String, dynamic>) {
      // 标准 JSON
      var code = data['code'];
      switch (code) {
        case 401:
          UserData().logOut();
          break;
        default:
      }
    } else {
      // 不是 JSON（比如流式文本），直接跳过，不解析
      print("非 JSON 响应，跳过拦截器: $data");
    }

    super.onResponse(response, handler);
  }

}