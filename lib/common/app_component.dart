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
  picker.showModal(Get.context!);
}


showToast(String? m){
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: m??"",gravity: ToastGravity.CENTER);
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