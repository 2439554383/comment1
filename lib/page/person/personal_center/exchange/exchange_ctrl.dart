import 'package:comment1/common/app_component.dart';
import 'package:comment1/common/loading.dart';
import 'package:comment1/data/user_data.dart';
import 'package:comment1/network/apis.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/user_response.dart';

class ExchangeCtrl extends GetxController {
  bool isPoints = true; // true = 积分兑换，false = 余额兑换
  num availablePoints = 0;
  num availableBalance = 0; // 假设有余额
  num exchangeAmount = 0;

  final TextEditingController amountCtrl = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    init();
  }
  init() async {
    availablePoints = UserData().userResponse.pointsInfo?.availablePoints ?? 0.00;
    availableBalance = UserData().userResponse.userInfo?.balance ?? 0.00;
    update();
    getUserInfo();
  }
  getUserInfo() async {
    HttpUtil().get(Api.userInfo).then((val){
      final userResponse = UserResponse.fromJson(val.data);
      availablePoints = userResponse.pointsInfo?.availablePoints ?? 0.00;
      availableBalance = userResponse.userInfo?.balance ?? 0.00;
      update();
    });
  }
  /// 切换兑换模式
  void toggleMode(bool points) {
    isPoints = points;
    exchangeAmount = 0;
    amountCtrl.clear();
    update();
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
    if (isPoints) {
      if (exchangeAmount > availablePoints) {
        showToast("兑换额度不能大于可用积分");
        return;
      }
    } else {
      if (exchangeAmount > availableBalance) {
        showToast("兑换额度不能大于可用余额");
        return;
      }
    }
    Loading.show();
    final data = {
      "times": exchangeAmount
    };
    final response = await HttpUtil().post(isPoints?Api.integralExchange:Api.balanceExchange,data: data);
    if(response.isSuccess){
      await getUserInfo();
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
