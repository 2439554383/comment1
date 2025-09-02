import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/app_component.dart';
import '../common/color_standard.dart';

class CoinBottomSheet {
  static Future show(BuildContext context,Function onOk) async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CoinWidget(onOk);
        });
  }

  static String  coinTitle(CoinType type) {
    switch(type){
      case CoinType.HKD:
        return '港币';
      case CoinType.CNY:
        return '人民币';
      case CoinType.USD:
        return '美元';
    }
  }

  static String coinImg(CoinType type){
    switch(type){
      case CoinType.HKD:
        return 'hk_ic';
      case CoinType.CNY:
        return 'cny_ic';

      case CoinType.USD:
        return 'usa_ic';
    }
  }
}

class CoinWidget extends StatelessWidget {
  final Function onOK;
  const CoinWidget(this.onOK,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
          ),
          color: Colors.white
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            _item(CoinType.HKD),
            _item(CoinType.USD),
            _item(CoinType.CNY),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
  _item(CoinType item){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        Get.back();
        onOK(item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
        child: Row(
          children: [
            assetAssetImage(CoinBottomSheet.coinImg(item),w: 25.w,h: 25.h),
            SizedBox(width: 10.w,),
            Text(CoinBottomSheet.coinTitle(item),style: TextStyle(fontSize: 14.sp,color: ColorStandard.textColor),),
            Spacer(),
            tradeImage('right_ic',w: 8)
          ],
        ),
      ),
    );
  }
}


enum CoinType{
  HKD,
  CNY,
  USD
}
