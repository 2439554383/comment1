import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

class VoiceCloneCtrl extends GetxController {
  TextEditingController textEditingController = TextEditingController();
  AudioPlayer sourcePlayer = AudioPlayer();
  AudioPlayer generatedPlayer = AudioPlayer();

  File? sourceVoice;
  String? generatedVoiceUrl;
  String? recognitionText;

  Future? myFuture;
  Duration? audioDuration;

  // 录音状态
  bool isRecording = false;
  Duration recordDuration = Duration.zero;
  Timer? recordTimer;

  // 播放状态
  bool isSourcePlaying = false;
  bool isGeneratedPlaying = false;

  @override
  void onInit() {
    super.onInit();
    generatedPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isGeneratedPlaying = false;
        update();
      }
    });
  }

  @override
  void onClose() {
    sourcePlayer.dispose();
    generatedPlayer.dispose();
    recordTimer?.cancel();
    super.onClose();
  }

  // 开始录音
  void startRecording() async {
    isRecording = true;
    recordDuration = Duration.zero;
    update();

    recordTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordDuration += Duration(seconds: 1);
      update();
    });

    // 这里应该调用实际的录音功能
    // 由于录音需要特定插件，这里只做UI演示
  }

  // 停止录音
  void stopRecording() {
    isRecording = false;
    recordTimer?.cancel();
    update();

    // 这里应该停止实际的录音并保存文件
  }

  // 上传本地音频
  void pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );

    if (result != null) {
      final path = result.files.single.path;
      if (path != null) {
        sourceVoice = File(path);

        // 获取音频时长
        try {
          await sourcePlayer.setFilePath(path);
          audioDuration = sourcePlayer.duration;
        } catch (e) {
          print("Error getting audio duration: $e");
        }

        update();
      }
    }
  }

  // 播放源音频
  void playSource() async {
    if (sourceVoice == null) return;

    if (isSourcePlaying) {
      await sourcePlayer.pause();
      isSourcePlaying = false;
    } else {
      await sourcePlayer.seek(Duration.zero);
      await sourcePlayer.play();
      isSourcePlaying = true;
    }
    update();
  }

  // 播放生成的音频
  void playGenerated() async {
    if (generatedVoiceUrl == null) return;

    if (isGeneratedPlaying) {
      await generatedPlayer.pause();
      isGeneratedPlaying = false;
    } else {
      if (generatedPlayer.processingState == ProcessingState.completed) {
        await generatedPlayer.seek(Duration.zero);
      }
      await generatedPlayer.play();
      isGeneratedPlaying = true;
    }
    update();
  }

  // 生成语音
  Future<String?> generateVoice(String text) async {
    if (sourceVoice == null) {
      Get.snackbar("提示", "请先上传语音样本");
      return null;
    }

    if (text.isEmpty) {
      Get.snackbar("提示", "请输入要克隆的文本");
      return null;
    }

    try {
      // 这里应该是实际的API调用
      // 模拟网络请求延迟
      await Future.delayed(Duration(seconds: 2));

      // 模拟返回的音频URL
      return "https://example.com/generated_voice.wav";
    } catch (e) {
      print("Error generating voice: $e");
      return null;
    }
  }

  // 保存生成的音频
  void saveGeneratedAudio() async {
    if (generatedVoiceUrl == null) return;

    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar("提示", "需要存储权限才能保存音频");
        return;
      }

      // 这里应该是实际的下载和保存逻辑
      Get.snackbar("成功", "音频已保存到相册");
    } catch (e) {
      print("Error saving audio: $e");
      Get.snackbar("错误", "保存失败");
    }
  }

  // 格式化时间
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
