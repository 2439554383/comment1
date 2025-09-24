import 'package:comment1/data/user_data.dart';
import 'package:comment1/page/ranking/recharge_rank/recharge_rank_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'consume_rank_ctrl.dart';

class ConsumeRank extends StatelessWidget {
  const ConsumeRank({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsumeRankCtrl>(
      init: ConsumeRankCtrl(),
      builder: (ctrl) => Scaffold(
        backgroundColor: Colors.transparent,
        body: ctrl.monthList.isNotEmpty?Container(
          padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 0,bottom: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10.w,
                  children: [
                    ...List.generate(ctrl.monthList.sublist(0,3).toList().length, (index){
                      final item = ctrl.monthList[index];
                      return  _buildTopRankItem(
                        context: context,
                        name: "${item.nickname}",
                        rank: item.rank!,
                        avatar: item.rank==1?"assets/images/1.png":item.rank==2?"assets/images/2.png":"assets/images/3.png", // 头像
                        money: item.rank==1?"${ctrl.leaderboardResponse.rewardInfo!.firstPlace?.toStringAsFixed(0)}":item.rank==2?"${ctrl.leaderboardResponse.rewardInfo!.secondPlace?.toStringAsFixed(0)}":"${ctrl.leaderboardResponse.rewardInfo!.thirdPlace?.toStringAsFixed(0)}"
                      );
                    })
                  ],
                ),
                SizedBox(height: 15.h),
                ...List.generate(ctrl.monthList.sublist(4).toList().length, (index){
                  final item = ctrl.monthList[index];
                  return _buildRankItem(context, "${item.nickname}", item.rank!,item.totalComments!);
                }).expand((e)=>[e,SizedBox(height: 15.h,)]).toList(),
                // 分隔线
                Divider(height: 1.h, thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 20.h),

                // 我的排名部分
                 _buildMyRankItem(context, "${UserData().userResponse.userInfo?.nickname ??"--"}", "${ctrl.leaderboardResponse.currentUserStats?.totalComments ?? "0"}", "${ctrl.leaderboardResponse.currentUserRank ?? "--"}"),
                // 底部提示文字
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                  child: Text(
                    "排名更新存在延时，请耐心等待自动更新 😊",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }
  Widget _buildTopRankItem({
    required BuildContext context,
    required String name,
    required int rank,
    required String avatar,
    required String money,
  }) {
    return Expanded(
      child: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 排名内容
            Container(
              padding: EdgeInsets.fromLTRB(15.w, 30.h, 15.w, 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text("${money.toString()}元",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.orange)),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  // 头像和皇冠
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // 头像框
                      Container(

                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   border: Border.all(
                        //     color: _getRankColor(rank),
                        //     width: 3.w,
                        //   ),
                        // ),
                        child: Image.asset(
                          avatar,
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 皇冠
                      // Positioned(
                      //   top: -15.h,
                      //   child: Image.asset(
                      //     crown,
                      //     width: 40.w,
                      //     height: 40.h,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // 排名文字
                  Text(
                    "TOP $rank",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: _getRankColor(rank),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  // 名称
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child:Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r)),
                  ),
                  child: Text("奖励",style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w500,color: Colors.orange)),
                )
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRankItem(BuildContext context, String name,int rank ,int totalComments) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 排名序号
          Container(
            width: 30.w,
            alignment: Alignment.center,
            child: Text(
              "TOP $rank",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: _getRankColor(rank),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Text(
            name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          // 名称
          Spacer(),
          Text(
            "${totalComments}",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildMyRankItem(BuildContext context, String name, String likes, String rank) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 排名序号
          Container(
            width: 30.w,
            alignment: Alignment.centerLeft,
            child: Text(
              "我的排行",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Container(
            width: 30.w,
            alignment: Alignment.centerLeft,
            child: Text(
              rank,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          // 名称
          Expanded(
            child: Text(
              "${name}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 点赞数
          Text(
            "$likes",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      default:
        return Colors.grey;
    }
  }
}