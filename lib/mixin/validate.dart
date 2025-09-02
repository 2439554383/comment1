import 'dart:ffi';

mixin FormValidationMixin {
  num toNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 0;
    }
    final isNumeric = RegExp(r'^-?\d*\.?\d+$').hasMatch(value);
    if (!isNumeric) {
      return 0;
    }
    return num.tryParse(value) ?? 0;
  }
  String? validateRequired( String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return  ' $fieldName是必填项' ;
    }
    return  null ;
  }


  String? validateEmail( String? value) {
    if (value == null || value.isEmpty) return  '电子邮件是必填项' ;

    final emailRegex = RegExp ( r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$' );
    if (!emailRegex.hasMatch(value)) {
      return  '请输入有效的电子邮件' ;
    }
    return  null ;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '密码是必填项';
    }

    // 至少6位，必须包含字母和数字，可以有标点符号
    final passwordRegex = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()\-_=+[\]{}|;:",.<>/?]{6,}$'
    );
    if (!passwordRegex.hasMatch(value)) {
    return '密码至少6位，必须包含字母和数字';
    }

    return null;
  }



  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return '手机号是必填项';

    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return '请输入有效的手机号';
    }
    return null;
  }

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) return '验证码是必填项';

    final codeRegex = RegExp(r'^\d{6}$'); // 必须是6位数字
    if (!codeRegex.hasMatch(value)) {
      return '验证码必须是6位数字';
    }
    return null;
  }


  String? validateMinLength( String? value, int minLength, String fieldName) {
    if (value == null || value.length < minLength) {
      return  ' $fieldName必须至少包含$minLength个字符' ;
    }
    return  null ;
  }
  String? validateNumber(String? value,num max){
    if(value == null || value.trim().isEmpty || max == null){
      return '必填项' ;
    }
    num number = toNumber(value);

    if(number <= 0.0){
      return '请输入有效数字';
    }
    if(number > max){
      return '超出账户余额';
    }
    return null;
  }
  String? validatEarnestMmoney(String? value,num max){
    if(value == null || value.trim().isEmpty || max == null){
      return '未填保证金' ;
    }
    num number = toNumber(value);
    if(number < 1000){
      return '最低保证金为1000';
    }
    if(number % 1000 !=0){
      return '请输入1000的正数倍';
    }
    if(number > max){
      return '超出账户余额';
    }
    return null;
  }
}