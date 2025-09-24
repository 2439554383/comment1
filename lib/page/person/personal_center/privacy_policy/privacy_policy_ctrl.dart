import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyCtrl extends GetxController {
  final String privacyUrl = "https://www.203166.cn/privacy_policy.html";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 点击跳转隐私网址
  Future<void> openPrivacyUrl() async {
    final Uri uri = Uri.parse(privacyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("错误", "无法打开隐私政策网址");
    }
  }

  List<Map<String, dynamic>> feedbackList = [
    {"title": "功能建议", "image": "assets/personal_center/feedback_function.png"},
    {"title": "产品体验", "image": "assets/personal_center/feedback_experience.png"},
    {"title": "其他问题", "image": "assets/personal_center/feedback_other.png"},
  ];
}
