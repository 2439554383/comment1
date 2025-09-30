import 'package:comment1/network/dio_util.dart';
import 'package:comment1/old_network/dio_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../api/http_api.dart';
import '../../../common/app_component.dart';
import '../../../common/loading.dart';
import '../../../network/apis.dart';
import '../../../old_network/apis.dart';

class VoiceExtractCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  
  // 音频播放器
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  
  // 数据变量
  String? videoUrl;
  String? extractedVoiceUrl;
  String? taskId;
  String? videoTitle;
  String? platform;
  var defaultHint = "粘贴抖音视频链接，提取人声";
  late TextEditingController textEditingController = TextEditingController();
  bool isProcessing = false;
  bool hasExtractedAudio = false;

  // 提取视频人声
  Future<void> extractVoiceFromVideo() async {
    String videoText = textEditingController.text.trim();
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
      
      if (response.data != null && response.data['status'] == true) {
        taskId = response.data['data']['task_id'];
        extractedVoiceUrl = response.data['data']['voice_url'];
        videoTitle = response.data['data']['video_title'];
        platform = response.data['data']['platform'];
        
        if (extractedVoiceUrl != null) {
          hasExtractedAudio = true;
          await _loadAudio(extractedVoiceUrl!);
          point(); // 扣积分
          showToast("人声提取完成");
        } else {
          showToast("人声分离任务已提交，请稍后查询结果");
          // 如果URL为空，可以启动定时查询
          _startPollingForResult();
        }
      } else {
        showToast(response.data?['msg'] ?? "提取失败");
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

  // 播放/暂停音频
  Future<void> togglePlayPause() async {
    if (extractedVoiceUrl == null) {
      showToast("没有可播放的音频");
      return;
    }

    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
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

  // 下载提取的音频
  Future<void> downloadExtractedAudio() async {
    if (extractedVoiceUrl == null) {
      showToast("没有可下载的音频");
      return;
    }

    Loading.show();

    try {
      // 请求存储权限
      final status = await Permission.storage.request();
      
      if (status.isGranted) {
        final response = await http.get(Uri.parse(extractedVoiceUrl!));
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'extracted_voice_${DateTime.now().millisecondsSinceEpoch}.mp3';
        final file = File('${directory.path}/$fileName');
        
        await file.writeAsBytes(response.bodyBytes);
        
        showToast("下载成功: $fileName");
      } else {
        showToast("没有存储权限");
      }
    } catch (e) {
      showToast("下载失败: $e");
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
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${videoTitle ?? "提取的人声"} - 来自AI人声提取',
      );
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
