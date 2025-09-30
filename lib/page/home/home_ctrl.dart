import 'dart:async';

import 'package:comment1/common/app_component.dart';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../model/comment_type.dart';
import '../../network/apis.dart';
import '../../network/dio_util.dart';
class HomeCtrl extends GetxController with GetTickerProviderStateMixin{
  @override
  void onInit() {
    super.onInit();
    print("初始化home");
    if(UserData().isLogin && UserData().typeList.isEmpty){
      getCueList();
    }
    else{
      cueList = UserData().typeList.where((e)=>e.isSelect==true).map((e)=>e).toList();
    }
    aniIcon = AnimationController(vsync: this, duration: Duration(seconds: 1),);
    pageController = PageController();
    timer2 = Timer.periodic(Duration(seconds: 6), (timer) {
      aniIcon.forward(from: 0);
    });
    // timer1 = Timer.periodic(Duration(seconds: 10), (timer){
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     currenPage == pageText.length?pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.linear):pageController.jumpToPage(currenPage++);
    //   });
    // });
    update();
  }
  updateList() async {
    if(UserData().isLogin && UserData().typeList.isEmpty){
      getCueList();
    }
    else{
      cueList = UserData().typeList.where((e)=>e.isSelect==true).map((e)=>e).toList();
    }
    update();
  }
  @override
  void dispose() {
    super.dispose();
    aniIcon.dispose();
    timer2.cancel();
    pageController.dispose();
  }
  //controller
  late AnimationController aniIcon;
  late PageController pageController;
  late Timer timer1;
  late Timer timer2;
  List<CommentType> cueList = [];
  var currenPage = 0;
  getCueList()async{
    final params = {
      'per_page':100
    };
    final response = await HttpUtil().get(Api.cueList,params: params);
    if(response.isSuccess){
      final rawList = response.rawValue?['comment_types'] as List? ?? [];
      final List<CommentType> types =
      rawList.map((e) => CommentType.fromJson(e)).toList();
      cueList = types;
    }
    else{
      print("获取失败");
    }
    update();
  }
  //var
  List iconList = [
    // Icon(Icons.face, size: 45.r, color: Colors.deepPurpleAccent.shade200),
    // Icon(HugeIcons.strokeRoundedAiVoice, size: 45.r, color: Colors.blueGrey.shade500),
    // Icon(Icons.image, size: 45.r, color: Colors.deepPurple.shade500),
    Icon(Icons.water_drop, size: 45.r, color: Colors.purple.shade400),
    Icon(Icons.keyboard_voice_sharp, size: 45.r, color: Colors.purple.shade400),
    // Icon(HugeIcons.strokeRoundedPpt01, size: 30, color: Colors.indigoAccent.shade200),
    // Icon(Icons.video_call_outlined, size: 30, color: Colors.amberAccent.shade200),
    // Icon(CupertinoIcons.heart, size: 30, color: Colors.pinkAccent.shade200),
    // Icon(Icons.monochrome_photos, size: 30, color: Colors.deepPurple.shade400),

  ];
  List routeList = [
    // () => Froute.push(Froute.aiFace),
    // () => Froute.push(Froute.voiceClone),
    // () => Froute.push(Froute.aiImage),
    () => Froute.push(Froute.waterMark),
    () => Froute.push(Froute.voiceExtract),
    // () => {showToast("暂未开放")},
    // () => {showToast("暂未开放")},
    // () => {showToast("暂未开放")},
    // () => {showToast("暂未开放")},
  ];
  List pageText = [
    "一键生成高质量的社交媒体评论，让你在社交平台上显得更聪明、更风趣，高情商回复，同时大幅提升互动效率。",
    '使用流程：\n1.在等任意平台浏览时，点击“悬浮窗”按钮，\n2.弹出功能界面，复制链接并选择类型和字数，\n3.自动分析视频并生成评论，用户可以直接使用或编辑后发布；'
  ];
  List textList = [
    // "Ai换脸",
    // "声音克隆",
    // "Ai生图",
    "去水印",
    "提取人声",
    // "PPT生成",
    // "Ai视频",
    // "情感伴侣",
    // "Ai写真",
  ];
  List titleList = [
    "上传食物自动生成菜单",
    "拍食物查热量",
    "名字打分",
    "起名（个人、商业）",
  ];
  List describeList = [
    "上传食物图或名称，智能识别并推荐菜单，轻松制定营养美味的一日三餐",
    "拍一张食物照片，立即识别种类，精准估算热量与营养成分",
    "输入姓名，分析五行、音律、寓意等多维度，给出权威综合评分",
    "输入性别或行业需求，AI智能取名，兼顾音义美与吉祥寓意",
  ];
  List typeList = [
    "生成菜单",
    "查热量",
    "姓名打分",
    "起名",
  ];
  List iconList1 = [
    Icon(Icons.dining_outlined, color: Colors.lightGreen, size: 35),
    Icon(Icons.local_fire_department, color: Colors.redAccent, size: 35),
    Icon(Icons.edit_note, color: Colors.indigo, size: 35),
    Icon(CupertinoIcons.lightbulb, color: Colors.cyan, size: 35),

  ];
  bool openOverlay = false;
}