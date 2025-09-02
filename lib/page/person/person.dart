import 'package:comment1/data/user_data.dart';
import 'package:comment1/page/person/person_ctrl.dart';
import 'package:comment1/page/person/personal_center/personal_center.dart';
import 'package:comment1/page/person/to_login/to_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Person extends StatelessWidget {
  const Person({super.key});

  @override
  Widget build(BuildContext context) {
    print("是否登录:${UserData().isLogin}");
    return GetBuilder(
      init: PersonCtrl(),
      builder: (PersonCtrl ctrl)=>
       Scaffold(
        body:
        UserData().isLogin? PersonalCenter() :ToLogin(),
      ),
    );
  }
}

