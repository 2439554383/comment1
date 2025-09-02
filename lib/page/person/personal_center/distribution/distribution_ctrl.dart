import 'package:comment1/common/app_component.dart';
import 'package:comment1/model/person/distribution/distribution.dart';
import 'package:comment1/model/user_response.dart';
import 'package:comment1/network/apis.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../model/person/invitation_item.dart';

class DistributionCtrl extends GetxController{
  DistributionResponse? distributionResponse;
  Summary? distributionInfo;
  UserInfo? userInfo;
  @override
  void onInit() {
    // TODO: implement onInit
    init();
    super.onInit();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  init() async{
    getArgs();
    await distributionRecord();
    distributionInfo = distributionResponse!.summary;
    invitationList = distributionResponse!.records!;
    update();
  }
  getArgs(){
    final args = Get.arguments;
    if(args != null){
      userInfo = args['userInfo'];
    }
  }
  void copyInviteCode() {
    final code = userInfo?.inviteCode ?? "";
    if (code.isEmpty) {
      showToast("暂无邀请码");
      return;
    }
    Clipboard.setData(ClipboardData(text: code));
  }
  distributionRecord() async{
    try{
      final response = await HttpUtil().get(Api.distributionRecord);
      if(response.isSuccess){
        distributionResponse = DistributionResponse.fromJson(response.rawValue);
        return distributionResponse;
      }
      else{
        showToast(response.error?.message);
        return null;
      }
    }
    catch(e){
      showToast(e.toString());
      return null;
    }
  }
  List<dynamic> accounttype_list = [
    {'title':"证券账户","image":"assets/personal_center/securities_account.png"},
    {'title':"数字货币","image":"assets/personal_center/digital_cash.png"},
    {'title':"理财","image":"assets/personal_center/financing.png"},
  ];
  List<Record> invitationList = [];
}