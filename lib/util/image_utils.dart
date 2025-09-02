import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../common/app_component.dart';
import '../widget/dialog/bottom_dialog.dart';
import 'f_util.dart';


class ImageUtils {
  ImageUtils._();

  static final ImagePicker _picker = ImagePicker();

  //选择多张图片 Select multiple images
  static Future<List<XFile>?> selectImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    return images;
  }

  //选择单张图片
  static Future<List<String>> selectImage(int max, BuildContext context) async {
    final Completer<List<String>> completer = Completer();

    ShowBottomDialog(
      title: '请从本地相册选择图片或拍照',
      cancel: () {
        completer.complete([]);
      },
      actions: [
        BottomDialogWidget(
          title: '拍摄',
          onTap: () async {
              final XFile? image = await _picker.pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                completer.complete([image.path]);
              } else {
                completer.complete([]);
              }
          },
        ),
        BottomDialogWidget(
          title: '相册',
          onTap: () async {
            final List<XFile> result = await ImagePicker.platform.getMultiImageWithOptions();
            if (result != null) {
              final List<String> _list = [];
              for (final e in result) {
                if (e != null) {
                  _list.add(e.path);
                }
              }
              completer.complete(_list);
            } else {
              completer.complete([]);
            }
          },
        ),
      ],
    );

    return completer.future;
  }

  /// 文件选取
  static Future<String?> getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      //allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt','png','gif','bmp','jpeg','jpg','webp','heic'],
    );
    if (FUtil.isNotEmptyString(result?.files.first.path ?? "")) {
      if (FUtil.canSelectFile(result?.files.first.path ?? "")) {
        return result?.files.first.path;
      } else {
        showToast('请选择文档、图片类型文件');
      }
    }
    return null;
  }

  //选择视屏
  static Future<XFile?> selectVideo() async {
    final Completer<XFile?> completer = Completer();

    ShowBottomDialog(
      title: '请从本地相册选择视屏或拍摄',
      cancel: () => completer.complete(),
      actions: [
        BottomDialogWidget(
          title: '拍摄',
          onTap: () async {
            final XFile? image = await _picker.pickVideo(
              source: ImageSource.camera,
              maxDuration: const Duration(seconds: 200),
            );

            completer.complete(image);
          },
        ),
        BottomDialogWidget(
          title: '相册',
          onTap: () async {
            final XFile? image = await _picker.pickVideo(
              source: ImageSource.gallery,
            );

            completer.complete(image);
          },
        ),
      ],
    );

    return completer.future;
  }

  Future<void> saveImage(String path) async {}
}
