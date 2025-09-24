import 'package:comment1/data/user_data.dart';
import 'package:comment1/model/user_response.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAccountCtrl extends GetxController with GetSingleTickerProviderStateMixin {
  late UserResponse userResponse;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    userResponse = UserData().userResponse;
    update();

    Future.wait<dynamic>([
      UserData().getUserInfo()
    ]).then((val) {
      userResponse = UserData().userResponse;
      update();
    });
  }

  late AnimationController animationController3 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
  );

  // 积分信息字段列表
  var pointsInfoItems = [
    {
      "title": "总积分",
      "value": "totalPoints",
      "icon": Icons.star,
    },
    {
      "title": "可用积分",
      "value": "availablePoints",
      "icon": Icons.monetization_on,
    },
    {
      "title": "消耗积分",
      "value": "consumedPoints",
      "icon": Icons.lock,
    },
  ];

  // 评论信息字段列表
  var commentInfoItems = [
    // {
    //   "title": "每日限制",
    //   "value": "dailyLimit",
    //   "icon": Icons.today,
    // },
    // {
    //   "title": "剩余次数",
    //   "value": "remainingTimes",
    //   "icon": Icons.refresh,
    // },
    {
      "title": "今日评论",
      "value": "todayComments",
      "icon": Icons.comment,
    },
    {
      "title": "总评论数",
      "value": "totalComments",
      "icon": Icons.comment_bank,
    },
  ];

  // 邀请信息字段列表
  var inviteInfoItems = [
    {
      "title": "邀请码",
      "value": "inviteCode",
      "icon": Icons.code,
    },
    {
      "title": "邀请人数",
      "value": "invitedCount",
      "icon": Icons.people,
    },
  ];

  // 余额信息字段列表
  var balanceInfoItems = [
    {
      "title": "账户余额",
      "value": "balance",
      "icon": Icons.account_balance_wallet,
    },
  ];

  // 获取积分字段值
  String getPointsFieldValue(String field) {
    switch (field) {
      case "availablePoints":
        return userResponse.pointsInfo?.availablePoints?.toString() ?? "0";
      case "consumedPoints":
        return userResponse.pointsInfo?.totalPointsConsumed?.toString() ?? "0";
      case "totalPoints":
        return userResponse.pointsInfo?.totalPointsRewarded?.toString() ?? "0";
      default:
        return "0";
    }
  }

  // 获取评论字段值
  String getCommentFieldValue(String field) {
    switch (field) {
      case "dailyLimit":
        return userResponse.commentInfo?.dailyLimit?.toString() ?? "0";
      case "remainingTimes":
        return userResponse.commentInfo?.remainingTimes?.toString() ?? "0";
      case "todayComments":
        return userResponse.commentInfo?.todayComments?.toString() ?? "0";
      case "totalComments":
        return userResponse.commentInfo?.totalComments?.toString() ?? "0";
      default:
        return "0";
    }
  }

  // 获取邀请字段值
  String getInviteFieldValue(String field) {
    switch (field) {
      case "inviteCode":
        return userResponse.inviteInfo?.inviteCode ?? "无";
      case "invitedCount":
        return userResponse.inviteInfo?.invitedCount?.toString() ?? "0";
      default:
        return "";
    }
  }

  // 获取系统字段值
  String getSystemFieldValue(String field) {
    switch (field) {
      case "freeTrials":
        return userResponse.systemInfo?.freeTrials?.toString() ?? "0";
      case "memberSince":
        return userResponse.systemInfo?.memberSince ?? "未知";
      default:
        return "";
    }
  }

  // 获取余额字段值
  String getBalanceFieldValue(String field) {
    switch (field) {
      case "balance":
        return userResponse.userInfo?.balance?.toStringAsFixed(2) ?? "0.00";
      default:
        return "0.00";
    }
  }
}