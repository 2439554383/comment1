import 'package:get/get.dart';

import '../../../network/apis.dart';
import '../../../network/dio_util.dart';

class ConsumeRankCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getRankingList();
  }

  @override
  void dispose() {
    super.dispose();
  }
  getRankingList() async {
    final response = await HttpUtil().get(Api.monthRanking);
  }
}
