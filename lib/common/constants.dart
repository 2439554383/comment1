import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlColors{
  static Color get main => const Color(0xff2E7CBC);

  static const Color ThemeColor = Color(0xffF39800);  //主题色不透明度100%

  static const Color ThemeColor20 = Color(0x33F39800);//不透明度20
  static const Color ThemeColor50 = Color(0x50F39800);//不透明度50

  static const Color TextColor1 = Color(0xff8691A2);

  static const Color backgroundColor1 = Color(0xff28303A);
  static const Color backgroundColor2 = Color(0xff1F252C);

  static const Color bottomBorderColor = Color(0x33EEEEEE);
  static const Color iconHitColor = Color(0xff8691A2);
  static Color getLoopColor(int index){
    List<Color> colors = [Color(0xff73AA81),Color(0xff6652DE),Color(0xff87B4CE),Color(0xff3758FE),Color(0xffF39800),Color(0xffFE6137),Color(0xffC947D1),Color(0xff5283DE),Color(0xff40BD78),Color(0xffD35C32)];
    int length = colors.length;
    return colors[(index + 1) % length];
  }
}