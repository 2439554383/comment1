import 'package:intl/intl.dart';

mixin FormatMixin{
  numberFormat(num number){
    // if(number>=100000000){
    //   return "${(number/100000000).toStringAsFixed(2)}亿";
    // }
    if(number>=1000){
      return NumberFormat("#,##0.00", "en_US").format(number);
    }
    return number;
  }
}