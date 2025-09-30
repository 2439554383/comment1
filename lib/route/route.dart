import 'package:comment1/page/ai_page/ai_face/ai_face.dart';
import 'package:comment1/page/home/home.dart';
import 'package:comment1/page/person/personal_center/open_member/open_member.dart';
import 'package:comment1/page/person/personal_center/privacy_policy/privacy_policy.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../overlay_view/overlay_view.dart';
import '../page/ai_page/ai_chat/ai_chat.dart';
import '../page/ai_page/ai_image/ai_image.dart';
import '../page/ai_page/voice_clone/voice_clone.dart';
import '../page/ai_page/voice_extract/voice_extract.dart';
import 'package:comment1/page/ai_page/water_mark/water_mark.dart';
import '../page/ai_page/voice_clone/voice_select/voice_select.dart';
import '../page/home/setting_cue/setting_cue.dart';
import '../page/person/personal_center/account_security/account_security.dart';
import '../page/person/personal_center/distribution/distribution.dart';
import '../page/person/personal_center/exchange/exchange.dart';
import '../page/person/personal_center/personal_center.dart';
import '../page/person/personal_center/recharge_record/recharge_record.dart';
import '../page/person/personal_center/user_account/user_account.dart';
import '../page/person/personal_center/user_information/user_information.dart';
import '../page/person/to_login/to_login.dart';
import '../page/ranking/consume_rank/consume_rank.dart';
import '../page/ranking/recharge_rank/recharge_rank.dart';
import '../page/register/register_data.dart';
import '../page/tab.dart';
import 'package:comment1/page/store/store.dart';
import 'package:comment1/page/ranking/ranking.dart';
import 'package:comment1/page/course/course.dart';
import 'package:comment1/page/login/login.dart';
import 'package:comment1/page/register/register.dart';

class Froute{
  static const String userAccount = '/user_account';
  static const String voiceSelect = '/voice_select';
  static const String rechargeRecord = '/recharge_record';
  static const String exchange = '/exchange';
  static const String userInformation = '/user_information';
  static const String distribution = '/distribution';
  static const String accountSecurity = '/account_security';
  static const String personalCenter = '/personal_center';
  static const String personCenter = '/person_center';
  static const String consumeRank = '/consume_rank';
  static const String rechargeRank = '/recharge_rank';
  static const String registerData = '/register_data';
  static const String announcement = '/announcement';
  static const String news = '/news';
  static const String briefing = '/briefing';
  static const String quotation = '/quotation';
  static const String options = '/options';
  static const String market = '/market';
  static const String toLogin = '/to_login';
  static const String register = '/register';
  static const String login = '/login';
  static const String settingCue = '/setting_cue';
  static const String course = '/course';
  static const String ranking = '/ranking';
  static const String store = '/store';
  static const String overlayView = '/overlay_view';
  static const String aiChat = '/ai_chat';
  static const String waterMark = '/water_mark';
  static const String voiceClone = '/voice_clone';
  static const String aiImage = '/ai_image';
  static const String aiFace = '/ai_face';
  static const String voiceExtract = '/voice_extract';
  static const String home = '/home';
  static const String tabPage = '/tabPage';
  static const String open_member = '/open_member';
  static const String privacy_policy = '/privacy_policy';


  static List<GetPage> getPages = [
    GetPage(name: aiImage, page: () => AiImage()),
    GetPage(name: aiFace, page: () => AiFace()),
    GetPage(name: voiceExtract, page: () => VoiceExtract()),
    GetPage(name: voiceClone, page: () => VoiceClone()),
    GetPage(name: waterMark, page: () => WaterMark()),
    GetPage(name: aiChat, page: () => AiChat()),
    GetPage(name: home, page: () => Home()),
    GetPage(name: overlayView, page: () => OverlayView()),
    GetPage(name: store, page: () => Store()),
    GetPage(name: ranking, page: () => Ranking()),
    GetPage(name: course, page: () => Course()),
    GetPage(name: settingCue, page: () => SettingCue()),
    GetPage(name: login, page: () => Login()),
    GetPage(name: register, page: () => Register()),
    GetPage(name: toLogin, page: () => ToLogin()),
    GetPage(name: registerData, page: () => RegisterData()),
    GetPage(name: rechargeRank, page: () => RechargeRank()),
    GetPage(name: consumeRank, page: () => ConsumeRank()),
    GetPage(name: personalCenter, page: () => PersonalCenter()),
    GetPage(name: accountSecurity, page: () => AccountSecurity()),
    GetPage(name: distribution, page: () => Distribution()),
    GetPage(name: userInformation, page: () => UserInformation()),
    GetPage(name: tabPage, page: () => TabPage()),
    GetPage(name: exchange, page: () => Exchange()),
    GetPage(name: rechargeRecord, page: () => RechargeRecordPage()),
    GetPage(name: voiceSelect, page: () => VoiceSelect()),
    GetPage(name: userAccount, page: () => UserAccount()),
    GetPage(name: open_member, page: () => OpenMember()),
    GetPage(name: privacy_policy, page: () => PrivacyPolicy()),

  ];

  static push(String name,{arguments, Function(dynamic)? result}){
    Get.toNamed(name,arguments: arguments)?.then((value){
      result?.call(value);
    });
  }

  static offAndToNamed(String name,{arguments, Function? result}){
    Get.offAndToNamed(name,arguments: arguments)?.then((value){
      result?.call(value);
    });
  }

  static offAll(String name){
    // Get.offAllNamed(name);
    Get.offNamedUntil(name, (route) => false);
  }
}
