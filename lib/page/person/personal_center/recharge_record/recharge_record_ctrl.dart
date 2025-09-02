import 'package:comment1/common/app_component.dart';
import 'package:get/get.dart';

import '../../../../model/person/recharge_recoed.dart';
import '../../../../network/apis.dart';
import '../../../../network/dio_util.dart';

class RechargeRecordCtrl extends GetxController {
  List<RechargeRecord> itemList = [];

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    try {
      final response = await HttpUtil().get(Api.rechargeRecord);
      if(response.isSuccess){
        final resp = RechargeResponse.fromJson(response.rawValue);
        itemList = resp.records ?? [];
        update();
        print("itemList${itemList}");
      }
      else{
        showToast(response.error?.message);
      }
    } catch (e) {
      print("fetchRecords error: $e");
    }
  }
}
