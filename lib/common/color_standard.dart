
import 'package:flutter/material.dart';

class ColorStandard {
  ColorStandard._();


  static Color get textColor => const Color(0xff1D2129);


  static Color get color232529 => const Color(0xff232529);

  static Color get main => const Color(0xff304FFF);
  static Color get main_blue => const Color.fromRGBO(93, 209, 255, 1);
  static Color get select_bgcolor => const Color.fromRGBO(247, 248, 255, 1);
  static Color get hitText => const Color(0xff777777);

  static Color get colorCBCBCB=> const Color(0xffCBCBCB);
  static Color get colorFF1D1D=> const Color(0xffFF1D1D);
  static Color get color24BB82 => const Color(0xff24BB82 );

  // static Color get main => Colors.blueAccent;

  // static Color get minor => Colors.orange[700]!;

  static Color get minor => const Color(0xffff7f00);

  static Color get blue => Colors.lightBlue;

  static Color get red => Colors.pink[600]!;

  static Color get fontBlack => const Color(0xff262A34);

  static Color get fontGrey => const Color(0xff999999);

  static Color get fontGrey2 => const Color(0xff65676A);

  static Color get buttonGrey => Colors.grey[200]!;

  static Color get divColor => Colors.grey[300]!;

  static Color get back => Colors.white;

  static Color get back2 => const Color(0xffF4F5F7);

  static Color get back3 => const Color(0xffe9e9e9);

  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: const Color(0xff000000).withOpacity(0.03),
      offset: const Offset(0.5, 0.5),
      blurRadius: 5,
    )
  ];

  static Color eleColor(String? key){


    switch(key?.toLowerCase()){
      case 'success': return Color(0xff67C23A);
      case 'warning': return Color(0xffE6A23C);
      case 'danger': return Color(0xffF56C6C);
      case 'info': return Color(0xff909399);
      case 'brand': return Color(0xff409EFF);
    }
    return main;
  }
}
