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
            "变声器",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // 音效选择网格
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: ctrl.voiceEffects.length,
                  itemBuilder: (context, index) {
                    return _buildEffectItem(context, ctrl, index);
                  },
                ),
              ),

              SizedBox(height: 24.h),

              // 进度条和控制按钮
              _buildPlayerControls(context, ctrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEffectItem(BuildContext context, VoiceSelectCtrl ctrl, int index) {
    final isSelected = ctrl.selectedEffectIndex == index;

    return GestureDetector(
      onTap: () => ctrl.selectEffect(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ) : null,
        ),
        child: Center(
          child: Text(
            ctrl.voiceEffects[index],
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerControls(BuildContext context, VoiceSelectCtrl ctrl) {
    return Column(
      children: [
        // 进度条
        Slider(
          value: ctrl.position.inSeconds.toDouble(),
          min: 0,
          max: ctrl.duration.inSeconds.toDouble(),
          onChanged: (value) {
            ctrl.seekToPosition(Duration(seconds: value.toInt()));
          },
        ),

        SizedBox(height: 8.h),

        // 时间显示
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ctrl.formatDuration(ctrl.position),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                ctrl.formatDuration(ctrl.duration),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // 播放按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 选择文件按钮
            IconButton(
              icon: Icon(Icons.audiotrack, size: 28.sp),
              onPressed: ctrl.selectAudioFile,
              color: Theme.of(context).primaryColor,
            ),

            SizedBox(width: 24.w),

            // 播放/暂停按钮
            GestureDetector(
              onTap: ctrl.togglePlayback,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(
                  ctrl.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}