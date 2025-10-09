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
    super.onInit();
  }

  @override
  void onClose() {
    player.dispose();
    recordTimer?.cancel();
    record!.cancel();
    record!.dispose();
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
    final result = await Get.toNamed('/voice_select');
    if (result != null && result is String) {
      print('选择的音频文件: $result');
      hasData = false;
      update();
      path = result;
      await initPlayer(path!);
      await play();
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
