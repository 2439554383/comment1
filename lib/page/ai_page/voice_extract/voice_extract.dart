import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/app_component.dart';
import '../../../data/user_data.dart';
import 'voice_extract_ctrl.dart';

class VoiceExtract extends StatelessWidget {
  const VoiceExtract({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: VoiceExtractCtrl(),
      builder: (VoiceExtractCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: AutoSizeText("人声提取"),
          actions: [
            if (ctrl.hasExtractedAudio)
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => ctrl.shareToWeChat(),
                tooltip: "分享到微信",
              ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 0, bottom: 0),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              videoInputCard(context, ctrl),
              SizedBox(height: 15.h),
              audioPreviewCard(context, ctrl),
              SizedBox(height: 15.h),
              actionButtons(context, ctrl),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // 视频链接输入卡片
  Widget videoInputCard(BuildContext context, VoiceExtractCtrl ctrl) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey5,
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.video_library,
                color: Theme.of(context).primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              AutoSizeText(
                "粘贴视频链接",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: ctrl.textEditingController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: ctrl.defaultHint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15.w),
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.sp,
                ),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange,
                size: 16.sp,
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: AutoSizeText(
                  "支持抖音、快手等短视频平台的链接",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 音频预览卡片
  Widget audioPreviewCard(BuildContext context, VoiceExtractCtrl ctrl) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey5,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "提取结果",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (ctrl.hasExtractedAudio)
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "内容由AI提取",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: Center(
                child: _buildPreviewContent(context, ctrl),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContent(BuildContext context, VoiceExtractCtrl ctrl) {
    if (ctrl.isProcessing) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          SizedBox(height: 15.h),
          AutoSizeText(
            "正在提取人声...",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          AutoSizeText(
            "请稍候，这可能需要几分钟",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      );
    } else if (ctrl.hasExtractedAudio) {
      return Column(
        children: [
          // 视频信息
          if (ctrl.videoTitle != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "视频标题",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AutoSizeText(
                    ctrl.videoTitle!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
          ],
          
          // 音频播放器
          Expanded(child: _buildAudioPlayer(context, ctrl)),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.record_voice_over,
            size: 60.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 15.h),
          AutoSizeText(
            "「提取的人声将在这里显示」",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 8.h),
          AutoSizeText(
            "粘贴视频链接后点击开始提取",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      );
    }
  }

  // 音频播放器组件
  Widget _buildAudioPlayer(BuildContext context, VoiceExtractCtrl ctrl) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // 播放控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => ctrl.stopAudio(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.stop,
                    color: Colors.grey.shade600,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  print(ctrl.isComplete);
                  if(ctrl.isPlaying && ctrl.isComplete==false){
                    ctrl.pause();
                  }
                  else if(!ctrl.isPlaying && ctrl.isComplete==false){
                    ctrl.play();
                  }
                  else{
                    ctrl.rePlay();
                  }
                },
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ctrl.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // 使用 ProgressBar 进度条（和 voice_clone 一样）
          StreamBuilder<Duration>(
            stream: ctrl.audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = ctrl.audioDuration ?? Duration.zero;
              return ProgressBar(
                progress: position,
                total: duration,
                onSeek: (newPosition) {
                  ctrl.audioPlayer.seek(newPosition);
                },
              );
            },
          ),
          
          SizedBox(height: 20.h),
          
          // 下载按钮
          if (ctrl.hasExtractedAudio) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.download,
                  label: "下载",
                  onTap: () => ctrl.dowload(),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.share,
                  label: "分享",
                  onTap: () => ctrl.shareToWeChat(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18.sp,
            ),
            SizedBox(width: 5.w),
            AutoSizeText(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 操作按钮
  Widget actionButtons(BuildContext context, VoiceExtractCtrl ctrl) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              ctrl.resetAll();
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Center(
                child: AutoSizeText(
                  "重新开始",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (UserData().isLogin) {
                String videoText = ctrl.textEditingController.text.trim();
                if (videoText.isEmpty) {
                  showToast("请输入视频链接");
                  return;
                }
                await ctrl.extractVoiceFromVideo();
              } else {
                showToast("请您先登录");
              }
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (ctrl.isProcessing) ...[
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ] else
                      Icon(
                        Icons.auto_fix_high,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    SizedBox(width: 8.w),
                    AutoSizeText(
                      ctrl.isProcessing ? "提取中..." : "开始提取",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
