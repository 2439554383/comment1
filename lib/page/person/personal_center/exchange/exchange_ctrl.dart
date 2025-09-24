import 'package:comment1/common/app_component.dart';
import 'package:comment1/common/loading.dart';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/network/apis.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:comment1/page/person/person_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/user_response.dart';
import '../personal_center_ctrl.dart';

class ExchangeCtrl extends GetxController {
  num availableBalance = 0; // 假设有余额
  num exchangeAmount = 0;

  final TextEditingController amountCtrl = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    init();
  }
  init() async {
    availableBalance = UserData().userResponse.userInfo?.balance ?? 0.00;
    update();
    getUserInfo();
  }
  getUserInfo() async {
    HttpUtil().get(Api.userInfo).then((val){
      final userResponse = UserResponse.fromJson(val.data);
      availableBalance = userResponse.userInfo?.balance ?? 0.00;
      update();
    });
  }

  /// 更新输入金额
  void updateAmount(String val) {
    if (val.isEmpty) {
      exchangeAmount = 0;
    } else {
      exchangeAmount = int.tryParse(val) ?? 0;
    }
    update();
  }

  /// 确认兑换逻辑
  void confirmExchange() async {
    if (exchangeAmount <= 0) {
      showToast("请输入兑换额度");
      return;
    }
    if (exchangeAmount > availableBalance) {
      showToast("兑换额度不能大于可用余额");
      return;
    }
    Loading.show();
    final data = {
      "points": exchangeAmount
    };
    final response = await HttpUtil().post(Api.exchangePoints,data: data);
    if(response.isSuccess){
      await getUserInfo();
      PersonalCenterCtrl ctrl = Get.find<PersonalCenterCtrl>();
      ctrl.init();
      showToast(response.message);
    }
    else{
      showToast(response.error?.message ?? "兑换失败");
    }
    amountCtrl.clear();
    exchangeAmount = 0;
    Loading.dismiss();
    update();
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    super.onClose();
  }
}
