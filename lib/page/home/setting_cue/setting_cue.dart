import 'package:comment1/page/home/setting_cue/setting_cue_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingCue extends StatelessWidget {
  const SettingCue({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: SettingCueCtrl(),
      builder: (SettingCueCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: Text("评论设置"),
        ),
        body: item1(context, ctrl),
      ),
    );
  }

  Widget item1(BuildContext context, SettingCueCtrl ctrl) {
    return ctrl.hasList?Center(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text("评论类型"),
                          children:
                          List.generate(
                            ctrl.cueList.length, (index) => CheckboxListTile(
                              title: Text(ctrl.cueList[index].name),
                              value: ctrl.cueList[index].isSet,
                              onChanged: (value) async {
                                ctrl.changeStatus();
                            },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                      width:MediaQuery.of(context).size.width*0.27,
                      height:MediaQuery.of(context).size.height*0.07,
                      child: FloatingActionButton(
                        onPressed: () async{
                          ctrl.changeCue();
                          Get.back();
                        },
                        child: Text("确定",style: TextStyle(fontSize: 18),),)),
                  SizedBox(height: 40,)
                ],
              ),
            ]
        ),
      ),
    ):Center(child: CircularProgressIndicator());
  }
}
