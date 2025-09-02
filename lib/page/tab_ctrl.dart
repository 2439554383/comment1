
import 'package:comment1/page/person/personal_center/personal_center.dart';
import 'package:comment1/page/person/to_login/to_login.dart';
import 'package:comment1/page/ranking/ranking.dart';
import 'package:comment1/page/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../data/user_data.dart';
import 'course/course.dart';
import 'home/home.dart';

class TabViewCtrl extends GetxController {
  final int initialIndex;
  TabViewCtrl({this.initialIndex = 0});
  late List<Widget> pages;
  late PageController pageController;
  var currentIndex = 0.obs;
  var childindex;
  @override
  void onInit() {

    pageController = PageController(initialPage: currentIndex.value);
    pages = [
      Home(),
      Course(),
      Store(),
      Ranking(),
      UserData().isLogin?PersonalCenter():ToLogin(),
    ];
    super.onInit();
  }
  void animateToPage(int index,{int? childIndex}) {
    // if(childIndex!=null){
    //   childindex = childIndex;
    // }
    // else{
    //   childindex = null;
    // }
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 1), curve: Curves.easeInOut);
  }
}
