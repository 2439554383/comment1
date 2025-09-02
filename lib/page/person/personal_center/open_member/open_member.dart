import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'open_member_ctrl.dart';

class OpenMember extends StatelessWidget {
  const OpenMember({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OpenMemberCtrl(),
      builder: (OpenMemberCtrl ctrl)=>
       Scaffold(
        appBar: AppBar(
          title: Text("充值"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15.w,right: 15.w),
          child: Column(
            children: [
              SizedBox(height: 30.h,),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          ctrl.currentIndex = 0;
                          ctrl.update();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: ctrl.currentIndex == 0
                                ? Colors.orangeAccent
                                : Colors.blueGrey[50], // 更柔和的未选中背景色
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                  "充值100元",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ctrl.currentIndex == 0 ? Colors.white : Colors.blueGrey[800]
                                  )
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.card_giftcard, size: 16.sp, color: Colors.redAccent[700]),
                                  SizedBox(width: 4.w),
                                  Text(
                                      "赠送10元",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ctrl.currentIndex == 0 ? Colors.white : Colors.redAccent[700]
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                    "总共110元",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ctrl.currentIndex == 0 ? Colors.white : Colors.orange[800]
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          ctrl.currentIndex = 1;
                          ctrl.update();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: ctrl.currentIndex == 1
                                ? Colors.orangeAccent
                                : Colors.blueGrey[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                  "充值300元",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ctrl.currentIndex == 1 ? Colors.white : Colors.blueGrey[800]
                                  )
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.card_giftcard, size: 16.sp, color: Colors.redAccent[700]),
                                  SizedBox(width: 4.w),
                                  Text(
                                      "赠送40元",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ctrl.currentIndex == 1 ? Colors.white : Colors.redAccent[700]
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                    "总共340元",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ctrl.currentIndex == 1 ? Colors.white : Colors.orange[800]
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          ctrl.currentIndex = 2;
                          ctrl.update();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: ctrl.currentIndex == 2
                                ? Colors.orangeAccent
                                : Colors.blueGrey[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                  "充值500元",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ctrl.currentIndex == 2 ? Colors.white : Colors.blueGrey[800]
                                  )
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.card_giftcard, size: 16.sp, color: Colors.redAccent[700]),
                                  SizedBox(width: 4.w),
                                  Text(
                                      "赠送80元",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ctrl.currentIndex == 2 ? Colors.white : Colors.redAccent[700]
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                    "总共580元",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ctrl.currentIndex == 2 ? Colors.white : Colors.orange[800]
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: 50.h,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 100.h,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: Row(
                        children: [
                          ClipRRect(child: Image.asset("assets/images/zfbicon.png",width: 30.w,height: 30.h,fit: BoxFit.cover,),borderRadius: BorderRadius.all(Radius.circular(20.sp)),),
                          SizedBox(width: 8.w,),
                          Text("支付宝",style: TextStyle(fontSize: 18.sp),),
                          Spacer(),
                          Radio(value: 1, groupValue: 1, fillColor: WidgetStatePropertyAll(Colors.orange),onChanged: (ctrl){})
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    Container(
                      height: 100.h,
                      decoration: BoxDecoration(
                          color: CupertinoColors.secondarySystemBackground,
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.question_mark,size: 30.r,color: Colors.blueAccent,),
                          SizedBox(width: 8.w,),
                          Text("敬请期待",style: TextStyle(fontSize: 18.sp),),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey
                                )
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              nextButton(context, ctrl),
              SizedBox(height: 60.h,)
            ],
          ),
        ),
      ),
    );
  }
  nextButton(BuildContext context, OpenMemberCtrl ctrl){
    return Container(
      width: 327.w,
      margin: EdgeInsets.only(left: 24.w,right: 24.h),
      height: 44.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.deepOrange
              ])
      ),
      child: TextButton(
          onPressed: (){
            ctrl.pay();
          },
          child: Text(ctrl.currentIndex==0?"立即支付¥0.01元":ctrl.currentIndex==1?"立即支付¥88元":"立即支付¥158元",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600,color: Colors.white,height: 1),)
      ),
    );
  }
}
