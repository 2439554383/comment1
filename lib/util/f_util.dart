import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../common/app_component.dart';

abstract class FUtil {
  static int lengthOfString(String? string) => (string?.length ?? 0);

  static int lengthOfList(List? list) => (list?.length ?? 0);

  static bool isEmptyString(String? string) => lengthOfString(string?.trim()) == 0;

  static bool isEmptyList(List? list) => lengthOfList(list) == 0;

  static bool isNotEmptyList(List? list) => lengthOfList(list) > 0;

  static double stringToDouble(String? value) {
    if (value == null || value.trim() == '') {
      return 0;
    }
    if (double.tryParse(value) != null) {
      return double.parse(value);
    }
    return 0.0;
  }

  static bool isNotEmptyString(String? string) => lengthOfString(string) > 0;

  static bool allIsNotEmptyString(List<String?>? list) {
    bool r = true;
    list?.forEach((element) {
      if (lengthOfString(element) == 0) {
        r = false;
        return;
      }
    });
    return r;
  }

  static bool allIsEmptyString(List<String?>? list) {
    bool r = true;
    list?.forEach((element) {
      if (isNotEmptyString(element)) {
        r = false;
        return;
      }
    });
    return r;
  }

  static bool allIsNotEmptyList(List<List?>? list) {
    bool r = true;
    list?.forEach((element) {
      if (lengthOfList(element) == 0) {
        r = false;
        return;
      }
    });
    return r;
  }

  static String? hidePhoneOrEmail(String? value) {
    if (value == null || value.length < 7) {
      return value;
    }
    return '${value.substring(0, 3)}****${value.substring(8, value.length)}';
  }


  static bool canSelectFile(String url) {
    url = url.toLowerCase();
    return url.endsWith('.pdf') ||
        url.endsWith('.doc') ||
        url.endsWith('.docx') ||
        url.endsWith('.xls') ||
        url.endsWith('.xlsx') ||
        url.endsWith('.ppt') ||
        url.endsWith('.txt') ||
        url.endsWith('.gif') ||
        url.endsWith('.bmp') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.jpg') ||
        url.endsWith('.webp') ||
        url.endsWith('.heic') ||
        url.endsWith('.pptx');
  }

  static Future<String> getCachePathDir() async {
    //临时存储目录，可以被清理

    final Directory _dir = await getTemporaryDirectory();

    final String _path = getRandomId();

    return '${_dir.path}/$_path';
  }


  static String getFileName(String filePath){
    String fileName = filePath.split('/').last;
    return fileName;
  }

  static bool isFile(String url) {
    url = url.toLowerCase();
    return url.endsWith('.pdf') ||
        url.endsWith('.doc') ||
        url.endsWith('.docx') ||
        url.endsWith('.xls') ||
        url.endsWith('.xlsx') ||
        url.endsWith('.ppt') ||
        url.endsWith('.txt') ||
        url.endsWith('.pptx');
  }

  static getBankAccount(String? a){
    if(FUtil.lengthOfString(a) <= 4){
      return a??"";
    }
    return a!.substring(a.length - 4);
  }
}
