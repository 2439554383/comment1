import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class ApiResult<T> {
  int code = -1;
  String? message;
  // bool success = false;

  dynamic data;

  Map<String, dynamic>? rawValue;

  ApiError? error;

  bool get isSuccess => code == 200;

  Map<String, dynamic> get dataJson {
    if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }
    return {};
  }

  List<dynamic> get dataList {
    if (data is List<dynamic>) {
      return data as List<dynamic>;
    }
    return [];
  }

  ApiResult.success(Response response) {
    try {
      // 情况 1：流式数据
      if (response.data is ResponseBody) {
        code = response.statusCode ?? 200;
        message = response.statusMessage ?? "";
        data = response.data; // 保存 ResponseBody，外部拿到后用 data.stream 来消费
        rawValue = response.data;
        return;
      }

      // 情况 2：普通 JSON 逻辑
      if (response.data['error'] != null) {
        error = ApiError(
          code: response.data['error']['code'] ?? -1,
          message: response.data['error']['message'] ?? '请求失败',
        );
        return;
      }

      if (response.statusCode != 200) {
        message = response.statusMessage;
        code = response.statusCode ?? -1;
        return;
      }

      Map<String, dynamic> json;
      if (response.data is Map) {
        json = response.data;
      } else {
        json = jsonDecode(response.data);
      }

      // 有 code 就用 code，没有就默认 200
      if (json.containsKey("code")) {
        if (json["code"] is String) {
          code = int.tryParse(json["code"]) ?? 200;
        } else {
          code = json["code"] ?? 200;
        }
      } else {
        code = 200;
      }

      // message 兼容不同写法
      message = json["msg"] ?? json["message"] ?? "";

      // data 兼容，有 data 就取 data，没有就把整个 json 当 data
      if (json.containsKey("data")) {
        data = json["data"];
      } else {
        data = json;
      }

      rawValue = json;
    } catch (e) {
      message = e.toString();
      log(e.toString());
    }
  }


  ApiResult.failure(DioError exception) {
    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      // 后端返回 JSON 格式
      if (data['error'] != null) {
        error = ApiError(
          code: -1,
          message: data['error'] ?? '请求失败',
        );
        return;
      }
    } else if (data is String) {
      // 后端返回 String
      error = ApiError(
        code: exception.response?.statusCode ?? -1,
        message: data,
      );
      return;
    } else if (data is ResponseBody) {
      // 流式响应错误
      error = ApiError(
        code: exception.response?.statusCode ?? -1,
        message: "流式响应错误 (ResponseBody)，请检查后端是否返回 JSON",
      );
      return;
    }

    // 默认错误处理
    error = ApiError(
      code: exception.response?.statusCode ?? -1,
      message: _getBasicErrorMessage(exception),
    );
    message = _getBasicErrorMessage(exception);
  }


  String _getBasicErrorMessage(DioError exception) {
    if (exception.response?.statusCode != null) {
      return '请求失败: ${exception.response?.statusCode}';
    }
    if (exception.type == DioErrorType.connectionTimeout) {
      return '连接超时';
    }
    if (exception.type == DioErrorType.receiveTimeout) {
      return '接收超时';
    }
    if (exception.type == DioErrorType.sendTimeout) {
      return '发送超时';
    }
    return '请求失败';
  }
}

class ApiError {
  int code = -1;
  String? message;

  ApiError({
    this.code = -1,
    this.message,
  });

  @override
  String toString() {
    return 'ApiError{code: $code, message: $message}';
  }
}
