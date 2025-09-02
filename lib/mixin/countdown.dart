import 'dart:async';
import 'dart:ui';

mixin CountDownMixin {
  var timerText = "发送验证码";
  var originalTime = 60;
  var timerColor = Color.fromRGBO(153, 153, 153, 1);
  late Timer timer ;
  changeTimer(var update){
    originalTime = 60;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      originalTime -= 1;
      if(originalTime==0){
        originalTime = 60;
        timerText = "发送验证码";
        timer.cancel();
      }
      else{
        timerText = "${originalTime}秒后重新发送";
      }
      update();
    });
  }
}