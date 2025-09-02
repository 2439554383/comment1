class ImageItem {
  int? id;
  String? type;
  int? rowId;
  String? path;
  String? fileName;
  String? fileType;
  int? fileSize;
  int? imgWidth;
  int? imgHeight;
  String? createTime;
  int? createBy;
  String? thumbnailPath;
  bool? video;
  bool? image;
  static List<ImageItem> listFromJson(List? jsonList) {
    return (jsonList?.length ?? 0) == 0
        ? []
        : jsonList!.map((e) => ImageItem.fromJson(e)).toList();
  }
  ImageItem(
      {this.id,
        this.type,
        this.rowId,
        this.path,
        this.fileName,
        this.fileType,
        this.fileSize,
        this.imgWidth,
        this.imgHeight,
        this.createTime,
        this.createBy,
        this.thumbnailPath,
        this.video,
        this.image});

  ImageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    rowId = json['rowId'];
    path = json['path'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    fileSize = json['fileSize'];
    imgWidth = json['imgWidth'];
    imgHeight = json['imgHeight'];
    createTime = json['createTime'];
    createBy = json['createBy'];
    thumbnailPath = json['thumbnailPath'];
    video = json['video'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['rowId'] = this.rowId;
    data['path'] = this.path;
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    data['fileSize'] = this.fileSize;
    data['imgWidth'] = this.imgWidth;
    data['imgHeight'] = this.imgHeight;
    data['createTime'] = this.createTime;
    data['createBy'] = this.createBy;
    data['thumbnailPath'] = this.thumbnailPath;
    data['video'] = this.video;
    data['image'] = this.image;
    return data;
  }
}