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
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';

import '../../../api/http_api.dart';
import '../../../common/app_component.dart' hide showToast;
import '../../../common/loading.dart';
import '../../../network/apis.dart';
import '../../../network/dio_util.dart';

class VoiceCloneCtrl extends GetxController with GetSingleTickerProviderStateMixin{
  TextEditingController textEditingController = TextEditingController();
  late AnimationController animationController = AnimationController(vsync: this,duration: Duration(seconds: 1));
  late AudioPlayer player = AudioPlayer();
  bool hasData = false;
  File? sourceVoice;
  String? generatedVoiceUrl;
  String? recognitionText;
  String? path ;
  String? url ;
  Future? myFuture;
  Duration? audioDuration;
 bool isComplete = false;
  // 录音状态
  bool isRecording = false;
  bool isFinish = false;
  Duration recordDuration = Duration.zero;
  Timer? recordTimer;
  AudioRecorder? record;
  // 播放状态
  bool isPlaying= false;

  @override
  void onInit() {
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        print("语音结束");
        isPlaying = false;
        isComplete = true;
        player.pause();
        update();
      }
    });
    
    // 检查是否有传递的音频路径参数
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map && arguments.containsKey('audioPath')) {
      final audioPath = arguments['audioPath'] as String?;
      if (audioPath != null && audioPath.isNotEmpty) {
        print('接收到音频路径: $audioPath');
        // 延迟加载音频，确保UI已经初始化完成
        Future.delayed(Duration(milliseconds: 300), () async {
          hasData = false;
          path = audioPath;
          await initPlayer(path!);
          await play();
          update();
        });
      }
    }
    
    super.onInit();
  }

  @override
  void onClose() async {
    // 停止播放（使用 await 确保完全停止）
    try {
      await player.stop();
      await player.pause();
    } catch (e) {
      print('停止播放器时出错: $e');
    }
    player.dispose();
    
    // 停止并清理录音
    recordTimer?.cancel();
    try {
      await record?.stop();
    } catch (e) {
      print('停止录音时出错: $e');
    }
    record?.cancel();
    record?.dispose();
    
    // 停止动画
    animationController.stop();
    animationController.dispose();
    
    // 清除文本控制器
    textEditingController.dispose();
    
    // 重置所有状态变量
    hasData = false;
    sourceVoice = null;
    generatedVoiceUrl = null;
    recognitionText = null;
    path = null;
    url = null;
    myFuture = null;
    audioDuration = null;
    isComplete = false;
    isRecording = false;
    isFinish = false;
    recordDuration = Duration.zero;
    isPlaying = false;
    
    print('✅ 声音克隆页面已清理并重置');
    super.onClose();
  }

  Future<bool> micPermission() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<String> getFilePath() async {
    final dir = await getApplicationDocumentsDirectory(); // 或 getTemporaryDirectory()
    final path = '${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';
    return path;
  }

  void startRecording() async {
    isFinish = false;
    isRecording = true;
    recordDuration = Duration.zero;
    path = null;
    update();
    recordTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordDuration += Duration(seconds: 1);
      update();
    });
    record = AudioRecorder();
    if(!await record!.hasPermission()){
      await micPermission();
    }

    if (await record!.hasPermission()) {
      // Start recording to file
      final filePath =await getFilePath();
      await record!.start(const RecordConfig(), path: filePath);
      // // ... or to stream
      // final stream = await record.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    }
    else{
      await micPermission();
    }
  }

  void stopRecording() async {
    isRecording = false;
    recordTimer?.cancel();
    // Stop recording...
    isFinish = true;
    hasData = false;
    update();
    path = await record!.stop();
    await initPlayer(path!);
    await play();
// ... or cancel it (and implicitly remove file/blob).


    // 这里应该停止实际的录音并保存文件
  }

  void pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );
    if (result != null) {
      hasData = false;
      update();
      path = result.files.single.path;
      await initPlayer(path!);
      await play();
    }
  }
  
  // 从已保存的音频中选择
  Future<void> pickSavedAudio() async {
    // 先停止当前播放
    if (isPlaying) {
      await pause();
    }
    
    // 跳转到音频选择页面，传递 fromVoiceClone 标记
    final result = await Get.toNamed('/voice_select', arguments: {
      'fromVoiceClone': true,
    });
    
    if (result != null && result is String) {
      print('✅ 选择的音频文件: $result');
      hasData = false;
      isFinish = true;
      update();
      path = result;
      await initPlayer(path!);
      await play();
      print('✅ 音频已加载并开始播放');
    } else {
      print('❌ 未选择音频文件');
    }
  }

  initPlayer(String path) async {
    await player.setFilePath(path);
    audioDuration = player.duration;
  }

  initNetPlayer(String url) async {
    await player.setUrl(url);
    audioDuration = player.duration;
  }

  // 播放源音频
  play () async {
    isPlaying = true;
    update();
    await player.play();
    update();
  }

  pause () async {
    isPlaying = false;
    await player.pause();
    update();
  }

  rePlay () async {
    isPlaying = true;
    isComplete = false;
    update();
    await player.seek(Duration.zero);
    await player.play();
  }

  getAudio(BuildContext context,) async {
    final text = textEditingController.text;
    myFuture = postAudio(text,path!);
    FocusScope.of(context).unfocus();
    update();
    await initNetPlayer(await myFuture);
    await play();
  }

  postAudio(String text,String path) async{
    final response = await http_api().post_audio("http://139.196.235.10:8005/comment/post_audio/", text,path);
    if(response!=null){
      hasData = true;
      textEditingController.clear();
      point();
      update();
      url = response;
      return response;
    }
    else{
      return Future.error("error");
    }
  }

  point() async {
    final data = {
      "template_id":1
    };
    final r = await HttpUtil().post(Api.point,data: data);
  }
  dowload () async{
    Loading.show();
    final response = await http.get(Uri.parse(url!));
    final temporary = await getTemporaryDirectory();
    final temporary_path = "${temporary.path}/temp_audio${DateTime.now().millisecondsSinceEpoch}.wav";
    File file = File(temporary_path);
    await file.writeAsBytes(response.bodyBytes);
    
    // 使用兼容不同Android版本的权限请求
    final hasPermission = await checkStoragePermission(type: 'audio');
    if(hasPermission){
      final save_video  = VisionGallerySaver.saveFile(temporary_path);
      save_video.whenComplete(() async{
        showToast("保存成功",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
        await file.delete();
      });
    }
    else{
      print("保存失败");
      showToast("保存失败",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
    }
    Loading.dismiss();
  }

  // 格式化时间
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
