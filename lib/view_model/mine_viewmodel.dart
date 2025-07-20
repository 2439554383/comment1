import 'dart:async';

import 'package:comment1/api/http_api.dart';
import 'package:comment1/models/mine_model.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class mine_viewmodel extends ChangeNotifier{
  mine_model _mine_model = mine_model();
  String get code => _mine_model.code;
  bool get isactive => _mine_model.isactive;
  set code(String code){
    _mine_model.code = code;
    notifyListeners();
  }
  set isactive(bool isactive){
    _mine_model.isactive = isactive;
    notifyListeners();
  }
  post_code(String code) async{
    final response = await http_api().post_code("http://139.196.235.10:8005/comment/get_code/",code);
    notifyListeners();
  }
  post_active(String text) async{
    var ssl = 'uLeQd9rHTh0GQG7RDiSzF8gJjvpVKxbFPy411f7djE9JC2P8eefOxLaO/BdnbmMejYFjN6NYDE6F2H+N6IaPXCRVpj89SPeY4yTbE4QIwg0DczGzxU0VE+cK4DHKa/uIrlCNL5tdJPL5hJ+NHFA3G6jNw8uhfB4g/rjeF+W/gmCkNWmXQ+TKzJOh7M5+jfcXc3/ew1Us5CM8Rui/mlpMMAQX8C/a+fEQpi1QguYDnGtWr+H7A5MZtaiMAn+heCfr1U4EgcBemc2/ehjOp3tELRKrOMQFS3dVKP8EWBTWbvIqlVZlxV0xM8LjyYhKbVFUgMb9Bg9XUC+IyJLl4lVdsXYQuyXT1ncT2nnzrhz3NPwFx/FGAt/Nw6jHIp7b+3uMwkdNaL8WHNPuA/FKbbg5AoYdF16+FNdid15e3bEJwiPl9Wc4/Pbx0/o66HxSLiw/7w60AcWvRET0DQJXq8hVVA==';
    var url = 'http://139.196.235.10/AppEn.php?appid=12345678&m=3b10dc6194ecc6add629061e45790a68';
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
      _mine_model.isactive = true;
      final sp = await SharedPreferences.getInstance();
      final code = sp.setString("code",text);
      notifyListeners();
      print("登陆成功");
      return true;
    }
    else{
      print(response);
      print("登陆失败");
      showToast("激活码不存在或已过期",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
      _mine_model.isactive = false;
      notifyListeners();
      return false;
    }
    notifyListeners();
  }
}