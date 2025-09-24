import 'package:comment1/page/store/store_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: StoreCtrl(),
      builder: (StoreCtrl ctrl) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15.h,),
            item1(context, ctrl),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  Widget item1(BuildContext context, StoreCtrl ctrl) {
    return Center(
        child: Container(
          child: Text("敬请期待",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500,color: Colors.black)),
        )
    );
  }
}
