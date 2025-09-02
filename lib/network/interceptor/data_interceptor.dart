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
  void onResponse(Response response, ResponseInterceptorHandler handler) async{
    var code = response.data['code'];
     switch (code) {
      case 401:
        UserData().logOut();
        break;
      default:
    }
    super.onResponse(response, handler);

  }
}