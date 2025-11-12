import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';
import 'dart:typed_data';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/old_network/apis.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../api/http_api.dart';
import '../common/app_preferences.dart';
import '../model/comment_type.dart';
import '../network/apis.dart';
import '../network/dio_util.dart';
import '../old_network/dio_util.dart';

class OverlayViewCtrl extends GetxController {
  Future<String>? future_comment;
  String text  = "";
  String content = "";
  bool isTrue = false;
  bool openDetail = false;
  bool hasList = false;
  late List<CommentType> typeList=[];
  late List<CommentType> selectList=[];
  late List wordList=[];
  late List commentList = [];
  late List contentlist = [
    "哈哈哈哈,好笑",
    "理解吗?!"
  ];
  static const overlayChannel = MethodChannel('com.example.message1');
  late TextEditingController textEditingController = TextEditingController();
  late TextEditingController textEditingController1 = TextEditingController();
  late TextEditingController tcCount = TextEditingController();
  late TextEditingController textEditingController3 = TextEditingController();
  StreamController streamController = StreamController.broadcast()..close();
  
  // 保存初始悬浮窗大小（使用 dp 单位，确保一致性）
  static double initialOverlayWidth = 200.0;
  static double initialOverlayHeight = 200.0;
  @override
  void onInit() {
    super.onInit();
    print("onerlay初始化");
    final listen1 = FlutterOverlayWindow.overlayListener.listen((event) async {
      print("Current_event:$event");
      if(event["type"] == "switch_window"){
        switchWindows(false);
      }
      else if(event["type"] == "listview"){
        final token = event['token'];
        HttpUtil().setToken(token);
        print("listview");
        final rawList = event['type_overlay_list'] as List? ?? [];
        final List<CommentType> types =
        rawList.map((e) => CommentType.fromJson(e)).toList();
        typeList = types;
        selectList = List.from(typeList);
        print("listlist${selectList}");
        hasList = true;
        update();
      }
    });
    overlayChannel.setMethodCallHandler((call) async {
      if (call.method == "onSystemBack") {
        print("收到原生返回键通知");
        await FlutterOverlayWindow.closeOverlay();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    closeWindows();
    textEditingController.dispose();
  }
  void showFloatingMessage(BuildContext context, String message) {
    final random = Random();

    // top 范围 100 ~ 200
    double randomTop = 100 + random.nextInt(101).toDouble();

    // 更柔和的彩色列表
    final colors = [
      Color(0xFF7FB3D5), // 柔和的蓝色
      Color(0xFF85C1E9), // 淡蓝色
      Color(0xFF76D7C4), // 薄荷绿
      Color(0xFF73C6B6), // 青绿色
      Color(0xFFBB8FCE), // 淡紫色
      Color(0xFFC39BD3), // 薰衣草紫
      Color(0xFFF8C471), // 柔和的橙色
      Color(0xFFF0B27A), // 浅橙色
      Color(0xFFE59866), // 浅棕色
      Color(0xFFAED6F1), // 天蓝色
      Color(0xFFA9DFBF), // 淡绿色
      Color(0xFFF9E79F), // 淡黄色
    ];
    Color randomColor = colors[random.nextInt(colors.length)];

    // 更多真实鼓励文案
    final encouragements = [
      "很棒！这条评论一定会爆火！",
      "说得太好了，一针见血！",
      "这个观点很有深度，点赞！",
      "你的见解总是这么独到！",
      "精辟！说出了大家的心声！",
      "这个角度很新颖，学到了！",
      "分析得太到位了，佩服！",
      "为你点赞，正能量满满！",
      "这个思路很清晰，受益匪浅！",
      "观点明确，论据充分，优秀！",
      "你的评论总是这么有温度！",
      "一语中的，直击要害！",
      "这个分享太有价值了！",
      "读你的评论是一种享受！",
      "思路清晰，逻辑严密，赞！",
      "这个建议很实用，收藏了！",
      "你的文字很有感染力！",
      "这个发现很有意义！",
      "观点独特，让人眼前一亮！",
      "总结得很全面，感谢分享！",
      "你的评论总是这么温暖人心！",
      "这个解读很到位，学到了！",
      "文笔流畅，观点鲜明！",
      "你的分享总是这么及时！",
      "这个提醒很重要，谢谢！",
      "见解深刻，发人深省！",
      "你的评论总是这么鼓舞人心！",
      "分析透彻，很有启发性！",
      "这个建议很中肯，采纳了！",
      "你的文字很有力量！",
    ];
    String randomMessage = encouragements[random.nextInt(encouragements.length)];

    // 随机动画曲线
    final curves = [
      Curves.linear,                 // 基础匀速
    ];
    Curve randomCurve = curves[random.nextInt(curves.length)];

    OverlayEntry entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: randomTop,
          left: 0,
          right: 0,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -200, end: MediaQuery.of(context).size.width),
            duration: const Duration(seconds: 3),
            curve: randomCurve, // 使用随机动画曲线
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: randomColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        randomMessage,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 3), () => entry.remove());

  }

