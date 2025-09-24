
class OldApi {
  static String get host =>
     'http://139.196.235.10:8005/comment';//测试环境
  static  String baseUrl = '$host';
  static String imageUrl(String id) => id.startsWith('http') ? id : '$baseUrl$id';

  static const String getComment = "/get_comment/"; //获取评论
  static const String getImage = "/get_aiimage/"; //获取Ai图片
  static const String removeMark = "/get_unmarkvideo/"; //去水印
  static const String aiFace = "/post_aiface/"; //ai换脸
  static const String voiceClone = "/post_audio/"; //克隆声音
}
