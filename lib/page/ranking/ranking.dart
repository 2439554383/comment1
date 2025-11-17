import 'package:comment1/page/ranking/consume_rank/consume_rank.dart';
import 'package:comment1/page/ranking/ranking_ctrl.dart';
import 'package:comment1/page/ranking/recharge_rank/recharge_rank.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Ranking extends StatelessWidget {
  const Ranking({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RankingCtrl>(
      init: RankingCtrl(),
      builder: (ctrl) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/rank_bg.jpg",
                  fit: BoxFit.cover, // 等比裁剪填满
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 15.h),
                  TabBar(
                    padding: EdgeInsets.all(20.r),
                    controller: ctrl.tabController,
                    dividerColor: Colors.transparent,
                    labelStyle: TextStyle(fontSize: 25.sp,color: Colors.white),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.transparent,
                    tabs: [
                      // Container(
                      //     padding: EdgeInsets.all(10.r),
                      //     child: Text("日榜")),
                      Container(
                          padding: EdgeInsets.all(10.r),
                          child: Text("评论数月榜")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: ctrl.tabController,
                      children: [
                        // RechargeRank(),
                        ConsumeRank(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
  Widget _buildTopRankItem({
    required BuildContext context,
    required String name,
    required String likes,
    required int rank,
    required String crown,
    required String avatar,
    required String flag,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // 奖旗背景
        Positioned(
          top: 40.h,
          child: Image.asset(
            flag,
            width: 120.w,
            height: 60.h,
            fit: BoxFit.contain,
          ),
        ),

        // 排名内容
        Container(
          margin: EdgeInsets.only(top: 30.h),
          padding: EdgeInsets.fromLTRB(15.w, 50.h, 15.w, 15.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2.r,
                blurRadius: 5.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            children: [
              // 头像和皇冠
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  // 头像框
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getRankColor(rank),
                        width: 3.w,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        avatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 皇冠
                  Positioned(
                    top: -15.h,
                    child: Image.asset(
                      crown,
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5.h),

              // 点赞数
              Text(
                likes,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildRankItem(BuildContext context, String name, String likes, int rank) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
          // 名称
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 点赞数
          Text(
            likes,
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

  Widget _buildMyRankItem(BuildContext context, String name, String likes, String rank) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
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
              name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 点赞数
          Text(
            "点赞数 $likes",
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