  copy() async {
    content = textEditingController.text;
    try {
      await overlayChannel.invokeMethod('printMessage', {'msg': content});
    } on PlatformException catch (e) {
      print("发送失败: ${e.message}");
    }
  }

  paste() async {
    try {
      final result = await overlayChannel.invokeMethod<String>('get_board');
      print("原生剪贴板内容: $result");
      textEditingController.text = result!;
      // 你可以把它赋值到 TextEditingController 等地方
    }
    catch (e) {
      print("获取剪贴板失败: ${e}");
    }
  }
  copyContent(int index) async{
    final content = contentlist[index];
    try {
      await overlayChannel.invokeMethod('printMessage', {'msg': content});
    } on PlatformException catch (e) {
      print("发送失败: ${e.message}");
    }
  }

  changeStatus(int index){
    textEditingController1.clear();
    selectList.forEach((e)=>e.isCheck=false);
    selectList[index].check();
    update();
  }

  postComment() async{
    streamController = StreamController.broadcast();
    update();
    CommentType? keys;
    try {
      keys = selectList
          .firstWhere((e) => e.isCheck==true);
    } catch (e) {
    }
    final customType = textEditingController1.text.trim();
    final url = textEditingController.text;
    textEditingController.clear();
    final data = {
      "comment_type": customType.isNotEmpty?customType:keys?.typeName,
      "count": tcCount.text,
      "url":url
    };
    final response = await OldHttpUtil().postStream(OldApi.getComment,data: data);
    if(response.code==200){
      point();
      final streamData = response.data.stream;
      print("response:${response}");
      print("responseCode:${response.code}");
      streamData.listen((chunk) {
        List<int>? bytes;
        if (chunk is Uint8List) {
          bytes = chunk;
        }
        else if (chunk is List<int>) {
          bytes = List<int>.from(chunk);
        }
        else if (chunk is String) {
          bytes = utf8.encode(chunk);
        }

        if (bytes == null) {
          print("未识别的片段类型: ${chunk.runtimeType}");
          return;
        }

        final decodedChunk = utf8.decode(bytes, allowMalformed: true);
        print("接收到片段：$decodedChunk");

        if (!streamController.isClosed) {
          streamController.add(bytes);
        }
      }).onDone(() {
        if (!streamController.isClosed) {
          streamController.close();
        }
        print("传输结束，数据流关闭");
      });
    }
    else{
      streamController.addError("生成失败");
    }
    update();
  }

  reset(){
    selectList.forEach((e)=>e.isCheck=false);
    update();
  }
  clear(){
    textEditingController.clear();
    textEditingController1.clear();
    tcCount.clear();
    textEditingController3.clear();
    reset();
  }
  point() async {
    final data = {
      "template_id":324
    };
    final r = await HttpUtil().post(Api.point,data: data);
  }
  closeWindows()async{
    FlutterOverlayWindow.disposeOverlayListener();
    await FlutterOverlayWindow.closeOverlay();
  }

  switchWindows(bool opendetail){
    openDetail = opendetail;
    update();
  }

  openOverlay(bool isoverlay){
    update();
  }
  
