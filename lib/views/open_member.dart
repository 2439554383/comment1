import 'package:comment1/view_model/openmember_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class open_member extends StatefulWidget {
  const open_member({super.key});

  @override
  State<open_member> createState() => _open_memberState();
}

class _open_memberState extends State<open_member> {
  @override
  Widget build(BuildContext context) {
    double full_width = MediaQuery.of(context).size.width;
    double full_height = MediaQuery.of(context).size.height;
    double padding_width = full_width-30;
    double padding_height = MediaQuery.of(context).size.height;
    double body_height = MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-kToolbarHeight;
    return ChangeNotifierProvider(
      create: (BuildContext context)=> openmember_viewmodel(),
      child: Consumer<openmember_viewmodel>(
        builder: (BuildContext context, value, Widget? child)=>
         Scaffold(
          appBar: AppBar(
            title: Text("会员"),
            centerTitle: true,
          ),
          body: Container(
            height: body_height,
            padding: EdgeInsets.only(left: 15.w,right: 15.w),
            child: Column(
              children: [
                SizedBox(height: 10.h,),
                Container(
                  width: padding_width,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            value.current_index = 0 ;
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color:value.current_index == 0?Colors.orangeAccent:Colors.grey.withOpacity(0.5)
                            ),
                            child: Column(
                              children: [
                                Text("包月会员",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("解锁所有权限",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("30元/月",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            value.current_index = 1 ;
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:value.current_index == 1?Colors.orangeAccent:Colors.grey.withOpacity(0.5)
                            ),
                            child: Column(
                              children: [
                                Text("季度会员",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("解锁所有权限",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("88元/三个月",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            value.current_index = 2 ;
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:value.current_index == 2?Colors.orangeAccent:Colors.grey.withOpacity(0.5)
                            ),
                            child: Column(
                              children: [
                                Text("包年会员",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("解锁所有权限",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("158元/年",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            value.current_index = 3 ;
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color:value.current_index == 3?Colors.orangeAccent:Colors.grey.withOpacity(0.5)
                            ),
                            child: Column(
                              children: [
                                Text("包月会员",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("解锁所有权限",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Colors.white),),
                                SizedBox(height: 10.h,),
                                Text("0.01元/月",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Container(
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
                            Radio(value: 1, groupValue: 1, fillColor: WidgetStatePropertyAll(Colors.orange),onChanged: (value){})
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            SizedBox(width: 30.w,),
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
                TextButton(
                    onPressed: (){
                        value.pay();
                    },
                    style: ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(300.w, 60.h))
                    ),
                    child: Text(value.current_index==0?"立即支付¥30元":value.current_index==1?"立即支付¥88元":value.current_index==2?"立即支付¥158元":"立即支付¥0.01元",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600),)
                ),
                SizedBox(height: 60.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
