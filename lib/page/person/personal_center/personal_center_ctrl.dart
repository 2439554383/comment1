import 'package:comment1/data/user_data.dart';
import 'package:comment1/model/user_response.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class PersonalCenterCtrl extends GetxController with GetSingleTickerProviderStateMixin{
  late UserInfo userInfo;
  late PointsInfo pointsInfo;
  @override
  void onInit() {
    init();
    super.onInit();
  }
  @override
  void dispose() {
    super.dispose();
  }
  init() async{
    userInfo = UserData().userResponse.userInfo ?? UserInfo();
    pointsInfo = UserData().userResponse.pointsInfo ?? PointsInfo();
    update();
    Future.wait<dynamic>([
      UserData().getUserInfo()
    ]).then((val){
      userInfo = UserData().userResponse.userInfo ?? UserInfo();
      pointsInfo = UserData().userResponse.pointsInfo ?? PointsInfo();
      update();
    });
  }
  late AnimationController animationController3 = AnimationController(vsync: this,duration: Duration(seconds: 1));
  var itemName = [
    "基本信息",
    "账户明细",
    "兑换点数",
    "我的分销",
    "充值记录",
    "修改密码",
    "用户协议",
    "隐私政策",
    "举报与意见反馈",
    "退出登录"
  ];
  late List<dynamic> itemFunc = [
    () => { Froute.push(Froute.userInformation)},
    () => { Froute.push(Froute.userAccount)},
    () => {  Froute.push(Froute.exchange) },
    () => { Froute.push(Froute.distribution,arguments: {"userInfo":userInfo})},
    () => {  Froute.push(Froute.rechargeRecord) },
    () => { Froute.push(Froute.accountSecurity)},
    () => { Froute.push(Froute.user_agreement)},
    () => { Froute.push(Froute.privacy_policy)},
    () => { Froute.push(Froute.feedback_report)},
    () => {  UserData().logOut() }
  ];


}