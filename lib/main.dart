import 'package:comment1/overlay_view/overlay_view.dart';
import 'package:comment1/page/tab.dart';
import 'package:comment1/route/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common/app_preferences.dart';
import 'data/user_data.dart';
import 'network/dio_util.dart';

main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppPreferences.init();
    HttpUtil().init();
    await UserData().init();

    runApp(
        OKToast(
          child: ScreenUtilInit(
            designSize: Size(411, 915),
            minTextAdapt: true,
            splitScreenMode: true,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: Froute.tabPage,
              builder: EasyLoading.init(builder: (context, widget){
                return MediaQuery(
                  //设置文字大小不随系统设置改变
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              }),
              getPages: Froute.getPages,
              theme: ThemeData.light().copyWith(
                  scaffoldBackgroundColor:Colors.white,
                  appBarTheme: AppBarTheme(
                    backgroundColor: Color.fromARGB(255, 248, 248, 248),
                  ),
                  // textButtonTheme: TextButtonThemeData(
                  //     style: ButtonStyle(
                  //         foregroundColor: WidgetStatePropertyAll(Colors.white),
                  //         backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
                  //         textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white))
                  //     )
                  // ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
                          foregroundColor: WidgetStatePropertyAll(Colors.white)
                      )
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.transparent,
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: Colors.orange,
                      unselectedLabelStyle: TextStyle(color: Colors.black),
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0
                  )
              ),
                title: "comment",
                home: TabPage(),
              ),
          ),
        ),
      );

}

@pragma("vm:entry-point")
void overlayMain() async{
  runApp(
      OKToast(
        child: ScreenUtilInit(
          designSize: Size(411, 915),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
              theme: ThemeData.light().copyWith(
                  scaffoldBackgroundColor:    CupertinoColors.tertiarySystemGroupedBackground,
                  textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(ThemeData.light().primaryColor),
                          textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white))
                      )
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange),
                          foregroundColor: WidgetStatePropertyAll(Colors.white)
                      )
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.transparent,
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: Colors.orange,
                      unselectedLabelStyle: TextStyle(color: Colors.black),
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0
                  )
              ),
            home: OverlayView()
          ),
        ),
      ),
  );
}