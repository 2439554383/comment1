import 'package:comment1/data/user_data.dart';
import 'package:comment1/model/user_response.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserInformationCtrl extends GetxController with GetSingleTickerProviderStateMixin {
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

  init() async {
    userInfo = UserData().userResponse.userInfo ?? UserInfo();
    pointsInfo = UserData().userResponse.pointsInfo ?? PointsInfo();
    update();

    Future.wait<dynamic>([
      UserData().getUserInfo()
    ]).then((val) {
      userInfo = UserData().userResponse.userInfo ?? UserInfo();
      pointsInfo = UserData().userResponse.pointsInfo ?? PointsInfo();
      update();
    });
  }

  late AnimationController animationController3 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
  );

  // 用户信息字段列表
  var userInfoItems = [
    {
      "title": "用户ID",
      "value": "id",
      "editable": false,
    },
    {
      "title": "昵称",
      "value": "nickname",
      "editable": true,
    },
    {
      "title": "手机号",
      "value": "phone",
      "editable": true,
    },
    {
      "title": "城市",
      "value": "city",
      "editable": true,
    },
    {
      "title": "行业",
      "value": "industry",
      "editable": true,
    },
    {
      "title": "余额",
      "value": "balance",
      "editable": false,
    },
    {
      "title": "邀请码",
      "value": "inviteCode",
      "editable": false,
    },
    {
      "title": "注册时间",
      "value": "createdAt",
      "editable": false,
    },
    {
      "title": "管理员",
      "value": "isAdmin",
      "editable": false,
    },
  ];

  // 获取字段值
  String getFieldValue(String field) {
    switch (field) {
      case "id":
        return userInfo.id?.toString() ?? "未知";
      case "nickname":
        return userInfo.nickname ?? "未设置";
      case "phone":
        return userInfo.phone ?? "未绑定";
      case "city":
        return userInfo.city ?? "未设置";
      case "industry":
        return userInfo.industry ?? "未设置";
      case "balance":
        return userInfo.balance?.toStringAsFixed(2) ?? "0.00";
      case "inviteCode":
        return userInfo.inviteCode ?? "无";
      case "createdAt":
        return userInfo.createdAt ?? "未知";
      case "isAdmin":
        return userInfo.isAdmin == true ? "是" : "否";
      default:
        return "未知";
    }
  }

  // 显示编辑对话框
  void showEditDialog(int index, BuildContext context) {
    Map item = userInfoItems[index];
    if (!item["editable"]!) return;

    String field = item["value"]!;
    String currentValue = getFieldValue(field);
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("修改${item["title"]}"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "请输入${item["title"]}",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r)
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                updateUserInfo(field, controller.text);
                Navigator.of(context).pop();
              },
              child: Text("修改"),
            ),
          ],
        );
      },
    );
  }

  // 更新用户信息
  void updateUserInfo(String field, String value) {
    switch (field) {
      case "nickname":
        userInfo.nickname = value;
        break;
      case "phone":
        userInfo.phone = value;
        break;
      case "city":
        userInfo.city = value;
        break;
      case "industry":
        userInfo.industry = value;
        break;
    }

    // 这里应该调用API更新用户信息
    // UserData().updateUserInfo(userInfo);

    update(); // 刷新UI
  }
}