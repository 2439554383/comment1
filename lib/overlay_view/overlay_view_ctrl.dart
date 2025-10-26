import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/old_network/apis.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
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
    selectList[index].check();
    update();
  }

  postComment() async{
    streamController = StreamController.broadcast();
    update();
    List<String> postList = selectList
        .where((e) => e.isCheck==true)
        .map((e) => e.typeName)
        .toList();
    postList.add(textEditingController1.text);
    final url = textEditingController.text;
    textEditingController.clear();
    final data = {
      "selecttext_list": postList,
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
        // 确保 chunk 是 List<int> 类型
        if (chunk is Uint8List) {
          // Uint8List 是 List<int> 的子类，可以直接使用
          print("接收到片段1：$chunk");
          if (!streamController.isClosed) {
            streamController.add(chunk);
          }
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

}
