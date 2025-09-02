import 'package:comment1/network/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/apis.dart';

class RankingCtrl extends GetxController with GetSingleTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }


  late TabController tabController = TabController(length: 2, vsync: this,animationDuration:Duration.zero);
}
