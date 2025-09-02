class CueItem {
  String name;
  bool isSet;
  bool isCheck;

  CueItem({
    this.name = '',
    this.isSet = false,
    this.isCheck = false,
  });

  factory CueItem.fromJson(Map<String, dynamic> json) {
    return CueItem(
      name: json['name'] ?? '',
      isSet: json['isSet'] ?? false,
      isCheck: json['isCheck'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isSet': isSet,
      'isCheck': isCheck,
    };
  }
}
