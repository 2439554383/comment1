import 'dart:io';

import 'package:comment1/api/http_api.dart';
import 'package:comment1/common/app_component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vision_gallery_saver/vision_gallery_saver.dart';


class VoiceCloneCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
  AudioPlayer sourcePlayer = AudioPlayer();
  AudioPlayer generatedPlayer = AudioPlayer();
  late TextEditingController textEditingController = TextEditingController();
  late AudioPlayer audioPlayer;
  ImagePicker imagePicker = ImagePicker();
  Future? myFuture;
  var sourceVoice ;
  var generatedVoice;
  var text;
  var hasdata;
  Widget defaultWidget = Text("您的合成音频");
  play() {
    if(generatedVoice!=null){
      if(generatedPlayer.playerState.processingState == ProcessingState.completed){
        generatedPlayer.seek(Duration.zero);
        generatedPlayer.play();
      }
      else if(generatedPlayer.playerState.playing){
        generatedPlayer.pause();
      }
      else{
        generatedPlayer.play();
      }
    }
  }
  savaFile() async {
    final response = await http.get(Uri.parse(generatedVoice));
    final temporary = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final temporary_path = "${temporary.path}/temp_$timestamp.wav";
    File file = File(temporary_path);
    await file.writeAsBytes(response.bodyBytes);
    final status = await Permission.videos.request();
    if(status.isGranted){
      final save_video  = VisionGallerySaver.saveFile(temporary_path);
      save_video.whenComplete(() async{
        showToast("保存成功");
        await file.delete();
      });
    }
    else{
      print("保存失败");
      showToast("保存失败");
    }
  }
  pickAudio() async{
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp3','wav']
    );
    if(result!=null){
      final path = result.files.single.path;
      File file = File(path!);
      sourceVoice = path;
      update();
      print("获取到音频地址$path");
    }
  }
  clear(){
    defaultWidget = Text("您的合成音频");
  }
  postAudio(var text) async{
    final response = await http_api().post_audio("http://134.175.230.215:8005/comment/post_audio/", text,sourceVoice);
    if(response!=null){
      generatedVoice = response;
      await generatedPlayer.setUrl(generatedVoice);
      update();
      return response;
    }
    else{
      return Future.error("error");
    }
  }
}
