import 'package:comment1/page/tab_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../common/app_component.dart';
import 'bottomBar.dart';

class TabPage extends StatelessWidget {
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.put(TabViewCtrl());
    return WillPopScope(
        child: GetBuilder<TabViewCtrl>(
            init: homeCtrl,
            builder: (homeCtrl) => Scaffold(
              backgroundColor: Colors.white,
              body: Obx(() {
                return Scaffold(
                  body:homeCtrl.pages[homeCtrl.currentIndex.value],
                  bottomNavigationBar: BottomBar(
                      callback: (val) {
                        homeCtrl.currentIndex.value = val;
                        homeCtrl.update();
                      },
                      currentIndex: homeCtrl.currentIndex.value),
                );
              }),
            )),
        onWillPop: () async {
          if (_lastPressed == null ||
              DateTime.now().difference(_lastPressed!) >
                  Duration(
                    milliseconds: 1500,
                  )) {
            showToast(
              '再次操作将退出App',
            );
            //两次点击间隔超过1秒则重新计时
            _lastPressed = DateTime.now();
            return false;
          }
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        });
  }
}
