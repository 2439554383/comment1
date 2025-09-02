import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/app_component.dart';
import '../common/color_standard.dart';
class FDateTimePicker extends StatefulWidget {
  final Function onOK;
 const FDateTimePicker(this.onOK,{super.key});
  static Future show(BuildContext context,Function onOk) async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FDateTimePicker(onOk);
        });
  }

  @override
  State<FDateTimePicker> createState() => _FDateTimePickerState();
}

class _FDateTimePickerState extends State<FDateTimePicker> {

  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  late String startData ,endData ;

  bool isStart = true;
  final List<int> years = [2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025];
  final List<int> months = List.generate(12, (index) => index + 1);
  final List<int> days = List.generate(31, (index) => index + 1);

  @override
  void initState() {
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    selectedDay = now.day;
    startData = DateFormat("yyyy-MM-dd").format(DateTime.now());
    endData = DateFormat("yyyy-MM-dd").format(DateTime.now());
    print('selectedYear = $selectedYear');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('selectedYear = $selectedYear');
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
          ),
          color: Colors.white
      ),
      height: 300.h,
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
                child: Icon(Icons.close,size: 20,)
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              children: [
                TextButton(onPressed: (){
                  Get.back();
                  widget.onOK("","");
                }, child: Text('重置',style: TextStyle(fontSize: 14,color: ColorStandard.textColor),)),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    if(DateTime.parse(startData).isBefore(DateTime.parse(endData))){
                      Get.back();
                      widget.onOK(startData,endData);
                    }
                    else{
                      showToast('开始时间不能大于结束时间');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 30.h,
                    alignment: Alignment.center,
                    child: Text('确认',style: TextStyle(fontSize: 14.sp,color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          // 日期显示 + 标签
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    isStart = true;
                    endData = '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                    setState(() {});
                  },
                  child:Text(
                    isStart ? "$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}" : startData ?? "开始时间",
                    style:  TextStyle(
                      color: isStart ? ColorStandard.main : Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                 GestureDetector(
                   onTap: (){
                     isStart = false;
                     startData = '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                     setState(() {});
                   },
                   child: Text(
                     !isStart ? "$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}" : endData ?? "结束时间",
                     style: TextStyle(color: !isStart ? ColorStandard.main : Colors.grey,fontSize: 16),
                   ),
                 ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildPicker(years, selectedYear, (val) {
                  print('selectedYear1 = $val');
                  selectedYear = val;
                  if(isStart){
                    startData =  '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                  }else{
                    endData =  '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                  }
                  setState(() {});

                })),
                Expanded(child: _buildPicker(months, selectedMonth, (val) {

                  print('selectedMonth = $val');

                  selectedMonth = val;
                  if(isStart){
                    startData =  '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                  }else{
                    endData =  '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                  }
                  setState(() {});
                })),
                Expanded(child: _buildPicker(days, selectedDay, (val) {
                  selectedDay = val;
                  if(isStart){
                    startData =  '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                  }else{
                    endData =  '$selectedYear-${_twoDigits(selectedMonth)}-${_twoDigits(selectedDay)}';
                  }
                  setState(() {});
                })),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPicker(List<int> options, int selected, ValueChanged<int> onChange) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: options.indexOf(selected),
      ),
      itemExtent: 40,
      magnification: 1.2,
      onSelectedItemChanged: (index) {
        print('onSelectedItemChanged = $index');
        onChange(options[index]);
      },
      children: options
          .map((e) => Center(
        child: Text(
          e.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ))
          .toList(),
    );
  }

  String _twoDigits(int val) => val.toString().padLeft(2, '0');

}
