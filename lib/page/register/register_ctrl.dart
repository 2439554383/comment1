import 'package:comment1/network/dio_util.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../common/app_component.dart';
import '../../common/loading.dart';
import '../../network/apis.dart';

class RegisterCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    industryCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  final formKeyRegister = GlobalKey<FormState>();
  late TextEditingController phone = TextEditingController();
  late TextEditingController password = TextEditingController();

  final usernameCtrl = TextEditingController();
  final industryCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final inviteIdCtrl = TextEditingController();
  final formKeyData = GlobalKey<FormState>();

  List<String> industoryList = [
    // 互联网/科技
    "互联网/电子商务",
    "计算机软件",
    "计算机硬件",
    "IT服务/系统集成",
    "网络游戏",
    "移动互联网",
    "电子商务",
    "在线教育",
    "人工智能",
    "大数据",
    "云计算",
    "区块链",
    "物联网",
    "信息安全",

    // 金融/投资
    "银行",
    "证券/基金",
    "保险",
    "投资理财",
    "互联网金融",
    "信托/担保",
    "期货",
    "外汇",

    // 房地产/建筑
    "房地产",
    "建筑/建材/工程",
    "装饰装修",
    "物业管理",
    "建筑设计",
    "园林景观",
    "房地产中介",

    // 制造业
    "机械制造",
    "汽车制造",
    "电子/半导体",
    "化工",
    "纺织/服装",
    "食品/饮料",
    "医药制造",
    "医疗器械",
    "航空航天",
    "船舶制造",
    "钢铁/有色金属",
    "能源/矿产",

    // 贸易/零售
    "贸易/进出口",
    "批发/零售",
    "超市/百货",
    "连锁经营",
    "奢侈品",

    // 服务业
    "餐饮/酒店",
    "旅游/度假",
    "娱乐/休闲",
    "美容/美发",
    "健身/运动",
    "家政服务",
    "物流/仓储",
    "快递",
    "租赁服务",

    // 文化/传媒
    "广告/公关",
    "媒体/出版",
    "影视/娱乐",
    "文化艺术",
    "体育",
    "会展",

    // 教育/培训
    "教育/培训",
    "学术/科研",
    "职业培训",
    "语言培训",
    "艺术培训",

    // 医疗/健康
    "医疗/护理",
    "生物/制药",
    "健康/美容",
    "医疗器械",
    "心理咨询",

    // 能源/环保
    "石油/石化",
    "电力/水利",
    "新能源",
    "环保",
    "节能",

    // 交通/运输
    "航空/航天",
    "铁路/公路",
    "港口/航运",
    "城市交通",

    // 农业/林业
    "农业",
    "林业",
    "渔业",
    "畜牧业",
    "农产品加工",

    // 政府/非营利
    "政府/公共事业",
    "非营利组织",
    "社会团体",
    "基金会",

    // 其他
    "咨询/顾问",
    "法律",
    "会计/审计",
    "人力资源",
    "检测/认证",
    "其他",
  ];

  selectIndustory(String value) {
    industryCtrl.text = value;
    update();
  }

  register() async {
    try{
      Loading.show();
      final data = {
        "phone": phone.text,
        "password":password.text,
        "confirm_password":password.text,
        "username": usernameCtrl.text,   // 用户名 (必填)
        "industry": industryCtrl.text,   // 行业 (可选)
        "city": cityCtrl.text,       // 城市 (可选)
        "invite_code":inviteIdCtrl.text
      };
      final response = await HttpUtil().post(Api.register,data: data);
      print("response = $response");
      print("rawValue = ${response.rawValue}");
      if(response.isSuccess){
        Froute.offAll(Froute.login);
        showToast("注册成功");
        Loading.dismiss();
      }
      else{
        showToast("${response.error!.message}");
        Loading.dismiss();
      }
    }
    catch(e){
      print("e = $e");
      showToast("注册失败");
      Loading.dismiss();
    }
  }
}
