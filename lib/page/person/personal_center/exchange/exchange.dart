import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'exchange_ctrl.dart';

class Exchange extends StatelessWidget {
  const Exchange({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: ExchangeCtrl(),
      builder: (ExchangeCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: const Text("兑换"),
          centerTitle: true,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 切换兑换模式
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.merge_type, color: Colors.orange,size: 20.r,),
                        SizedBox(width: 8.w),
                        Text("兑换类型",style: TextStyle(fontSize: 14.sp),),
                      ],
                    ),
                    Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color:Colors.orange,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "余额兑换",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color:Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // 可用额度（积分 or 余额）
              Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.orange,size: 20.r,),
                        SizedBox(width: 8.w),
                        Text("可用余额",style: TextStyle(fontSize: 14.sp),),
                      ],
                    ),
                    Text(
                      "${ctrl.availableBalance} 元",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // 输入兑换额度
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("兑换积分",style: TextStyle(fontSize: 14.sp),),
                    SizedBox(
                      width: 120.w,
                      child: TextField(
                        controller: ctrl.amountCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入",
                        ),
                        onChanged: (val) {
                          ctrl.updateAmount(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // 兑换说明
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("兑换说明",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),
                    SizedBox(height: 8.h),
                    Text("1. 使用余额兑换积分",style: TextStyle(fontSize: 12.sp),),
                    Text("2. 兑换成功后无法退回。",style: TextStyle(fontSize: 12.sp),),
                    Text("3. 兑换额度不可大于可用额度。",style: TextStyle(fontSize: 12.sp),),
                  ],
                ),
              ),
              const Spacer(),
              nextButton(context, ctrl),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF6F6F6),
      ),
    );
  }

  nextButton(BuildContext context, ExchangeCtrl ctrl) {
    return Container(
      width: 327.w,
      margin: EdgeInsets.only(left: 24.w, right: 24.h),
      height: 44.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
      ),
      child: TextButton(
        onPressed: () {
          ctrl.confirmExchange();
        },
        child: Text(
          "确认兑换",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
