import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/page/ai_page/voice_clone/voice_clone_ctrl.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
class VoiceClone extends StatelessWidget {
  const VoiceClone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VoiceCloneCtrl(),
      builder: (VoiceCloneCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: Text("声音克隆"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Text(
                "上传语音",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),

              // 录音/上传区域
              _buildUploadSection(context, ctrl),
              SizedBox(height: 24.h),

              // 识别文本
              _buildRecognitionText(ctrl),
              SizedBox(height: 24.h),

              // 生成区域
              _buildGenerateSection(context, ctrl),
              SizedBox(height: 24.h),

              // 上传本地音频按钮
              _buildUploadLocalAudio(context, ctrl),
              Spacer(),

              // 生成按钮
              _buildGenerateButton(context, ctrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, VoiceCloneCtrl ctrl) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 时间显示
          Text(
            ctrl.isRecording ?
            "${ctrl.recordDuration.inMinutes}:${(ctrl.recordDuration.inSeconds % 60).toString().padLeft(2, '0')}" :
            "0:00",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          // 录音按钮
          GestureDetector(
            onLongPress: ctrl.startRecording,
            onLongPressUp: ctrl.stopRecording,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: Icon(
                ctrl.isRecording ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 36.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          Text(
            ctrl.isRecording ? "松开结束录制" : "长按录制语音",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionText(VoiceCloneCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "记录文本",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),

        // 复选框和提示
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                "语音内容与识别文本高度匹配，可降低生成的机器人出现卡顿、音字等情况。",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // 时间标记和文本
        if (ctrl.recognitionText != null) ...[
          Row(
            children: [
              Text("0:00", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  ctrl.recognitionText ?? "",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text("0:05", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              SizedBox(width: 8.w),
              Text(
                "就算钥匙真的万一跑进了双层口袋里面去的话，也应该只有钥匙环。",
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ] else ...[
          Text(
            "录制或上传语音后，识别文本将显示在这里",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildGenerateSection(BuildContext context, VoiceCloneCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "试听语音",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),

        if (ctrl.sourceVoice != null)
          _buildAudioPlayer(context, ctrl, true),
        SizedBox(height: 12.h),

        if (ctrl.generatedVoiceUrl != null)
          _buildAudioPlayer(context, ctrl, false),

        if (ctrl.sourceVoice == null && ctrl.generatedVoiceUrl == null)
          Text(
            "上传语音样本或生成语音后，可以在这里试听",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildAudioPlayer(BuildContext context, VoiceCloneCtrl ctrl, bool isSource) {
    final isPlaying = isSource ? ctrl.isSourcePlaying : ctrl.isGeneratedPlaying;
    final audioUrl = isSource ? ctrl.sourceVoice?.path : ctrl.generatedVoiceUrl;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 播放按钮
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: isSource ? ctrl.playSource : ctrl.playGenerated,
          ),
          SizedBox(width: 12.w),

          // 进度条
          Expanded(
            child: StreamBuilder<Duration>(
              stream: isSource ?
              ctrl.sourcePlayer.positionStream :
              ctrl.generatedPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = isSource ?
                (ctrl.audioDuration ?? Duration.zero) :
                (ctrl.generatedPlayer.duration ?? Duration.zero);

                return ProgressBar(
                  progress: position,
                  total: duration,
                  onSeek: (newPosition) {
                    if (isSource) {
                      ctrl.sourcePlayer.seek(newPosition);
                    } else {
                      ctrl.generatedPlayer.seek(newPosition);
                    }
                  },
                );
              },
            ),
          ),

          if (!isSource) ...[
            SizedBox(width: 12.w),
            // 下载按钮
            IconButton(
              icon: Icon(Icons.download),
              onPressed: ctrl.saveGeneratedAudio,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUploadLocalAudio(BuildContext context, VoiceCloneCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "上传本地音频",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),

        Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                "请上传清晰、单人声音、音频无其它杂音，否则会影响机器人生成的质量。",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: (){
                  ctrl.pickAudio();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("选择本地音频文件"),
              ),
            ),
            SizedBox(width: 20.w,),
            Expanded(
              child: OutlinedButton(
                onPressed: (){
                  // ctrl.pickAudio();
                  Froute.push(Froute.voiceSelect);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("选择多样化音效"),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context, VoiceCloneCtrl ctrl) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (ctrl.textEditingController.text.isNotEmpty) {
            ctrl.myFuture = ctrl.generateVoice(ctrl.textEditingController.text);
            ctrl.update();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "开始生成",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}