import 'dart:async';
import 'dart:ui';

mixin ResendCountDownMixin {
  var rtimerText = "60秒后重新发送";
  var roriginalTime = 60;
  var rtimerColor = Color.fromRGBO(153, 153, 153, 1);
  late Timer rtimer ;
  rchangeTimer(var update){
    roriginalTime = 60;
    rtimer = Timer.periodic(Duration(seconds: 1), (timer) {
      roriginalTime -= 1;
      if(roriginalTime==0){
        roriginalTime = 60;
        rtimerText = "重新发送";
        rtimerColor = Color.fromRGBO(48, 79, 255, 1);
        rtimer.cancel();
      }
      else{
        rtimerText = "${roriginalTime}秒后重新发送";
        rtimerColor = Color.fromRGBO(153, 153, 153, 1);
      }
      update();
    });
  }
}