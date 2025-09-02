import 'dart:async';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'apis.dart';
import 'interceptor/data_interceptor.dart';
import 'interceptor/logging_interceptor.dart';
import 'result.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();
  late BaseOptions options;

  void init() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      // 请求基地址,可以包含子路径
      baseUrl: Api.baseUrl,

      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: Duration(milliseconds: 50000),
      sendTimeout: Duration(milliseconds: 50000),
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: Duration(milliseconds: 100000),

      // Http请求头.
      headers: {},

      /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
      /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
      /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
      /// 就会自动编码请求体.
      contentType: 'application/json; charset=utf-8',

      /// [responseType] 表示期望以那种格式(方式)接受响应数据。
      /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
      ///
      /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
      /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
      ///
      /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
      responseType: ResponseType.json,
    );
    dio = Dio(options);
    // 添加拦截器
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(DataInterceptors());
  }

  HttpUtil._internal() {
    init();
  }

  setToken(String token){
    dio.options.headers = {"Authorization": "Bearer $token"};
  }

  cleanToken(){
    dio.options.headers = {};
  }
  /*
   * 取消请求
   *
   * 同一个cancel token 可以用���多个请求，当一个cancel token取消时���所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// restful get 操作
  Future<ApiResult> get(String path,
      {dynamic params, Options? options, CancelToken? cancelToken}) async {
    try {
      // var tokenOptions = options ?? getLocalOptions();
      var tokenOptions = options;
      var response = await dio.get(path,
          queryParameters: params,
          options: tokenOptions,
          cancelToken: cancelToken);
      return ApiResult.success(response);
    } on DioError catch (e) {
      return ApiResult.failure(e);
    }
  }

  /// restful post 操作
  Future<ApiResult> post(
      String path, {
        Map<String, dynamic>? parameters,
        Object? data,
        Map<String, dynamic>? headers,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.post(
        path,
        queryParameters: parameters,
        data: data,
        options: options ?? Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return ApiResult.success(response);
    } on DioError catch (e) {
      return ApiResult.failure(e);
    }
  }


  Future<ApiResult> patch(
      String path, {
        Map<String, dynamic>? parameters,
        Object? data,
        Map<String, dynamic>? headers,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.patch(
        path,
        queryParameters: parameters,
        data: data,
        options: options ?? Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return ApiResult.success(response);
    } on DioError catch (e) {
      return ApiResult.failure(e);
    }
  }

  Future<ApiResult> put(
      String path, {
        Map<String, dynamic>? parameters,
        Object? data,
        Map<String, dynamic>? headers,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.put(
        path,
        queryParameters: parameters,
        data: data,
        options: options ?? Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return ApiResult.success(response);
    } on DioError catch (e) {
      return ApiResult.failure(e);
    }
  }

  Future<ApiResult> delete(
      String path, {
        Map<String, dynamic>? parameters,
        Object? data,
        Map<String, dynamic>? headers,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: parameters,
        data: data,
        options: options ?? Options(headers: headers),
        cancelToken: cancelToken,
      );
      return ApiResult.success(response);
    } on DioError catch (e) {
      return ApiResult.failure(e);
    }
  }

  Future<ApiResult> download(String path, String savePath) async {
    try {
      final response = await dio.download(path, savePath);
      return ApiResult.success(response);
    } on DioError catch (e) {
      return ApiResult.failure(e);
    }
  }

  // Future postFile(String filePath,{int time = 0}) async {
  //   try {
  //     String name = basename(filePath);
  //     if(name.length > 100){
  //       name = name.substring(name.length - 99, name.length);
  //     }
  //     final MultipartFile _file =
  //     await MultipartFile.fromFile(filePath, filename: name);
  //     final FormData formData = FormData.fromMap({"file": _file});
  //
  //     var response = await dio.post(Api.uploadFile,
  //         data: formData);
  //     return ApiResult.success(response);
  //   } on DioError catch (e) {
  //     return ApiResult.failure(e);
  //   }
  // }

}
