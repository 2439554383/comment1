import 'package:comment1/network/dio_util.dart';
import 'package:comment1/old_network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';
import 'dart:io';
import 'dart:convert';

import '../../../api/http_api.dart';
import '../../../common/app_component.dart';
import '../../../common/loading.dart';
import '../../../network/apis.dart';
import '../../../old_network/apis.dart';
import '../voice_clone/voice_select/voice_select.dart';

class VoiceExtractCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    
    // 监听播放状态
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        print("语音结束");
        isPlaying = false;
        isComplete = true;
        audioPlayer.pause();
        update();
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // 音频播放器
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isComplete = false;
  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;

  // 数据变量
  String? videoUrl;
  String? extractedVoiceUrl;
  String? taskId;
  String? videoTitle;
  String? platform;
  String? localAudioPath; // 本地音频文件路径
  var defaultHint = "粘贴抖音视频链接，提取人声";
  late TextEditingController textEditingController = TextEditingController();
  bool isProcessing = false;
  bool hasExtractedAudio = false;

  // 提取视频人声
  Future<void> extractVoiceFromVideo() async {
    String videoText = textEditingController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();

    if (videoText.isEmpty) {
      showToast("请输入视频链接");
      return;
    }

    isProcessing = true;
    update();

    try {
      final data = {
        "text": videoText,
        "language": "zh"
      };

      // 调用后端API提取人声
      final response = await OldHttpUtil().post(OldApi.extractVoiceFromVideo, data: data);

      // 打印调试信息
      print('响应数据类型: ${response.data.runtimeType}');
      print('响应数据: ${response.data}');

      // 处理响应数据
      dynamic responseData = response.data;

      if (response.isSuccess) {
        taskId = responseData['task_id'];
        extractedVoiceUrl = responseData['voice_url'];
        videoTitle = responseData['video_title'];
        platform = responseData['platform'];

        print('提取到的 voice_url: $extractedVoiceUrl');

        if (extractedVoiceUrl != null && extractedVoiceUrl!.isNotEmpty) {
          hasExtractedAudio = true;
          point(); // 扣积分

          // // 自动下载音频到本地并永久保存
          // await _downloadAndSaveAudio();

          // 加载音频供预览
          await _loadAudio(extractedVoiceUrl!);
          
          showToast("人声提取完成");
          
          // 不再自动跳转，用户可以在这里预览或继续提取
        } else {
          showToast("人声分离任务已提交，请稍后查询结果");
          // 如果URL为空，可以启动定时查询
          _startPollingForResult();
        }
      } else {
        final errorMsg = response.message ?? "提取失败";
        showToast(errorMsg);
        print('提取失败: $errorMsg');
      }
    } catch (e) {
      showToast("提取失败: $e");
    } finally {
      isProcessing = false;
      update();
    }
  }

  // 加载音频文件
  Future<void> _loadAudio(String audioUrl) async {
    try {
      await audioPlayer.setUrl(audioUrl);
      audioDuration = audioPlayer.duration ?? Duration.zero;
      
      // 监听播放状态
      audioPlayer.playerStateStream.listen((state) {
        isPlaying = state.playing;
        update();
      });
      
      // 监听播放进度
      audioPlayer.positionStream.listen((position) {
        currentPosition = position;
        update();
      });
      
      update();
    } catch (e) {
      print("加载音频失败: $e");
    }
  }

  // 轮询查询结果
  Future<void> _startPollingForResult() async {
    if (taskId == null) return;
    
    // 这里可以添加轮询逻辑，定期查询任务状态
    // 为了简化，这里只是示例
    Future.delayed(Duration(seconds: 10), () {
      // 模拟查询结果
      if (taskId != null) {
        _queryTaskResult();
      }
    });
  }

  // 查询任务结果
  Future<void> _queryTaskResult() async {
    if (taskId == null) return;
    
    try {
      // 这里应该调用查询任务结果的API
      // 示例实现
      showToast("正在查询提取结果...");
    } catch (e) {
      print("查询任务结果失败: $e");
    }
  }

  // 扣积分
  point() async {
    final data = {
      "template_id": 3 // 人声提取的模板ID
    };
    final r = await HttpUtil().post(Api.point, data: data);
  }
  
  // 下载并保存音频到本地
  Future<void> _downloadAndSaveAudio() async {
    if (extractedVoiceUrl == null || extractedVoiceUrl!.isEmpty) {
      print('extractedVoiceUrl 为空，无法下载');
      return;
    }
    
    try {
      Loading.show();
      
      print('开始下载音频: $extractedVoiceUrl');
      
      // 下载音频文件
      final response = await http.get(Uri.parse(extractedVoiceUrl!));
      
      if (response.statusCode != 200) {
        throw Exception('下载失败，状态码: ${response.statusCode}');
      }
      
      print('音频下载成功，大小: ${response.bodyBytes.length} 字节');
      
      // 获取应用文档目录
      final directory = await getApplicationDocumentsDirectory();
      print('应用目录: ${directory.path}');
      
      // 创建voices文件夹
      final voicesDir = Directory('${directory.path}/voices');
      if (!await voicesDir.exists()) {
        await voicesDir.create(recursive: true);
        print('创建voices文件夹: ${voicesDir.path}');
      }
      
      // 生成文件名（使用视频标题+时间戳）
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      String sanitizedTitle = videoTitle ?? 'voice';
      // 移除特殊字符
      sanitizedTitle = sanitizedTitle.replaceAll(RegExp(r'[^\u4e00-\u9fa5a-zA-Z0-9\s-]'), '');
      // 限制长度
      if (sanitizedTitle.length > 20) {
        sanitizedTitle = sanitizedTitle.substring(0, 20);
      }
      if (sanitizedTitle.isEmpty) {
        sanitizedTitle = 'voice';
      }
      
      final fileName = '${sanitizedTitle}_$timestamp.mp3';
      print('文件名: $fileName');
      
      // 保存文件
      final file = File('${voicesDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      
      // 验证文件是否存在
      if (await file.exists()) {
        localAudioPath = file.path;
        final fileSize = await file.length();
        print('✅ 音频已成功保存到: $localAudioPath');
        print('✅ 文件大小: $fileSize 字节');
      } else {
        throw Exception('文件保存失败');
      }
      
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      print('❌ 下载音频失败: $e');
      showToast('保存音频失败');
      rethrow;
    }
  }
  
  // 跳转到语音选择页面
  void _navigateToVoiceSelect() async {
    if (localAudioPath == null) return;
    
    // 获取所有已保存的音频文件
    final directory = await getApplicationDocumentsDirectory();
    final voicesDir = Directory('${directory.path}/voices');
    
    List<String> audioFiles = [];
    if (await voicesDir.exists()) {
      final files = voicesDir.listSync();
      audioFiles = files
          .where((file) => file.path.endsWith('.mp3'))
          .map((file) => file.path)
          .toList();
      
      // 按修改时间排序，最新的在前面
      audioFiles.sort((a, b) {
        final aFile = File(a);
        final bFile = File(b);
        return bFile.lastModifiedSync().compareTo(aFile.lastModifiedSync());
      });
    }
    
    // 跳转到语音选择页面，传递音频文件列表
    Get.to(() => const VoiceSelect(), arguments: {
      'audioFiles': audioFiles,
      'currentAudioPath': localAudioPath,
    });
  }

  // 播放音频
  play() async {
    isPlaying = true;
    update();
    await audioPlayer.play();
    update();
  }

  // 暂停音频
  pause() async {
    isPlaying = false;
    await audioPlayer.pause();
    update();
  }

  // 重新播放
  rePlay() async {
    isPlaying = true;
    isComplete = false;
    update();
    await audioPlayer.seek(Duration.zero);
    await audioPlayer.play();
  }

  // 播放/暂停音频（保留兼容）
  Future<void> togglePlayPause() async {
    if (extractedVoiceUrl == null) {
      showToast("没有可播放的音频");
      return;
    }

    try {
      if (isPlaying) {
        await pause();
      } else {
        await play();
      }
    } catch (e) {
      showToast("播放失败: $e");
    }
  }

  // 停止播放
  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
      currentPosition = Duration.zero;
      update();
    } catch (e) {
      print("停止播放失败: $e");
    }
  }

  // 跳转到指定位置
  Future<void> seekTo(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e) {
      print("跳转失败: $e");
    }
  }

  dowload () async{
    Loading.show();
    final response = await http.get(Uri.parse(extractedVoiceUrl!));
    final temporary = await getTemporaryDirectory();
    final temporary_path = "${temporary.path}/temp_audio${DateTime.now().millisecondsSinceEpoch}.wav";
    File file = File(temporary_path);
    await file.writeAsBytes(response.bodyBytes);

    // 使用兼容不同Android版本的权限请求
    final hasPermission = await checkStoragePermission(type: 'audio');
    if(hasPermission){
      final save_video  = VisionGallerySaver.saveFile(temporary_path);
      save_video.whenComplete(() async{
        showToast("保存成功");
        await file.delete();
      });
    }
    else{
      print("保存失败");

    }
    Loading.dismiss();
  }

  // 分享音频到微信
  Future<void> shareToWeChat() async {
    if (extractedVoiceUrl == null) {
      showToast("没有可分享的音频");
      return;
    }

    try {
      // 先下载音频到本地
      Loading.show();
      final response = await http.get(Uri.parse(extractedVoiceUrl!));
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'extracted_voice_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      
      Loading.dismiss();
      
      // 分享文件
      // await Share.shareXFiles(
      //   [XFile(file.path)],
      //   text: '${videoTitle ?? "提取的人声"} - 来自AI人声提取',
      // );
    } catch (e) {
      Loading.dismiss();
      showToast("分享失败: $e");
    }
  }

  // 重置所有状态
  void resetAll() {
    textEditingController.clear();
    videoUrl = null;
    extractedVoiceUrl = null;
    taskId = null;
    videoTitle = null;
    platform = null;
    isProcessing = false;
    hasExtractedAudio = false;
    isPlaying = false;
    audioDuration = Duration.zero;
    currentPosition = Duration.zero;
    audioPlayer.stop();
    update();
  }

  // 格式化时间
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
