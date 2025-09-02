import 'package:comment1/page/ranking/recharge_rank/recharge_rank_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RechargeRank extends StatelessWidget {
  const RechargeRank({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeRankCtrl>(
      init: RechargeRankCtrl(),
      builder: (ctrl) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10.w,
                children: [
                  _buildTopRankItem(
                    context: context,
                    name: "数据_00000...",
                    likes: "372",
                    rank: 2,
                    crown: "assets/silver_crown.png", // 银冠图标
                    avatar: "assets/avatar2.png", // 头像
                    flag: "assets/silver_flag.png", // 银牌旗帜
                  ),
                  // TOP 1 - 金牌
                  _buildTopRankItem(
                    context: context,
                    name: "搜索",
                    likes: "463",
                    rank: 1,
                    crown: "assets/gold_crown.png", // 金冠图标
                    avatar: "assets/avatar1.png", // 头像
                    flag: "assets/gold_flag.png", // 金牌旗帜
                  ),
                  // TOP 3 - 铜牌
                  _buildTopRankItem(
                    context: context,
                    name: "星日女孩",
                    likes: "295",
                    rank: 3,
                    crown: "assets/bronze_crown.png", // 铜冠图标
                    avatar: "assets/avatar3.png", // 头像
                    flag: "assets/bronze_flag.png", // 铜牌旗帜
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              _buildRankItem(context, "宝友748769190", "64", 4),
              SizedBox(height: 15.h),
              _buildRankItem(context, "宝友840348154", "46", 5),
              SizedBox(height: 15.h),
              _buildRankItem(context, "冉冉_000000206", "40", 6),
              SizedBox(height: 15.h),
              _buildRankItem(context, "梦庭_000000040", "39", 7),
              SizedBox(height: 20.h),

              // 分隔线
              Divider(height: 1.h, thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 20.h),

              // 我的排名部分
              _buildMyRankItem(context, "我的昵称", "我的点赞数", "我的排名"),

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
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.fromLTRB(15.w, 50.h, 15.w, 15.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
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