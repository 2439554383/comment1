import 'package:comment1/model/rank/month_rank.dart';
import 'package:comment1/model/rank/rank_item.dart';
import 'package:get/get.dart';

import '../../../network/apis.dart';
import '../../../network/dio_util.dart';

class ConsumeRankCtrl extends GetxController {
  List<LeaderboardItem> monthList = [];
  LeaderboardResponse leaderboardResponse = LeaderboardResponse();
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
    if(response.isSuccess){
      leaderboardResponse = LeaderboardResponse.fromJson(response.rawValue ?? {}) ;
      monthList = LeaderboardItem.fromJsonList(response.rawValue?['leaderboard'] ?? []);
    }
    update();
  }
}
