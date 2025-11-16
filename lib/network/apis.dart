
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
  static const String cueList = "/api/users/comment-types"; //获取评论类型
  static const String userInfo = "/api/users/profile"; //获取个人信息
  static const String integral = "/api/users/points"; //获取积分详情
  static const String pay = "/api/payment/alipay/create"; //支付
  static const String exchangePoints = "/api/users/balance/exchange-points"; //余额兑换积分
  static const String distributionRecord = "/api/users/commission/records"; //用户分销记录
  static const String rechargeRecord = "/api/users/recharge/records"; //用户充值记录
  static const String getComment = "/api/users/get-comment-content"; //生成评论
  static const String getTemplates = "/api/users/comment-templates"; //获取评论模板
  static const String point = "/api/users/get-comment-content"; //扣点
  static const String putPassword = "/api/users/change-password"; //修改密码
  static const String putUserinfo = "/api/users/profile"; //修改用户信息
  static const String favoriteList = "/api/users/favorite-templates"; //获取收藏评论
  static const String feedbackReport = "/api/users/feedback-report"; //提交反馈/举报

}
