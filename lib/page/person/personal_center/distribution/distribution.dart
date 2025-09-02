import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/color_standard.dart';
import '../../../../widget/no_data_widget.dart';
import 'distribution_ctrl.dart';
class Distribution extends StatelessWidget {
  const Distribution({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DistributionCtrl(),
      builder: (DistributionCtrl ctrl)=>
          Scaffold(
            appBar: AppBar(
              title: AutoSizeText("分销中心"),
            ),
            body: Container(
              padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 0,bottom: 0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 9.h,),
                  baseInformation(context,ctrl),
                  SizedBox(height: 20.h,),
                  titleTile(context,ctrl),
                  SizedBox(height: 15.h,),
                  invatationRecord(context,ctrl),
                  SizedBox(height: 20.h,),
                  // operateItem(context,ctrl),
                  // SizedBox(height: 17.h,),
                ],
              ),
            ),
          ),
    );
  }

  baseInformation(BuildContext context, DistributionCtrl ctrl){
    return Container(
      height: 152.h,
      padding: EdgeInsets.only(bottom: 5.h,left: 5.w,right: 5.w),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 136, 2, 1.0),
              Color.fromRGBO(255, 183, 0, 1.0)
            ]
        )
      ),
      child: Column(
        children: [
          SizedBox(height: 19.h,),
          Container(
            padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 0,bottom: 0),
            child:Row(
              children: [
                GestureDetector(
                    onTap: (){

                    },
                    child: Image.asset("assets/images/avatar.png",width:60.w ,height: 60.h,fit: BoxFit.cover,)),
                SizedBox(width: 10.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text("用户名：${ctrl.userInfo?.nickname??"--"}",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,color: Color.fromRGBO(255, 255, 255, 1))),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                          ctrl.copyInviteCode();
                      },
                      child: Row(
                        children: [
                          Text("邀请码：${ctrl.userInfo?.inviteCode??"--"}",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,color: Color.fromRGBO(255, 255, 255, 1))),
                          SizedBox(width: 5.w,),
                          Image.asset("assets/images/copy.png",width:14.w ,height: 15.h,color: Colors.white,)
                        ],
                      ),
                    ),
                    // Text("分销详情",style: TextStyle(fontSize: 16.sp,decoration: TextDecoration.underline,decorationColor:Colors.white,fontWeight: FontWeight.w600,color: Color.fromRGBO(255, 255, 255, 1))),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Color.fromRGBO(255, 255, 255, 0.2)
                  ),
                  alignment: Alignment.center,
                  child: Text("已获佣金：${ctrl.distributionInfo?.totalCommission??0}",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.white)),
                )
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 52.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                color: Color.fromRGBO(245, 252, 255, 1)
            ),
            alignment: Alignment.center,
            child: Text("已邀请人数  ${ctrl.distributionInfo?.invitedUsersCount ?? 0}",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(37, 38, 38, 1))),
          )
        ],
      ),
    );
  }

  titleTile(BuildContext context, DistributionCtrl ctrl){
    return  Text("分销记录",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Color.fromRGBO(37, 38, 38, 1)));
  }

  invatationRecord(BuildContext context, DistributionCtrl ctrl) {
    return  Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            border: Border.all(
                color: Color.fromRGBO(230, 230, 230, 1)
            )
        ),
        child: ctrl.invitationList.isNotEmpty?SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(ctrl.invitationList.length, (index) =>
                  userItem(ctrl,index)
              )
            ],
          ),
        ):Center(child: NoDataWidget(title: "暂无分销记录",)),
      ),
    );
  }

  userItem(DistributionCtrl ctrl, int index) {
    return Container(
        padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 16.h,bottom: 0),
        child:Column(
          children: [
            Container(
              child: Row(
                children: [
                  // GestureDetector(
                  //     onTap: (){
                  //       // FRoute.push(FRoute.personalInformation);
                  //     },
                  //     child: Image.asset("assets/images/avatar.png",width:35.w ,height: 35.h,fit: BoxFit.cover,)),
                  // SizedBox(width: 10.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(ctrl.invitationList[index].invitedUser?.nickname ?? "--",style: TextStyle(fontSize: 12.sp,height: 1,fontWeight: FontWeight.w400,color: ColorStandard.fontBlack)),
                      SizedBox(height: 8.h,),
                      Text(ctrl.invitationList[index].createdAt ?? "--",style: TextStyle(fontSize: 12.sp,height: 1,fontWeight: FontWeight.w400,color: ColorStandard.hitText)),
                    ],
                  ),
                  Spacer(),
                  Text("${ctrl.invitationList[index].amount ??"--"}",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color:ColorStandard.fontBlack))
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            Divider(height: 1,)
          ],
        )
    );
  }

  operateItem(BuildContext context, DistributionCtrl ctrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 39.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                    color: ColorStandard.colorCBCBCB
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("生成分销链接",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: ColorStandard.fontBlack)),
          
              ],
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: GestureDetector(
            onTap: (){
              // FRoute.push(FRoute.poster);
            },
            child: Container(
              height: 39.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                      colors: [
                        Colors.orangeAccent,
                        Colors.deepOrange
                      ])
              ),
              child: Text("生成分销海报",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.white) ),
            ),
          ),
        )
      ],
    );
  }


}
