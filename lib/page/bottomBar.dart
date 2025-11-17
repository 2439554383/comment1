// 底部导航栏
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/app_component.dart';
import '../common/color_standard.dart';

class BottomBar extends BottomAppBar {
  BottomBar({this.callback, required this.currentIndex});
  final int currentIndex;
  final callback;
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                widget.callback(0);
              },
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.home),
                    Text(
                      '首页',
                      style: TextStyle(
                          color: widget.currentIndex == 0
                              ? ColorStandard.main
                              : Color(0xff777777),
                          fontSize: 12.sp
                      ),
                    ),
                  ]),
            ),
          ),
          Expanded(
              child: TextButton(
                onPressed: () {
                  widget.callback(1);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.golf_course),
                    Text(
                      '教程',
                      style: TextStyle(
                          color: widget.currentIndex == 1
                              ? ColorStandard.main
                              : Color(0xff777777),
                          fontSize: 12.sp
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: TextButton(
              onPressed: () {
                widget.callback(2);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.store),
                  Text(
                    '商城',
                    style: TextStyle(
                        color: widget.currentIndex == 2
                            ? ColorStandard.main
                            : Color(0xff777777),
                        fontSize: 12.sp
                    ),
                  ),
                ],
              ),
            ),),
          Expanded(
            child: TextButton(
              onPressed: () {
                widget.callback(3);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.leaderboard),
                  Text(
                    '排行',
                    style: TextStyle(
                        color: widget.currentIndex == 3
                            ? ColorStandard.main
                            : Color(0xff777777),
                        fontSize: 12.sp
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                widget.callback(4);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.person),
                  Text(
                    '我的',
                    style: TextStyle(
                        color: widget.currentIndex == 4
                            ? ColorStandard.main
                            : Color(0xff777777),
                        fontSize: 12.sp
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
