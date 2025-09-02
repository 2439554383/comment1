import 'dart:io';
import 'dart:typed_data';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/app_component.dart';
import '../models/upload.dart';

class UploadUtil extends GetxService {


  static Future uploadAvatar(String _path) async {
    // final File _file = File(_path);

    final String _cachePath = await getCachePathDir();

    // final File? _compressFile =
    //     await CompressUtil.compressImageByFile(_file, _cachePath);

    // await Api.upload.uploadAvatar(_compressFile?.path ?? _path);

    //删除存档图片，
    if (File(_cachePath).existsSync()) {
      File(_cachePath).delete();
    }
  }

  static Future<UploadFileModel> uploadU8ListToApi(
      String bucketName, Uint8List list) async {
    // final data = await Api.upload.uploadData(bucketName, data: list);

    //TODO
    return UploadFileModel.fromJson({} as Map<String, dynamic>);
  }

  static Future<UploadFileModel> uploadImageToApi(
      String _path, {String bucketName = 'product-template-1307904696'}) async {
    // final File _file = File(_path);

    final String _cachePath = await getCachePathDir();

    // final File? _compressFile =
    //     await CompressUtil.compressImageByFile(_file, _cachePath);

    // final data = await Api.upload
    //     .uploadFile(bucketName, filePath: _compressFile?.path ?? _path);

    //删除存档图片，
    if (File(_cachePath).existsSync()) {
      File(_cachePath).delete();
    }

    return UploadFileModel.fromJson({} as Map<String, dynamic>).copyWith(filePath: _path);
  }

  //完工视屏
  // static Future<UploadFileModel> uploadVideoToApi(String _path) async {
  //   final File _file = File(_path);
  //
  //   final String _cachePath = await getCachePathDir();
  //
  //   // final VideoCompressModel? _compressFile =
  //   //     await CompressUtil.compressVideoByFile(_file, _cachePath);
  //
  //   // final data = await Api.upload.uploadFile('order-complete-1307904696',
  //   //     filePath: _compressFile?.video ?? _path);
  //
  //   //删除存档视屏，
  //   if (File(_cachePath).existsSync()) {
  //     File(_cachePath).delete();
  //   }
  //
  //   //TODO
  //   return UploadFileModel.fromJson({} as Map<String, dynamic>).copyWith(
  //     filePath: _path,
  //     imageFilePath: _compressFile!.image,
  //   );
  // }
}

Future<String> getCachePathDir() async {
  //临时存储目录，可以被清理

  final Directory _dir = await getTemporaryDirectory();

  final String _path = getRandomId();

  return '${_dir.path}/$_path';
}
