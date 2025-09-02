import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import '../common/app_component.dart';

class CompressUtil {
  CompressUtil._();

  static Future<Future<XFile?>?> compressImageByFile(File file, String targetDir, {bool isJpeg = false}) async {
    try {
      if(isJpeg) {
        return _toJpeg(file, targetDir);
      }
      // if (basename(file.path).endsWith('jpeg') ||
      //     basename(file.path).endsWith('jpg')) {
      //   return _toWebp(file, targetDir);
      // }
      return _toJpeg(file, targetDir);
    } catch (e, s) {
    }
    return null;
  }

  //转webp
  // static Future<File?> _toWebp(File file, String targetDir) async {
  //   final int _quality = _qualityImage(file);
  //
  //   final DateTime _now = DateTime.now();
  //
  //   final Uint8List _image = await file.readAsBytes();
  //
  //   final Uint8List _compress = await FlutterImageCompress.compressWithList(
  //       _image,
  //       quality: _quality,
  //       format: CompressFormat.webp);
  //
  //   final File _file = File('$targetDir.jpeg');
  //
  //   if (!_file.existsSync()) {
  //     await _file.create();
  //   }
  //
  //   await _file.writeAsBytes(_compress);
  //
  //   LogUtils.i('webp 压缩($_quality)前：${_image.length} -> '
  //       '压缩后: ${_file.lengthSync()} -> '
  //       '总用时: ${DateTime.now().difference(_now).inMilliseconds}毫秒 -> '
  //       '${basename(_file.path)}');
  //
  //   return _file;
  // }

  //转jpeg
  static Future<XFile?> _toJpeg(File file, String targetDir) async {
    final int _quality = _qualityImage(file);

    final DateTime _now = DateTime.now();

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '$targetDir${basename(file.path)}',
      quality: _quality,
      format: _getCompressFormat(file.path),
    );
    if (result != null) {
      appPrint(
          'jpeg 压缩($_quality)前: ${file.lengthSync()} -> 压缩后: -> 用时: ${DateTime.now().difference(_now).inMilliseconds}毫秒');

      return result;
    }
    return null;
  }

  //获取文件类型
  static CompressFormat _getCompressFormat(String path) {
    if (path.endsWith('.png')) {
      return CompressFormat.png;
    } else if (path.endsWith('.webp')) {
      return CompressFormat.webp;
    } else if (path.endsWith('.heic')) {
      return CompressFormat.heic;
    }
    return CompressFormat.jpeg;
  }

  static int _qualityImage(File file) {
    final int _fileSize = file.lengthSync();

    if (_fileSize > 10 * MB) {
      return 50;
    } else if (_fileSize > 5 * MB) {
      return 65;
    } else if (_fileSize > 2 * MB) {
      return 75;
    } else if (_fileSize > MB) {
      return 80;
    }
    return 88;
  }

  static const int KB = 1024;

  static const int MB = 1024 * 1024;
}

class VideoCompressModel {
  final String video;
  final String image;

  VideoCompressModel({required this.video, required this.image});
}
