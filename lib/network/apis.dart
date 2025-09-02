
class Api {
  static String get host =>
     'https://www.203166.cn';//测试环境
  static  String baseUrl = '$host';
  static String imageUrl(String id) => id.startsWith('http') ? id : '$baseUrl$id';

  static const String register = "/api/auth/register-phone"; //注册
  static const String login = "/api/auth/login"; //登录
  static const String sendCode = "/api/auth/send-code"; //发送短信
  static const String dayRanking = "/api/leaderboard/daily"; //获取日榜
  static const String monthRanking = "/api/leaderboard/monthly"; //获取月榜
  static const String rankingCount = "/api/leaderboard/stats"; //排行榜统计
  static const String cueList = "/api/leaderboard"; //获取排行榜
  static const String userInfo = "/api/users/profile"; //获取个人信息
  static const String integral = "/api/users/points"; //获取积分详情
  static const String pay = "/api/payment/alipay/create"; //支付
  static const String balanceExchange = "/api/users/balance/exchange-times"; //余额兑换次数
  static const String integralExchange = "/api/users/points/exchange-times"; //积分兑换次数
  static const String distributionRecord = "/api/users/commission/records"; //用户分销记录
  static const String rechargeRecord = "/api/users/recharge/records"; //用户充值记录

}
