import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAgreementCtrl extends GetxController {
  final String agreementUrl = "https://www.203166.cn/user_agreement.html";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 点击跳转用户协议网址
  Future<void> openAgreementUrl() async {
    final Uri uri = Uri.parse(agreementUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("错误", "无法打开用户协议网址");
    }
  }
}

