import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../network/apis.dart';
import '../../../network/dio_util.dart';

class RechargeRankCtrl extends GetxController{
  @override
  void onInit() {
    getRankingList();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  getRankingList() async {
    final response = await HttpUtil().get(Api.dayRanking);
  }

}
