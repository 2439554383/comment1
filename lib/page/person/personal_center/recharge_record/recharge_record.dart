import 'package:comment1/widget/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'recharge_record_ctrl.dart';

class RechargeRecordPage extends StatelessWidget {
  const RechargeRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RechargeRecordCtrl(),
      builder: (RechargeRecordCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: const Text("充值记录"),
          centerTitle: true,
        ),
        body: ctrl.itemList.isNotEmpty?Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(15.w),
            itemCount: ctrl.itemList.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = ctrl.itemList[index];
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "充值方式：${item.paymentMethod}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "到账时间：${ctrl.formatDate(item.createdAt) ?? "--"}",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "￥${item.amount?.toStringAsFixed(2) ?? '0.00'}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "${item.status=="pending"?"未完成":"已完成"}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ):Center(child: NoDataWidget(title:"暂无充值记录",)),
      ),
    );
  }
}
