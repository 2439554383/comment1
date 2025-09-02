import 'dart:async' show Timer;
import 'package:comment1/api/http_api.dart';
import 'package:comment1/network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alipay_kit/alipay_kit.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../network/apis.dart';

class OpenMemberCtrl extends GetxController{
  Color bgcolor = Colors.grey;
  int currentIndex = 0;
  Timer? timer1 ;
  pay() async {
    final data = {
      "amount":currentIndex==0?0.01:currentIndex==1?88:158,
    };
    final response = await HttpUtil().post(Api.pay,data: data);
    if(response.isSuccess){
      final result = await AlipayKitPlatform.instance.pay(orderInfo:response.rawValue?['payment_url']);
    }
  }
  Future<void> goPay(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 强制跳外部应用（支付宝/浏览器）
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  // pay() async  {
  //   final todjango = await http_api().all_api("http://134.175.230.215:8005/comment/pay/",_current_index==0?"0.01":_current_index==1?"88":"158");
  //   final result = await AlipayKitPlatform.instance.pay(orderInfo: todjango['data']);
  //   timer1 =Timer.periodic(Duration(seconds: 1), (timer) async {
  //     final response = await http_api().all_api("http://134.175.230.215:8005/comment/query_alipay_order/","${todjango['trade_no']}");
  //     if(response.statusCode ==200){
  //       timer1!.cancel();
  //       print(response['activation_code']);
  //     }
  //     else{
  //       print(response);
  //     }
  //   });
  // }

  // pay(String text) async{
  //   var ssl = 'uLeQd9rHTh0GQG7RDiSzF8gJjvpVKxbFPy411f7djE9JC2P8eefOxLaO/BdnbmMejYFjN6NYDE6F2H+N6IaPXCRVpj89SPeY4yTbE4QIwg0DczGzxU0VE+cK4DHKa/uIrlCNL5tdJPL5hJ+NHFA3G6jNw8uhfB4g/rjeF+W/gmCkNWmXQ+TKzJOh7M5+jfcXc3/ew1Us5CM8Rui/mlpMMAQX8C/a+fEQpi1QguYDnGtWr+H7A5MZtaiMAn+heCfr1U4EgcBemc2/ehjOp3tELRKrOMQFS3dVKP8EWBTWbvIqlVZlxV0xM8LjyYhKbVFUgMb9Bg9XUC+IyJLl4lVdsXYQuyXT1ncT2nnzrhz3NPwFx/FGAt/Nw6jHIp7b+3uMwkdNaL8WHNPuA/FKbbg5AoYdF16+FNdid15e3bEJwiPl9Wc4/Pbx0/o66HxSLiw/7w60AcWvRET0DQJXq8hVVA==';
  //   var url = 'http://134.175.230.215/AppEn.php?appid=12345678&m=3b10dc6194ecc6add629061e45790a68';
  //   var mutualkey = '03a9f86fc3b6278af71785dd98ec3db7';
  //   var date = DateTime.now().toString();
  //   var api = 'alipay.ic';
  //   var appsafecode='';
  //   var md5 = '';
  //   var icid=text;
  //   var icpwd="";
  //   var key="";
  //   var maxoror='10';
  //   var post_url = '$url&api=$api&BSphpSeSsL=$ssl&date=$date&mutualkey=$mutualkey&appsafecode=$appsafecode&md5=$md5&icid=$icid&icpwd=$icpwd&key=$key&maxoror=$maxoror';
  //   print(post_url);
  //   final response = await http_api().post_active(
  //       post_url,
  //       text
  //   );
  //   if(response == true){
  //     print(response);
  //     notifyListeners();
  //     print("登陆成功");
  //     return true;
  //   }
  //   else{
  //     print(response);
  //     print("登陆失败");
  //     showToast("激活码不存在或已过期",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
  //     notifyListeners();
  //     return false;
  //   }
  //   notifyListeners();
  // }

}