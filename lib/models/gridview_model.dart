import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
class gridview_model{
  List icon_list = [
    Icon(Icons.face, size: 30, color: Colors.deepPurpleAccent.shade200),
    Icon(CupertinoIcons.heart, size: 30, color: Colors.pinkAccent.shade200),
    Icon(Icons.image, size: 30, color: Colors.deepPurple.shade500),
    Icon(HugeIcons.strokeRoundedPpt01, size: 30, color: Colors.indigoAccent.shade200),
    Icon(Icons.video_call_outlined, size: 30, color: Colors.amberAccent.shade200),
    Icon(Icons.water_drop, size: 30, color: Colors.purple.shade400),
    Icon(Icons.monochrome_photos, size: 30, color: Colors.deepPurple.shade400),
    Icon(Icons.settings_voice_rounded, size: 30, color: Colors.blueGrey.shade500),
  ];
  List text_list = [
    "Ai换脸",
    "情感伴侣",
    "Ai生图",
    "PPT生成",
    "Ai视频",
    "去水印",
    "Ai写真",
    "智能配音",
  ];
}