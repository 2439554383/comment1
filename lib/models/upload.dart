class UploadFileModel {
  String? fileName;
  String? newFileName;
  String? url;
  String? originalFilename;
  String? filePath;

  UploadFileModel copyWith({String? filePath, String? imageFilePath}) =>
      UploadFileModel(
        url: url,
        fileName: fileName,
        filePath: filePath ?? this.filePath,
        newFileName: newFileName,
        originalFilename: originalFilename,
      );

  UploadFileModel(
      {this.fileName,
        this.newFileName,
        this.url,
        this.originalFilename,
        this.filePath});

  UploadFileModel.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    newFileName = json['newFileName'];
    url = json['url'];
    originalFilename = json['originalFilename'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['newFileName'] = this.newFileName;
    data['url'] = this.url;
    data['originalFilename'] = this.originalFilename;
    data['filePath'] = this.filePath;
    return data;
  }
}