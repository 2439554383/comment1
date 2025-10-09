import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../common/app_component.dart';
import '../common/loading.dart';

class DownloadFileUtil{
  static String _localPath = '';
  static Future download(String? link) async {
    if (Platform.isAndroid) {
      // 根据文件扩展名判断类型，默认使用video
      String fileType = 'video';
      if (link != null) {
        if (link.endsWith('.jpg') || link.endsWith('.png') || link.endsWith('.jpeg') || link.endsWith('.gif')) {
          fileType = 'image';
        } else if (link.endsWith('.mp3') || link.endsWith('.wav') || link.endsWith('.m4a')) {
          fileType = 'audio';
        }
      }
      bool r = await checkStoragePermission(type: fileType);
      if (!r) {
        return;
      }
    }
    await _prepare();
    String filePath = "$_localPath/${link!.substring(link.lastIndexOf('/') + 1, link.length)}";
    _hasDownload(filePath).then((value) {
      print('filePath = $filePath value = $value');
      if (value) {
        OpenFile.open(filePath).then((value) {
          if (value.type == ResultType.noAppToOpen) showToast('没有可打开的应用');
        });
      } else {
        _requestDownload(link, filePath);
      }
    });
  }

  static Future<Null> _prepare() async {
    _localPath = (await _findLocalPath()??"") + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath??"");
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  static Future<bool> _hasDownload(String filePath) async {
    File file = File(filePath);
    return await file.exists();
  }

  // 获取存储路径
  static Future<String?> _findLocalPath() async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory?.path;
  }

  static void _requestDownload(link, filePath) async {
    print('link = $link');
    try {
      Dio dio = Dio();
      dio.options.connectTimeout = Duration(milliseconds: 20000);
      //设置数据接收超时时间
      dio.options.receiveTimeout = Duration(milliseconds: 20000);
      Loading.show();
      Response response = await dio.download(link, filePath);
      if (response.statusCode == 200) {
        Loading.dismiss();
        OpenFile.open(filePath).then((value) {
          if (value.type == ResultType.noAppToOpen) showToast('没有可打开的应用');
        });
      } else {
        Loading.dismiss();
       showToast('文件下载失败');
      }
    } catch (e) {
      Loading.dismiss();
    }
  }

}