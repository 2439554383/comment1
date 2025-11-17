import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';


showPicker<T>(List<T> pickerData, Function(List<T> selecteds) confirm) {
  FocusManager.instance.primaryFocus?.unfocus();
  Picker picker = Picker(
    height: 200,
    confirmText: '确认',
    cancelText: '取消',
    containerColor: Colors.white,
    adapter: PickerDataAdapter<T>(
      pickerData: pickerData,
    ),
    changeToFirst: false,
    textAlign: TextAlign.left,
    cancelTextStyle: TextStyle(fontSize: 16.sp,color: Color(0xff999999)),
    confirmTextStyle: TextStyle(fontSize: 16.sp,color: Color(0xff304FFF),fontWeight: FontWeight.w500),
    textStyle: TextStyle(color: Color(0xff999999), fontSize: 16.sp),
    selectedTextStyle: TextStyle(color: Color(0xff2B2B2B), fontSize: 16.sp,fontWeight: FontWeight.w500),
    columnPadding: const EdgeInsets.all(8.0),
    onConfirm: (Picker picker, List value) {
      print('选择的：${picker.getSelectedValues()}');

      confirm(picker.getSelectedValues() as List<T>);
    },
  );
  picker.showModal(Get.context!,backgroundColor: Colors.white);
}


showToast(String? m ){
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: m??"",gravity: ToastGravity.CENTER);
}
showCustomToast(String? m,ToastGravity position){
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: m??"",gravity: position);
}

void showKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
  FocusManager.instance.primaryFocus?.unfocus();
}



Widget assetImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/image/$image$format',width: w,height: h,fit: fit,color: color,);
}

Widget loginImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/login/$image$format',width: w,height: h,fit: fit,color: color,);
}

Widget tabImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/tab/$image$format',width: w,height: h,fit: fit,color: color,);
}

Widget tradeImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/trade/$image$format',width: w,height: h,fit: fit,color: color,);
}
Widget contractImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/contract/$image$format',width: w,height: h,fit: fit,color: color,);
}
Widget assetAssetImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/asset/$image$format',width: w,height: h,fit: fit,color: color,);
}
Widget goldImage(String image,{double? w, double? h, BoxFit? fit, String format = '.png',Color? color}){
  return Image.asset('assets/gold/$image$format',width: w,height: h,fit: fit,color: color,);
}

snackBar(BuildContext context,String title){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
    duration: Duration(
      seconds: 1,
    ),
  ));
}
appPrint(String data){
  debugPrint(data);
}

/// 权限检查
/// [permission] 具体权限
Future<bool> checkPermission(Permission permission) async {
  PermissionStatus status = await permission.status;
  if (status.isGranted) {
    return true;
  }
  PermissionStatus _status = await permission.request();
  if (_status.isGranted) {
    return true;
  } else {
    appPrint('checkPermission = ${permission.toString()}');
    showToast("权限被拒绝");
  }
  if (!status.isGranted) {
    openAppSettings();
  }
  return Future.value(false);
}

/// 兼容不同Android版本的存储权限请求
/// [type] 文件类型: 'image', 'video', 'audio'
/// Android 13+ (API 33+) 使用细粒度权限: photos, videos, audio
/// Android 12及以下使用 storage 权限
Future<bool> checkStoragePermission({String type = 'image'}) async {
  try {
    // 根据类型确定主权限
    Permission primaryPermission;
    
    if (type == 'image') {
      primaryPermission = Permission.photos;
    } else if (type == 'video') {
      primaryPermission = Permission.videos;
    } else if (type == 'audio') {
      primaryPermission = Permission.audio;
    } else {
      primaryPermission = Permission.photos; // 默认使用photos
    }
    
    appPrint('检查存储权限，类型: $type');
    
    // 步骤1: 检查主权限状态
    PermissionStatus primaryStatus = await primaryPermission.status;
    appPrint('主权限状态: $primaryStatus');
    
    // 如果已授予，直接返回
    if (primaryStatus.isGranted) {
      appPrint('主权限已授予');
      return true;
    }
    
    // 步骤2: 检查 storage 权限状态（作为备选）
    PermissionStatus storageStatus = await Permission.storage.status;
    appPrint('Storage权限状态: $storageStatus');
    
    // 如果 storage 权限已授予，直接返回
    if (storageStatus.isGranted) {
      appPrint('Storage权限已授予');
      return true;
    }
    
    // 步骤3: 如果主权限不是永久拒绝，尝试请求
    if (!primaryStatus.isPermanentlyDenied) {
      appPrint('请求主权限...');
      primaryStatus = await primaryPermission.request();
      appPrint('主权限请求结果: $primaryStatus');
      
      if (primaryStatus.isGranted) {
        appPrint('主权限已授予');
        return true;
      }
    }
    
    // 步骤4: 如果 storage 权限不是永久拒绝，尝试请求
    if (!storageStatus.isPermanentlyDenied) {
      appPrint('请求storage权限...');
      storageStatus = await Permission.storage.request();
      appPrint('Storage权限请求结果: $storageStatus');
      
      if (storageStatus.isGranted) {
        appPrint('Storage权限已授予');
        return true;
      }
    }
    
    // 步骤5: 所有权限都失败了
    appPrint('所有权限请求都失败');
    
    // 检查是否有权限被永久拒绝
    final isPermanentlyDenied = primaryStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied;
    
    if (isPermanentlyDenied) {
      // 权限被永久拒绝，引导用户到设置页面
      showToast("需要存储权限才能保存文件，请在设置中授予权限");
      
      // 延迟一下再打开设置，让用户看到提示
      await Future.delayed(Duration(milliseconds: 500));
      openAppSettings();
    } else {
      // 用户拒绝了权限，但不是永久拒绝，提示用户
      showToast("需要存储权限才能保存文件");
    }
    
    return false;
    
  } catch (e) {
    // 如果新权限不支持（低版本Android），直接使用storage权限
    appPrint('权限检查异常，使用storage权限: $e');
    return await checkPermission(Permission.storage);
  }
}
//随机生成id (md5)
String getRandomId() {
  const Uuid uuid = Uuid();

  return uuid.v4();
}

appCopy(String? text){
  Clipboard.setData(ClipboardData(text: text??""));
  showToast("已复制");
}

callPhone(String? phone)async{
  String url = 'tel:' + (phone??"");
  Uri? uri = Uri.tryParse(url.trimLeft());
  if(uri != null) {
    bool ok = await canLaunchUrl(uri);
    if (ok) {
      launchUrl(uri);
    } else {
      showToast('异常，不能拨打电话');
    }
  }
}