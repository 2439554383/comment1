import 'dart:async';
import 'dart:ui';
import 'package:comment1/view_model/aiitem_viewmodel.dart';
import 'package:comment1/view_model/button_viewmodel.dart';
import 'package:comment1/view_model/content_viewmodel.dart';
import 'package:comment1/view_model/gridview_viewmodel.dart';
import 'package:comment1/view_model/listview_viewmodel.dart';
import 'package:comment1/view_model/mine_viewmodel.dart';
import 'package:comment1/view_model/pageview_viewmodel.dart';
import 'package:comment1/view_model/textfield_viewmodel.dart';
import 'package:comment1/views/ai_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../view_model/mainpage_viewmodel.dart';
import '../view_model/overlay_viewmodel.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
class home_view extends StatefulWidget {
  const home_view({super.key});

  @override
  State<home_view> createState() => _home_viewState();
}

class _home_viewState extends State<home_view> with TickerProviderStateMixin{
  late final physicalHeight = window.physicalSize.height;
  late final overlayHeight = (physicalHeight / 2).toInt();
  AutoSizeGroup myGroup = AutoSizeGroup();
  late AnimationController animationController = AnimationController(vsync: this,duration: Duration(seconds: 1))..repeat(reverse: true);
  late AnimationController animationController2 = AnimationController(vsync: this,duration: Duration(milliseconds: 250))..forward();
  late AnimationController animationController3 = AnimationController(vsync: this,duration: Duration(seconds: 1));
  late button_viewmodel button_provider ;
  late listview_viewmodel listview_provider;
  late overlay_viewmodel overlay_provider;
  late textfield_viewmodel textfield_provider;
  late pageview_viewmodel pageview_provider;
  late gridview_viewmodel gridview_provider;
  late aiitem_viewmodel aiitem_privider;
  late mainpage_viewmodel mainpage_provider ;
  late content_viewmodel content_provider ;
  late mine_viewmodel mine_provider ;
  late PageController pageController = PageController();
  late ScrollController scrollController = ScrollController();
  late Timer timer1 ;
  late Timer timer2 ;
  late Timer timer3;
  double textsize = 15 ;
  double textsize1 = 10 ;
  double ts = 17 ;
  String text1 = "";
  String? code;
  int i = 0;
  getlist()async{
    bool isopen = await FlutterOverlayWindow.isActive();
    print("isopen:$isopen");
    if(isopen){
      print("保持按钮状态成功");
      overlay_provider.open_overlay(false);
      button_provider.switch_button_color(Theme.of(context).primaryColor);
    }
    else{
      overlay_provider.open_overlay(true);
      button_provider.switch_button_color(Colors.grey);
    }
    print("执行");
    final sp = await SharedPreferences.getInstance();
    code = sp.getString("code");
    if(code!=null){
      await mine_provider.post_active(code!);
      await listview_provider.get_list(code!);
      print("code:$code");
    }
    else{
      print("未获得code");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    button_provider = Provider.of<button_viewmodel>(context,listen: false);
    listview_provider = Provider.of<listview_viewmodel>(context,listen: false);
    overlay_provider = Provider.of<overlay_viewmodel>(context,listen: false);
    content_provider = Provider.of<content_viewmodel>(context,listen: false);
    textfield_provider = Provider.of<textfield_viewmodel>(context,listen: false);
    pageview_provider = Provider.of<pageview_viewmodel>(context,listen: false);
    gridview_provider = Provider.of<gridview_viewmodel>(context,listen: false);
    mainpage_provider = Provider.of<mainpage_viewmodel>(context,listen: false);
    aiitem_privider = Provider.of<aiitem_viewmodel>(context,listen: false);
    mine_provider = Provider.of<mine_viewmodel>(context,listen: false);
    timer1 = Timer.periodic(Duration(seconds: 10), (timer){
      i+=1;
      if(i==2){
        i=0;
        pageController.jumpToPage(i);
      }
      else{
        pageController.animateToPage(i, duration: Duration(seconds: 1), curve: Curves.linear);
      }
    });
    Future.delayed(Duration(seconds: 2),(){
      animationController3.forward(from: 0);
    });

    timer2= Timer.periodic(Duration(seconds: 6), (time){
      animationController3.forward(from: 0);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   showDialog(
    //       context: context,
    //       builder: (context){
    //         return AnimatedBuilder(
    //           animation: animationController2,
    //           builder: (BuildContext context, Widget? child) {
    //             return ScaleTransition(
    //               scale: Tween(begin: 0.0,end: 1.0).animate(animationController2),
    //               child: Center(
    //                 child: Container(
    //                     width: 270,
    //                     height: 250,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.all(Radius.circular(10)),
    //                         color: Colors.white
    //                     ),
    //                     child: AnimatedBuilder(
    //                       animation: animationController,
    //                       builder: (BuildContext context, Widget? child) {
    //                         return Stack(
    //                             alignment: Alignment.center,
    //                             children: [
    //                               Container(
    //                                 width: double.infinity,
    //                                 height: double.infinity,
    //                                 child: Image.asset("assets/images/advertisement1.png",fit: BoxFit.cover,),
    //                               ),
    //                               Positioned(
    //                                 bottom: 20,
    //                                 child: ScaleTransition(
    //                                     scale: Tween(begin: 1.2,end: 1.5).animate(animationController),
    //                                     child: TextButton(
    //                                         style:ButtonStyle(
    //                                             fixedSize: WidgetStatePropertyAll(Size(150,40))
    //                                         ),onPressed: (){}, child: Text("立即查看"))),
    //                               ),
    //                               Positioned(child: GestureDetector(onTap: (){Navigator.of(context).pop();},child: Icon(CupertinoIcons.xmark_rectangle_fill,color: Colors.deepOrange,)),top: 10,right: 10,)
    //                             ]
    //                         );
    //                       },
    //                     )
    //                 ),
    //               ),
    //             );
    //           },
    //
    //         );
    //       });
    // });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getlist();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    animationController2.dispose();
    animationController3.dispose();
    pageController.dispose();
    timer1.cancel();
    timer2.cancel();
    // timer3.cancel();
    super.dispose();
  }
  post_size(double height,double height1) async{
    await FlutterOverlayWindow.shareData(
      {'type':"size",
        "size":height,
        "size1":height1
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    late double fullwidth = MediaQuery.sizeOf(context).width;;
    late double fullheight = MediaQuery.sizeOf(context).height;
    final size = MediaQuery.of(context).size; // 逻辑像素（dp）
    final pixelRatio = MediaQuery.of(context).devicePixelRatio; // 像素比
    final logicalWidth = size.width;
    final logicalHeight = size.height;
    final physicalWidth = logicalWidth * pixelRatio;
    final physicalHeight = logicalHeight * pixelRatio;
    double wid = fullwidth*0.4;
    if(physicalHeight<1700){
      wid = fullwidth*0.3;
    }
    post_size(fullheight,physicalHeight);
    print(fullwidth);
    print(fullheight);
    if(fullheight > 620 && fullheight < 700){
      setState(() {
        textsize = 10;
        textsize1 = 10;
        ts = 13;
      });
    }
    else if(fullheight<620){
      setState(() {
        textsize = 8;
        textsize1 = 8;
        ts = 12;
      });
    }
    else{
      setState(() {
        textsize = 13;
        textsize1 = 13;
        ts = 15;
      });
    }
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.5),
                    CupertinoColors.secondarySystemBackground
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment(0, 0)
              )
          ),
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width*0.9,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  spacing: 20,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      spacing: 10,
                      children: [
                        AnimatedBuilder(
                          animation: animationController3,
                          builder: (BuildContext context, Widget? child) {
                            return  Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(animationController3.value* 2 * 3.1415926),
                              child: Container(
                              child: ClipRRect(child: Image.asset("assets/images/appicon.png",width: 60,height: 60,fit: BoxFit.cover,),borderRadius: BorderRadius.circular(25),),
                                                      ),
                            );},
                        ),
                        Text("AI评论员",style: TextStyle(fontSize: 25),)
                      ],
                    ),
                    Container(
                      width: fullwidth,
                      height: 20,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.volume_up),
                          SizedBox(width: 10,),
                          Expanded(child: Marquee(text: "一款基于deep seek一键生成高质量趣评的工具！趣评点击率高会自动置顶，让更多人看到你！"))
                        ],
                      ),
                    ),
                    Consumer<pageview_viewmodel>(
                      builder: (BuildContext context, value, Widget? child) {
                      return Container(
                        height: fullheight*0.18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: PageView.builder(
                          itemCount: pageview_provider.text_list.length,
                            controller: pageController,
                            itemBuilder: (context,index){
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(15),
                              child: AutoSizeText(
                                pageview_provider.text_list[index]
                              )
                            );
                            }),
                      ); },
                    ),
                    Consumer<gridview_viewmodel>(
                      builder: (BuildContext context, value, Widget? child) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                            ),
                            itemCount: gridview_provider.icon_list.length,
                            itemBuilder: (context,index){
                              return IconTheme(
                                data: IconThemeData(
                                  color: Colors.purple[800]
                                ),
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero
                                        ))
                                      ),
                                      onPressed: (){
                                        switch (index){
                                          case 0:
                                            Navigator.pushNamed(context, "/aiface");
                                          case 1:
                                            Navigator.pushNamed(context, "/voice_clone");
                                          case 2:
                                            Navigator.pushNamed(context, "/aiimage");
                                          case 3:
                                            Navigator.pushNamed(context, "/watermark");

                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(child: FittedBox(child:  gridview_provider.icon_list[index],)),
                                          Expanded(child: AutoSizeText(gridview_provider.text_list[index],style: TextStyle(color: Colors.black),maxLines: 1,group: myGroup,minFontSize: 8,))
                                        ],
                                      ))
                                ),
                              );
                            },
                          ),
                      ); },
                    ),

                    Container(
                      height: fullheight*0.1,
                      child: ElevatedButton(
                        onPressed: () {
                          if(mine_provider.isactive){
                          showDialog(
                              context: context,
                              builder: (context){
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    width: fullwidth*0.7,
                                    height: fullheight*0.28,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Consumer<overlay_viewmodel>(
                                          builder: (BuildContext context, value, Widget? child) {
                                            return Container(
                                              width: double.infinity,
                                              height: fullheight*0.07,
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(40)
                                                        )
                                                    ),
                                                    backgroundColor: WidgetStatePropertyAll(button_provider.button_color)
                                                ),
                                                onPressed: () async{
                                                  if(overlay_provider.isoverlay == true){
                                                    getlist();
                                                    final isgranted = await FlutterOverlayWindow.isPermissionGranted();
                                                    if(!isgranted){
                                                      await FlutterOverlayWindow.requestPermission();
                                                      final isgranted1 = await FlutterOverlayWindow.isPermissionGranted();
                                                      if(!isgranted1){
                                                        showDialog(context: context, builder: (context){
                                                          return AlertDialog(
                                                            title: Text("提示"),
                                                            content: Text("请前往系统设置中手动开启“悬浮窗权限"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                FlutterOverlayWindow.requestPermission();
                                                                Navigator.pop(context);
                                                              }, child: Text("前往")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("取消"))
                                                            ],
                                                          );
                                                        });
                                                      }
                                                    }
                                                    else{
                                                      Navigator.pop(context);
                                                      button_provider.switch_button_color(Theme.of(context).primaryColor);
                                                      overlay_provider.open_overlay(false);
                                                      await FlutterOverlayWindow.showOverlay(
                                                          width: 300,
                                                          height: 300,
                                                          enableDrag: false,
                                                          alignment :OverlayAlignment.topRight,
                                                          positionGravity: PositionGravity.auto,
                                                          startPosition: OverlayPosition(0,fullheight * 0.15),
                                                      );
                                                      await FlutterOverlayWindow.shareData({
                                                        "type":"listview",
                                                        "type_overlay_list":listview_provider.type_overlay_list,
                                                      });
                                                    }
                                                  }
                                                  else{
                                                    button_provider.switch_button_color(Colors.grey);
                                                    overlay_provider.open_overlay(true);
                                                    await FlutterOverlayWindow.closeOverlay();
                                                    await FlutterOverlayWindow.shareData({
                                                      "type":"switch_window"
                                                    });
                                                  }
                                                },
                                                child: overlay_provider.isoverlay?Row(
                                                  spacing: 15,
                                                  children: [
                                                    SizedBox(),
                                                    Icon(Icons.block,size: 35,),
                                                    Text("开启悬浮窗",style: TextStyle(fontSize: 20),)
                                                  ],
                                                ):Row(
                                                  spacing: 15,
                                                  children: [
                                                    SizedBox(),
                                                    Icon(CupertinoIcons.checkmark_alt_circle,size: 35,),
                                                    Text("关闭悬浮窗",style: TextStyle(fontSize: 20),)
                                                  ],
                                                ),

                                              ),
                                            );},
                                        ),
                                        SizedBox(height: 20,),
                                        Consumer<button_viewmodel>(
                                          builder: (BuildContext context, value, Widget? child) {
                                            return Container(
                                              height: fullheight*0.07,
                                              child: ElevatedButton(
                                                onPressed: () { Navigator.of(context).pushNamed("/setting_type") ; },
                                                style: ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(40)
                                                        )
                                                    )
                                                ),
                                                child: Row(
                                                  spacing: 15,
                                                  children: [
                                                    SizedBox(),
                                                    Icon(CupertinoIcons.settings_solid,size: 35,),
                                                    Text("设置提示词",style: TextStyle(fontSize: 20),)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });}
                              else{
                            showToast("当前功能需激活后开放，请前往【个人中心】完成激活",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            )
                        ),
                        child: Row(
                          spacing: 15,
                          children: [
                            SizedBox(),
                            Icon(HugeIcons.strokeRoundedComment01,size: 35,),
                            Text("生成趣评",style: TextStyle(fontSize: 22),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: fullheight*0.1,
                      child: ElevatedButton(
                        onPressed: () { Navigator.pushNamed(context, '/chat_view',arguments: {"title":"智能助手","type":"智能助手"});},
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            )
                        ),
                        child: Row(
                          spacing: 15,
                          children: [
                            SizedBox(),
                            Icon(HugeIcons.strokeRoundedAiChat02,size: 35,),
                            Text("智能助手",style: TextStyle(fontSize: 22),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: fullheight*0.1,
                      child: ElevatedButton(
                        onPressed: () {Navigator.of(context).pushNamed("/file_view");},
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            )
                        ),
                        child: Row(
                          spacing: 15,
                          children: [
                            SizedBox(),
                            Icon(Icons.text_snippet_outlined,size: 35,),
                            Text("资料汇总",style: TextStyle(fontSize: 22),)
                          ],
                        ),
                      ),
                    ),


                    // TextButton(
                    //     onPressed: () async{
                    //   const platform = MethodChannel('com.example.message');
                    //   try {
                    //     await platform.invokeMethod('printMessage', {'msg': '你好，Android!'});
                    //   } on PlatformException catch (e) {
                    //     print("发送失败: ${e.message}");
                    //   }
                    // }, child: Text("向原生发送消息")),
                    Column(
                      children: [
                          ...List.generate(aiitem_privider.title_list.length, (index){
                            return ai_item(name: aiitem_privider.title_list[index], describe: aiitem_privider.describe_list[index], icon: aiitem_privider.icon_list[index], type: aiitem_privider.type_list[index],);

                          })
                      ],
                    ),
                    Container(
                      height: fullheight*0.30,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.green,
                              child: Image.asset("assets/images/advertisement4.png",fit: BoxFit.cover,),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              color: Colors.orange,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.red,
                                      child: Image.asset("assets/images/advertisement7.png",fit: BoxFit.cover,),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.pink,
                                      child: Image.asset("assets/images/advertisement3.png",fit: BoxFit.cover,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
