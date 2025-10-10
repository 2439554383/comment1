import 'dart:async';
import 'dart:io';

import 'package:comment1/common/app_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VoiceSelectCtrl extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  // 音频文件列表
  List<String> audioFiles = [];
  int selectedAudioIndex = 0;
  String? currentAudioPath;

  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

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
    
    // 监听时长
    audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration = dur;
        update();
      }
    });
    
    // 加载本地保存的所有音频文件
    _loadLocalAudioFiles();
  }
  
  // 从本地目录加载所有音频文件
  Future<void> _loadLocalAudioFiles() async {
    try {
      print('开始加载本地音频文件...');
      
      // 获取应用文档目录
      final directory = await getApplicationDocumentsDirectory();
      final voicesDir = Directory('${directory.path}/voices');
      
      print('voices目录路径: ${voicesDir.path}');
      
      if (!await voicesDir.exists()) {
        print('voices目录不存在，创建中...');
        await voicesDir.create(recursive: true);
        audioFiles = [];
        update();
        return;
      }
      
      // 读取目录中的所有mp3文件
      final files = voicesDir.listSync();
      audioFiles = files
          .where((file) => file is File && file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
      
      print('找到 ${audioFiles.length} 个音频文件');
      
      // 按修改时间排序，最新的在前面
      audioFiles.sort((a, b) {
        final aFile = File(a);
        final bFile = File(b);
        return bFile.lastModifiedSync().compareTo(aFile.lastModifiedSync());
      });
      
      // 接收传递的参数（如果有的话）
      final arguments = Get.arguments;
      if (arguments != null && arguments is Map) {
        currentAudioPath = arguments['currentAudioPath'];
        
        // 找到当前音频的索引
        if (currentAudioPath != null && audioFiles.contains(currentAudioPath)) {
          final index = audioFiles.indexOf(currentAudioPath!);
          if (index != -1) {
            selectedAudioIndex = index;
          }
        }
      }
      
      // 如果有音频文件，加载第一个
      if (audioFiles.isNotEmpty) {
        await _loadAudioFile(audioFiles[selectedAudioIndex]);
      }
      
      update();
    } catch (e) {
      print('加载本地音频文件失败: $e');
      audioFiles = [];
      update();
    }
  }

  @override
  void onClose() async {
    // 停止播放（使用 await 确保完全停止）
    try {
      await audioPlayer.stop();
      await audioPlayer.pause();
    } catch (e) {
      print('停止播放器时出错: $e');
    }
    audioPlayer.dispose();
    
    // 取消定时器
    positionTimer?.cancel();
    
    // 重置所有状态变量
    audioFiles.clear();
    selectedAudioIndex = 0;
    currentAudioPath = null;
    isPlaying = false;
    position = Duration.zero;
    duration = Duration.zero;
    
    print('✅ 音频选择页面已清理并重置');
    super.onClose();
  }

  // 加载音频文件
  Future<void> _loadAudioFile(String filePath) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.setFilePath(filePath);
      currentAudioPath = filePath;
      position = Duration.zero;
      isPlaying = false;
      print('已加载音频: $filePath');
      print('时长: ${duration.inSeconds}秒');
      update();
    } catch (e) {
      print("加载音频文件失败: $e");
      showToast("加载音频文件失败");
    }
  }

  // 选择音频文件
  void selectAudio(int index) async {
    if (index < 0 || index >= audioFiles.length) return;
    
    print('选择音频索引: $index');
    selectedAudioIndex = index;
    update(); // 立即更新UI显示选中状态
    await _loadAudioFile(audioFiles[index]);
  }

  // 播放/暂停
  void togglePlayback() async {
    if (audioFiles.isEmpty || currentAudioPath == null) {
      showToast("没有可播放的音频文件");
      return;
    }

    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        if (audioPlayer.processingState == ProcessingState.completed) {
          await audioPlayer.seek(Duration.zero);
        }
        await audioPlayer.play();
      }
    } catch (e) {
      print("播放失败: $e");
      showToast("播放失败");
    }
  }
  
  // 停止播放
  stopPlayback() async {
    await audioPlayer.stop();
    position = Duration.zero;
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
  
  // 获取文件名（不含路径和扩展名）
  String getFileName(String filePath) {
    final fileName = path.basename(filePath);
    return fileName.replaceAll('.mp3', '');
  }
  
  // 获取文件创建时间
  String getFileTime(String filePath) {
    try {
      final file = File(filePath);
      final modified = file.lastModifiedSync();
      return '${modified.month}/${modified.day} ${modified.hour}:${modified.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
  
  // 删除音频文件
  Future<void> deleteAudio(int index) async {
    if (index < 0 || index >= audioFiles.length) return;
    
    try {
      final filePath = audioFiles[index];
      final file = File(filePath);
      
      // 如果正在播放这个文件，先停止
      if (selectedAudioIndex == index) {
        await stopPlayback();
      }
      
      // 删除文件
      if (await file.exists()) {
        await file.delete();
      }
      
      // 从列表中移除
      audioFiles.removeAt(index);
      
      // 调整选中的索引
      if (selectedAudioIndex >= audioFiles.length && audioFiles.isNotEmpty) {
        selectedAudioIndex = audioFiles.length - 1;
        await _loadAudioFile(audioFiles[selectedAudioIndex]);
      } else if (audioFiles.isEmpty) {
        currentAudioPath = null;
        await audioPlayer.stop();
      }
      
      update();
      showToast("音频已删除");
    } catch (e) {
      print("删除文件失败: $e");
      showToast("删除文件失败");
    }
  }
  
  // 确认选择当前音频并返回或跳转
  void confirmSelection() async {
    // 先停止播放
    if (isPlaying) {
      await audioPlayer.pause();
      isPlaying = false;
      update();
    }
    
    if (audioFiles.isEmpty || currentAudioPath == null) {
      showToast("请先选择一个音频文件");
      return;
    }
    
    // 检查是否有来源参数
    final arguments = Get.arguments;
    
    // 如果是从声音克隆页面跳转来的（通过 pickSavedAudio），直接返回结果
    if (arguments != null && arguments is Map && arguments.containsKey('fromVoiceClone')) {
      print('返回到声音克隆页面，音频路径: $currentAudioPath');
      Get.back(result: currentAudioPath);
    } else {
      // 否则，打开新的声音克隆页面
      print('跳转到新的声音克隆页面，音频路径: $currentAudioPath');
      Get.toNamed('/voice_clone', arguments: {
        'audioPath': currentAudioPath,
      });
    }
  }
  
  // 刷新音频列表
  Future<void> refreshAudioList() async {
    await _loadLocalAudioFiles();
  }
}