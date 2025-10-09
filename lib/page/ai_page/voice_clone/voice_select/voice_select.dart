import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/page/ai_page/voice_clone/voice_select/voice_select_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoiceSelect extends StatelessWidget {
  const VoiceSelect({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder<VoiceSelectCtrl>(
      init: VoiceSelectCtrl(),
      builder: (ctrl) => Scaffold(
        appBar: AppBar(
          title: Text(
            "提取的人声",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          actions: [
            // 刷新按钮
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => ctrl.refreshAudioList(),
              tooltip: "刷新列表",
            ),
            // 确认选择按钮
            TextButton(
              onPressed: () => ctrl.confirmSelection(),
              child: Text(
                "使用",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              // 音频文件列表
              Expanded(
                child: ctrl.audioFiles.isEmpty
                    ? _buildEmptyState(context)
                    : _buildAudioList(context, ctrl),
              ),
              
              // 播放控制器
              _buildPlayerControls(context, ctrl),
            ],
          ),
        ),
      ),
    );
  }

  // 空状态显示
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 60.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 15.h),
          AutoSizeText(
            "暂无提取的人声",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 8.h),
          AutoSizeText(
            "提取视频人声后会自动保存到这里",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // 音频文件列表
  Widget _buildAudioList(BuildContext context, VoiceSelectCtrl ctrl) {
    return ListView.builder(
      padding: EdgeInsets.all(15.w),
      itemCount: ctrl.audioFiles.length,
      itemBuilder: (context, index) {
        return _buildAudioItem(context, ctrl, index);
      },
    );
  }

  // 音频文件项
  Widget _buildAudioItem(BuildContext context, VoiceSelectCtrl ctrl, int index) {
    final isSelected = ctrl.selectedAudioIndex == index;
    final filePath = ctrl.audioFiles[index];
    final fileName = ctrl.getFileName(filePath);
    final fileTime = ctrl.getFileTime(filePath);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => ctrl.selectAudio(index),
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                // 音频图标
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.audiotrack,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                    size: 24.sp,
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // 文件信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        fileName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          AutoSizeText(
                            fileTime,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 正在播放指示器或删除按钮
                if (isSelected && ctrl.isPlaying)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.volume_up,
                          size: 14.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        AutoSizeText(
                          "播放中",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.grey.shade500,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text("确认删除"),
                          content: Text("确定要删除这个音频文件吗？"),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text("取消"),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                ctrl.deleteAudio(index);
                              },
                              child: Text(
                                "删除",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 播放控制器
  Widget _buildPlayerControls(BuildContext context, VoiceSelectCtrl ctrl) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 进度条（使用 ProgressBar 和 StreamBuilder，与 voice_clone 一致）
            StreamBuilder<Duration>(
              stream: ctrl.audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = ctrl.duration;
                return ProgressBar(
                  progress: position,
                  total: duration,
                  onSeek: (newPosition) {
                    ctrl.audioPlayer.seek(newPosition);
                  },
                );
              },
            ),
            
            SizedBox(height: 15.h),
            
            // 播放按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 停止按钮
                GestureDetector(
                  onTap: ctrl.stopPlayback,
                  child: Container(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                    ),
                    child: Icon(
                      Icons.stop,
                      color: Colors.grey.shade700,
                      size: 22.sp,
                    ),
                  ),
                ),
                
                SizedBox(width: 30.w),
                
                // 播放/暂停按钮
                GestureDetector(
                  onTap: ctrl.togglePlayback,
                  child: Container(
                    width: 65.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ctrl.audioFiles.isEmpty 
                          ? Colors.grey.shade300
                          : Theme.of(context).primaryColor,
                      boxShadow: ctrl.audioFiles.isEmpty 
                          ? []
                          : [
                              BoxShadow(
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                    ),
                    child: Icon(
                      ctrl.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 35.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