  // 将屏幕适配单位转换为实际像素值
  // 关键：插件需要的是实际像素值（px），ScreenUtil 的 .w 和 .h 需要转换为实际像素
  // 这个转换逻辑必须与插件的 Math.round 逻辑配合使用，确保 showOverlay 和 resizeOverlay 结果一致
  static double convertToPx(double screenUtilValue, {bool isWidth = true}) {
    // 使用 ScreenUtil 获取实际屏幕尺寸
    // ScreenUtil().screenWidth 和 ScreenUtil().screenHeight 返回实际像素值
    final screenUtil = ScreenUtil();
    final actualScreenWidth = screenUtil.screenWidth;
    final actualScreenHeight = screenUtil.screenHeight;
    final designWidth = 411.0; // 设计稿宽度（从 main.dart 中的 designSize）
    final designHeight = 915.0; // 设计稿高度
    
    // 计算缩放比例
    final scale = isWidth 
        ? (actualScreenWidth / designWidth) 
        : (actualScreenHeight / designHeight);
    
    // 转换为实际像素值
    final pixelValue = screenUtilValue * scale;
    print("convertToPx - 输入值: $screenUtilValue, 缩放比例: $scale, 输出值: $pixelValue");
    return pixelValue;
  }
  
  // 将屏幕适配单位转换为 double（保持兼容性）
  // 对于实际像素值（如 MediaQuery 获取的，通常 > 1000），直接返回
  // 对于 ScreenUtil 适配值（通常 < 1000），转换为实际像素
  // 关键：这个方法的返回值会直接传给插件，插件会使用 Math.round 四舍五入
  // 所以 showOverlay 和 resizeOverlay 必须使用相同的转换逻辑
  static double convertToDp(double value, {bool isWidth = true}) {
    // 如果值很大（可能是实际像素值），直接返回
    if (value > 1000) {
      print("convertToDp - 实际像素值，直接返回: $value");
      return value;
    }
    // 否则认为是 ScreenUtil 适配值，需要转换为实际像素
    final result = convertToPx(value, isWidth: isWidth);
    print("convertToDp - ScreenUtil 适配值转换: $value -> $result");
    return result;
  }
  
  // 恢复初始大小（使用保存的 ScreenUtil 适配值）
  static Future<void> restoreInitialSize() async {
    try {
      final width = convertToDp(initialOverlayWidth, isWidth: true);
      final height = convertToDp(initialOverlayHeight, isWidth: false);
      print("restoreInitialSize - 宽度: $width, 高度: $height");
      
      // 确保值有效
      if (width <= 0 || height <= 0) {
        print("错误：恢复初始大小失败 - 宽度: $width, 高度: $height");
        return;
      }
      
      final result = await FlutterOverlayWindow.resizeOverlay(width, height, false);
      print("restoreInitialSize - 调用成功，结果: $result");
    } catch (e) {
      print("restoreInitialSize - 调用失败: $e");
    }
  }
  
  // 调整大小（支持传入 .w 和 .h 值或实际像素值）
  // 插件现在会严格按照传入的像素值设置大小，不会改变位置
  static Future<void> resizeOverlayWithScreenUtil(double width, double height, bool flag) async {
    // 调试信息
    print("resizeOverlayWithScreenUtil - 传入宽度: $width, 传入高度: $height");
    
    // 如果值很大（可能是实际像素值，如 MediaQuery 获取的），直接使用
    // 否则转换为实际像素值（ScreenUtil 适配值）
    double finalWidth;
    double finalHeight;
    
    if (width > 1000) {
      // 实际像素值，直接使用
      finalWidth = width;
    } else {
      // ScreenUtil 适配值，转换为实际像素
      finalWidth = convertToPx(width, isWidth: true);
    }
    
    if (height > 1000) {
      // 实际像素值，直接使用
      finalHeight = height;
    } else {
      // ScreenUtil 适配值，转换为实际像素
      finalHeight = convertToPx(height, isWidth: false);
    }
    
    // 确保值有效
    if (finalWidth <= 0 || finalHeight <= 0) {
      print("错误：宽度或高度无效 - 宽度: $finalWidth, 高度: $finalHeight");
      return;
    }
    
    print("resizeOverlayWithScreenUtil - 最终宽度: $finalWidth, 最终高度: $finalHeight");
    
    // 直接使用实际像素值，插件会严格按照这个值设置，不会改变位置
    try {
      final result = await FlutterOverlayWindow.resizeOverlay(finalWidth, finalHeight, flag);
      print("resizeOverlayWithScreenUtil - 调用成功，结果: $result");
    } catch (e) {
      print("resizeOverlayWithScreenUtil - 调用失败: $e");
      rethrow;
    }
    
    print("resizeOverlayWithScreenUtil - 调用完成");
  }

}
