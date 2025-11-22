import 'package:comment1/data/user_data.dart';
import 'package:comment1/page/tab_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/app_component.dart';
import '../api/http_api.dart';
import '../common/loading.dart';
import 'bottomBar.dart';

class TabPage extends StatelessWidget {
  DateTime? _lastPressed;

  late TextEditingController textEditingController = TextEditingController();

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
                        if((val==3 || val ==4) && UserData().isActive == false){
                          showToast("登录使用前需要先激活");
                          myDioLog();
                        }
                        else{
                          homeCtrl.currentIndex.value = val;
                          homeCtrl.update();
                        }
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

   myDioLog() {
    return Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: Text("激活"),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                hintText: "请输入激活码",
                focusColor: Colors.deepOrange,
                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 8)
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async{
              FocusScope.of(Get.context!).unfocus();
              Navigator.pop(Get.context!);
              bool isSuccess = await post_active(textEditingController.text);
              if(isSuccess==true){
                UserData().saveActive(true,textEditingController.text);
                showToast("激活成功");
              }
              else{
                UserData().saveActive(false,"");
                showToast("激活失败，请联系客服");
              }
            }, child: Text('激活')),
            TextButton(onPressed: (){ Get.back();}, child: Text('取消')),
          ],
        )
    );
  }

  post_active(String text) async{
    var ssl = 'uLeQd9rHTh0GQG7RDiSzF8gJjvpVKxbFPy411f7djE9JC2P8eefOxLaO/BdnbmMejYFjN6NYDE6F2H+N6IaPXCRVpj89SPeY4yTbE4QIwg0DczGzxU0VE+cK4DHKa/uIrlCNL5tdJPL5hJ+NHFA3G6jNw8uhfB4g/rjeF+W/gmCkNWmXQ+TKzJOh7M5+jfcXc3/ew1Us5CM8Rui/mlpMMAQX8C/a+fEQpi1QguYDnGtWr+H7A5MZtaiMAn+heCfr1U4EgcBemc2/ehjOp3tELRKrOMQFS3dVKP8EWBTWbvIqlVZlxV0xM8LjyYhKbVFUgMb9Bg9XUC+IyJLl4lVdsXYQuyXT1ncT2nnzrhz3NPwFx/FGAt/Nw6jHIp7b+3uMwkdNaL8WHNPuA/FKbbg5AoYdF16+FNdid15e3bEJwiPl9Wc4/Pbx0/o66HxSLiw/7w60AcWvRET0DQJXq8hVVA==';
    var url = 'http://www.aiply.top/AppEn.php?appid=12345678&m=3b10dc6194ecc6add629061e45790a68';
    var mutualkey = '03a9f86fc3b6278af71785dd98ec3db7';
    var date = DateTime.now().toString();
    var api = 'login.ic';
    var appsafecode='';
    var md5 = '';
    var icid=text;
    var icpwd="";
    var key="";
    var maxoror='10';
    var post_url = '$url&api=$api&BSphpSeSsL=$ssl&date=$date&mutualkey=$mutualkey&appsafecode=$appsafecode&md5=$md5&icid=$icid&icpwd=$icpwd&key=$key&maxoror=$maxoror';
    print(post_url);
    final response = await http_api().post_active(
        post_url,
        text
    );
    if(response == true){
      return true;
    }
    else{
      return false;
    }
  }
}
