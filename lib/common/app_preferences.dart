import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class AppPreferences {
  static late SharedPreferences sharedPreferences;
  static late Directory temporaryDirectory;
  static init() async {
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setString(String key,String value){
    sharedPreferences.setString(key, value);
  }

  static removeString(String key){
    sharedPreferences.remove(key);
  }
  static setList(String key,List<String> value){
    sharedPreferences.setStringList(key, value);
  }

  static removeList(String key){
    sharedPreferences.remove(key);
  }

  static List? getList(String key){
    return sharedPreferences.getStringList(key);
  }

  static String? getString(String key){
    return sharedPreferences.getString(key);
  }

  static bool? getBool(String key){
    return sharedPreferences.getBool(key);
  }

  static setBool(String key,bool value){
    sharedPreferences.setBool(key, value);
  }
}
abstract class FStorageKey {
  static const token = 'token';
  static const userResponse = 'userInfo';
  static const searchHistory = 'searchHistory';
  static const stockSearchHistory = 'stockSearchHistory';
  static const assetsAccount = 'assetsAccount';
  static const securityAccount = 'securityAccount';
  static const positonObject = 'positonObject';
  static const recordObject = 'recordObject';
  static const financingAccountResponse = 'financingAccountResponse';
  static const fpositonObject = 'fpositonObject';
  static const frecordObject = 'frecordObject';
  static const typeList = 'typeList';
  static const isActive = 'isActive';
  static const code = 'code';
}