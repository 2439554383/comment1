import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import '../api/http_api.dart';

class OverlayViewCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    final listen1 = FlutterOverlayWindow.overlayListener.listen((event) async {
      print("Current_event:$event");
      if(event["type"] == "switch_window"){
        switchWindows(false);
      }
      else if(event["type"] == "listview"){
        print("listview");
        wordList = event['type_overlay_list'];
      }
      else if(event["type"] == "size"){
        // print('listview:$event');
        // setState(() {
        //   final heig = event["size"];
        //   final heig1 = event["size1"];
        //   print("heig:$heig");
        //   fullheight = heig.toDouble();
        //   print("heig1:$heig1");
        //   fullheight1 = heig1.toDouble();
        // });
        // listview_provider.type_overlay_list = event['type_overlay_list'] ?? [];
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
      Curves.easeInOut,              // 平滑的匀速感
      Curves.easeInOutSine,          // 更自然的缓入缓出
      Curves.easeInOutCubic,         // 略微加速感
      Curves.easeInOutBack,          // 带轻微回弹
      Curves.easeInOutQuart,         // 稍微有点力量感
      Curves.elasticOut,             // 弹性出场，注意缓和
      Curves.bounceOut,              // 回弹效果，轻快但不急
      Curves.decelerate,             // 缓慢停下
      Curves.fastOutSlowIn,          // 常用流畅感
      Curves.easeOutExpo,            // 匀速中带轻微弹性
      Curves.easeOutQuad,            // 稳定匀速感中带小动作
      Curves.easeInOutCirc,          // 圆滑缓入缓出
      Curves.easeOutBack,            // 小幅回弹感
      Curves.elasticInOut,           // 轻微弹跳的入出
      Curves.bounceInOut,            // 回弹的入出效果
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

  Future<String>? future_comment;
  String text  = "";
  String content = "";
  bool isTrue = false;
  bool openDetail = false;
  bool hasList = false;
  late List typeList=[];
  late List wordList=[];
  late List commentList = [];
  late List contentlist = [
    "哈哈哈哈,好笑",
    "理解吗?!"
  ];
  static const overlayChannel = MethodChannel('com.example.message1');
  late TextEditingController textEditingController = TextEditingController();
  late TextEditingController textEditingController1 = TextEditingController();
  late TextEditingController textEditingController2 = TextEditingController();
  late TextEditingController textEditingController3 = TextEditingController();
  StreamController streamController = StreamController.broadcast()..close();
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
  postComment() {
      List post_list= [];
      commentList.add(textEditingController1.text);
      post_list = List.from(commentList);
      commentList.remove(textEditingController1.text);
      final url = textEditingController.text;
      future_comment = getComment(url,post_list,textEditingController2.text);
      textEditingController.clear();
      update();
  }
  Future<String> getComment(String text,List comment_list1,String count)async{
    streamController = StreamController.broadcast();
    content = await http_api().general_api("http://134.175.230.215:8005/comment/get_comment/", text, comment_list1,count,streamController);
    update();
    return content;
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
  get_list(String code) async{
    final data =  await http_api().all_api("http://134.175.230.215:8005/comment/get_listmodel/",code);
    if(data["status"] ==true){
      print("获取列表中");
      typeList  = data['type_list'];
      wordList  = data['type_overlay_list'];
      update();
    }
    else{
      print("获取列表失败！！！！！！！！！！！！！");
    }

  }
  // overlay_list(){
  //
  // }
  // switch_type_isset(bool istrue,int index) async{
  //   _list_view_model.type_list[index][2] = istrue;
  //   update();
  // }
  // switch_type_isset1(bool istrue,int index) async{
  //   _list_view_model.type_overlay_list[index][3] = istrue;
  //   if(istrue == true){
  //     _list_view_model.comment_list.add(type_overlay_list[index][1]);
  //   }
  //   else{
  //     _list_view_model.comment_list.remove(type_overlay_list[index][1]);
  //   }
  //   print(_list_view_model.comment_list);
  //   update();
  // }
  // reset(){
  //   for(int i = 0; i<_list_view_model.type_overlay_list.length;i++){
  //     _list_view_model.type_overlay_list[i][3] = false;
  //   }
  //   comment_list.clear();
  //   update();
  // }
  // switch_comfirm(String? code) async{
  //   await http_api().switch_api("http://134.175.230.215:8005/comment/switch_isset/",_list_view_model.type_list,code!);
  //   update();
  // }
}
