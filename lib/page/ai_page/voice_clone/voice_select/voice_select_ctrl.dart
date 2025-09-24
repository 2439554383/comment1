import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class VoiceSelectCtrl extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  final List<String> voiceEffects = [
    "原声", "卡通", "巨人", "眩晕", "心跳", "颤音",
    "恶魔", "哭声", "快进", "慢动作", "机器人", "山脉"
  ];

  int selectedEffectIndex = 0;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration(seconds: 49);

  File? audioFile;
  Timer? positionTimer;

  @override
  void onInit() {
    super.onInit();

    // 监听播放状态
    audioPlayer.playerStateStream.listen((state) {
      isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false;
        position = Duration.zero;
      }
      update();
    });

    // 监听播放位置
    audioPlayer.positionStream.listen((pos) {
      position = pos;
      update();
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    positionTimer?.cancel();
    super.onClose();
  }

  // 选择音效
  void selectEffect(int index) {
    selectedEffectIndex = index;
    update();
    // 这里应该应用音效处理，实际实现需要音频处理库
  }

  // 播放/暂停
  void togglePlayback() async {
    if (audioFile == null) {
      // 如果没有音频文件，使用示例音频或提示用户
      Get.closeAllSnackbars();
      Get.snackbar("提示", "请先选择音频文件");
      return;
    }

    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      if (audioPlayer.processingState == ProcessingState.completed) {
        await audioPlayer.seek(Duration.zero);
      }
      await audioPlayer.play();
    }
    update();
  }

  // 选择音频文件
  void selectAudioFile() async {
    // 这里应该实现文件选择逻辑
    // 由于需要文件选择插件，这里只做演示

    // 模拟选择文件后的操作
    audioFile = File("example_path"); // 实际使用时需要真实路径

    // 设置音频播放器
    try {
      await audioPlayer.setFilePath(audioFile!.path);
      duration = audioPlayer.duration ?? Duration(seconds: 49);
    } catch (e) {
      print("Error setting audio file: $e");
    }

    update();
  }

  // 跳转到指定位置
  void seekToPosition(Duration newPosition) {
    audioPlayer.seek(newPosition);
    update();
  }

  // 格式化时间显示
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}