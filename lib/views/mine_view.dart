import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:comment1/view_model/listview_viewmodel.dart';
import 'package:comment1/view_model/mine_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_model/main_gridview_viewmodel.dart';
class mine_view extends StatefulWidget {
  const mine_view({super.key});

  @override
  State<mine_view> createState() => _mine_viewState();
}

class _mine_viewState extends State<mine_view> with TickerProviderStateMixin{
  late AnimationController animationController = AnimationController(vsync: this,duration: Duration(seconds: 1))..repeat(reverse: true);
  late AnimationController animationController1 = AnimationController(vsync: this,duration: Duration(seconds: 1))..forward();
  late AnimationController animationController2 = AnimationController(vsync: this,duration: Duration(milliseconds: 250))..forward();
  late AnimationController animationController3 = AnimationController(vsync: this,duration: Duration(seconds: 1));
  late TextEditingController textEditingController = TextEditingController();
  late mine_viewmodel mine_provider;
  late listview_viewmodel listview_provider;
  double textsize = 15 ;
  double textsize1 = 10 ;
  double ts = 17 ;
  String text1 = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mine_provider = Provider.of<mine_viewmodel>(context,listen: false);
    listview_provider = Provider.of<listview_viewmodel>(context,listen: false);
    Future.delayed(Duration(seconds: 1),(){
      animationController3.forward(from: 0);
    });
    Timer.periodic(Duration(seconds: 6), (time){
      animationController3.forward(from: 0);
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.stop();
    animationController1.stop();
    animationController2.stop();
    animationController.dispose();
    animationController1.dispose();
    animationController2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    late double fullwidth = MediaQuery.of(context).size.width;
    late double fullheight = MediaQuery.of(context).size.height;
    print(fullwidth);
    print(fullheight);
    if(fullwidth<380 || fullheight<700){
      setState(() {
        textsize = 12;
      });
    }
    else{
      setState(() {
        textsize = 17;
      });
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.orangeAccent.withOpacity(0.1),
                  CupertinoColors.secondarySystemBackground
                ],
                begin: Alignment.topCenter,
                end: Alignment(0, 0.5)
            )
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.width*0.95,
            height: double.infinity,
            child: SafeArea(
              child: Column(
                spacing: 30,
                children: [
                  Container(
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(child: Image.asset("assets/images/avatar.png",width: 65,height: 65,fit: BoxFit.cover,),),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text("您的用户名",style: TextStyle(fontSize: 20),)),
                            SizedBox(height: 2,),
                            Container(
                              height: MediaQuery.of(context).size.height*0.035,
                              width: MediaQuery.of(context).size.width*0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Consumer<mine_viewmodel>(
                                builder: (BuildContext context, value, Widget? child) {
                                return !mine_provider.isactive?TextButton(
                                    style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      )),
                                      padding: WidgetStatePropertyAll(EdgeInsets.zero)
                                    ),
                                    onPressed: () {
                                      // Navigator.pushNamed(context, "/open_member");
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return AlertDialog(
                                                title: Text("激活"),
                                                content: TextField(
                                                  autofocus: true,
                                                  controller: textEditingController,
                                                  decoration: InputDecoration(
                                                    hintText: "请输入激活码",
                                                    focusColor: Colors.deepOrange,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 8)
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(onPressed: () async{
                                                    FocusScope.of(context).unfocus();
                                                    Navigator.pop(context);
                                                    bool islogin = await mine_provider.post_active(textEditingController.text);
                                                    if(islogin){
                                                      showToast("激活成功",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));
                                                    }
                                                    final sp = await SharedPreferences.getInstance();
                                                    final code = sp.getString("code");
                                                    if(code!=null){
                                                      print(code);
                                                      await mine_provider.post_code(code);
                                                      await listview_provider.get_list(code);
                                                    }
                                                    else{
                                                      print("code为空");
                                                    }
                                                  }, child: Text('激活')),
                                                  TextButton(onPressed: (){ Navigator.pop(context);}, child: Text('取消')),
                                                ],

                                            );
                                          });
                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // AutoSizeText("未激活"),
                                          AutoSizeText("未开通"),
                                          FittedBox(child: Icon(CupertinoIcons.arrowtriangle_right_fill,size: 15))
                                        ],
                                      ),
                                    )):
                                TextButton(
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero
                                        )),
                                        padding: WidgetStatePropertyAll(EdgeInsets.zero)
                                    ),
                                    onPressed: (){
                                      showToast("你当前已激活",backgroundColor: Colors.black54,position: ToastPosition.bottom,radius: 40,textStyle: TextStyle(color: Colors.white));

                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          AutoSizeText("已激活"),
                                          FittedBox(child: Icon(CupertinoIcons.arrowtriangle_right_fill,size: 15))
                                        ],
                                      ),
                                    ));
                                },
                              ),
                            )
                          ],
                        ),
                        Expanded(child: SizedBox()),
                        AnimatedBuilder(
                          animation: animationController3,
                          builder: (BuildContext context, Widget? child) {
                            return Stack(
                                children: [
                                  ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          stops: [
                                            animationController3.value - 0.1, // 控制光带宽度和位置
                                            animationController3.value,
                                          ],
                                          colors: [
                                            Colors.orange.withOpacity(0.7),
                                            Colors.orange
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },

                                      child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..setEntry(3, 2, 0.001)
                                            ..rotateY( animationController3.value* 2 * 3.1415926),
                                          child: Icon(Icons.shield_moon_rounded,color:Colors.orange,size: 30,))),]
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: animationController3,
                          builder: (BuildContext context, Widget? child) {
                            return RotationTransition(turns: Tween(begin: 0.0,end: 1.0).chain(CurveTween(curve: Curves.elasticOut)).animate(animationController3),
                                child: Icon(CupertinoIcons.game_controller_solid,size: 30));
                          },
                        ),
                        GestureDetector(onTap:(){
                          Navigator.pushNamed(context, "/support_view");
                        },child: Icon(Icons.support_agent_rounded,size: 30,color:Colors.orange,))
                      ],
                    ),
                  ),
                  // DefaultTextStyle(
                  //   style: TextStyle(color: Colors.white),
                  //   child: Container(
                  //     padding: EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(10)),
                  //         color: Color.fromARGB(255, 1, 54, 97)
                  //     ),
                  //     child: Column(
                  //       spacing: 20,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Icon(Icons.workspace_premium_sharp,color: Colors.deepOrange,),
                  //             Text("VIP全新升级"),
                  //             Expanded(child: SizedBox()),
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),)
                  //               ),
                  //               child: TextButton(
                  //                 onPressed:(){},
                  //                 child:Row(
                  //                   children: [
                  //                     Text("立即开通"),
                  //                     Icon(Icons.play_circle,size: 15,)
                  //                   ],
                  //                 ),
                  //                 style: ButtonStyle(
                  //                     fixedSize: WidgetStatePropertyAll(Size(100,20))
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 Text("￥30"),
                  //                 Text("解锁更多功能")
                  //               ],
                  //             ),
                  //             Column(
                  //               children: [
                  //                 Text("￥60"),
                  //                 Text("享受vip特权")
                  //               ],
                  //             ),
                  //             Column(
                  //               children: [
                  //                 Text("￥90"),
                  //                 Text("高级AI生成")
                  //               ],
                  //             ),
                  //             Column(
                  //               children: [
                  //                 Icon(Icons.more,color: Colors.deepOrange,),
                  //                 Text("了解更多特权")
                  //               ],
                  //             ),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Row(
                  //   spacing: 20,
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Icon(Icons.smart_toy),
                  //         Text("AI")
                  //       ],
                  //     ),
                  //     Container(
                  //       height: 15,
                  //       width: 1,
                  //       color: Colors.grey,
                  //     ),
                  //     Row(
                  //       children: [
                  //         Icon(Icons.add_card_rounded),
                  //         Text("卡券")
                  //       ],
                  //     ),
                  //     Container(
                  //       height: 15,
                  //       width: 1,
                  //       color: Colors.grey,
                  //     ),
                  //     Row(
                  //       children: [
                  //         Icon(CupertinoIcons.star_circle_fill),
                  //         Text("金币")
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   width: double.infinity,
                  //   height: 150,
                  //   child: GridView.builder(
                  //       itemCount: 8,
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 4),
                  //       itemBuilder: (context,index){
                  //         return Container(
                  //           child: Column(
                  //             children: [
                  //               main_gridview_viewmodel().iconlist[index],
                  //               Text(main_gridview_viewmodel().textlist[index])
                  //             ],
                  //           ),
                  //         );
                  //       }),
                  // ),
                  // Column(
                  //   children: [
                  //     ExpansionTile(
                  //       iconColor: Colors.orange,
                  //       title: Text("历史评论",),
                  //       leading: Icon(Icons.comment_bank_outlined),
                  //       children: [
                  //         Text("笑出鹅叫声，差点把手机吞了！"),
                  //         SizedBox(height: 10,),
                  //         Text("建议直接出书：《如何优雅地社死》"),
                  //         SizedBox(height: 10,),
                  //       ],
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
