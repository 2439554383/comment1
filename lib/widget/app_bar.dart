import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/color_standard.dart';

Scaffold xScaffold({
  Widget? body,
  PreferredSize? appBar,
  Widget? floatingActionButton,
  Widget? bottomNavigationBar,
  Color? backgroundColor,
  Widget? flexibleSpace,
}) {
  return Scaffold(
    appBar: appBar,
    backgroundColor: backgroundColor ?? ColorStandard.back,
    body: body,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomNavigationBar,
    resizeToAvoidBottomInset: false,
  );
}

PreferredSize xAppBar({
  Widget? leading,
  dynamic title = '',
  bool? centerTitle,
  Color? bgColor ,
  dynamic actions,
  PreferredSizeWidget? bottom,
  Widget? flexibleSpace,
  double? height,
  Color? titleColor
}) {
  List<Widget>? _actions;
  bgColor ??= Color(0xffF8F8F8);
  if (actions is Widget) {
    _actions = [actions, SizedBox(width: 8,)];
  } else if (actions is Iterable<Widget>) {
    _actions = [...actions, SizedBox(width: 8,)];
  }

  final brightness =
      ThemeData.estimateBrightnessForColor(bgColor ?? Colors.white);
  final indColor = brightness == Brightness.light ? Colors.black : Colors.white;

  Widget? _title;
  Widget? _leading;

  final Color _color = titleColor??( bgColor == ColorStandard.main ? Colors.white : ColorStandard.fontBlack);
  if(leading == null) {
    _leading = IconButton(
      onPressed: () => Get.back(),
      icon: Icon(CupertinoIcons.back, color: _color, size: 25,),
    );
  }else {
    _leading = leading;
  }

  if (title is String) {
    _title = Text(title, style: TextStyle(fontSize: 18.sp,color: _color),);
  } else if (title is Text) {
    _title = title;
  } else if (title is Builder) {
    _title = title;
  } else if (title is Widget) {
    _title = title;
  } else {
    assert(title == null);
  }

  if (_title != null) {
    _title = DefaultTextStyle(
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: indColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      child: _title,
    );
  }

  return PreferredSize(
    preferredSize: Size.fromHeight(height ?? 56),
    child: AppBar(
      actions: _actions,
      title: _title,
      flexibleSpace: flexibleSpace,
      backgroundColor: bgColor ?? ColorStandard.back,
      centerTitle: centerTitle ?? true,
      elevation: 0,
      iconTheme: IconThemeData(color: indColor),
      leading: _leading,
      bottom: bottom,
    ),
  );
}
