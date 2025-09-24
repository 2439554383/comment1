class CommentType {
  final int id;
  final int categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final int consumptionLevelId;
  final String consumptionLevelName;
  final String typeCode;
  final String typeName;
  final String description;
  final int pointsRequired;
  final String levelColor;
  bool isActive;
  bool isSelect;
  bool isCheck;
  final String createdAt;
  final int sortOrder;
  changeStatus(){
    isSelect = !isSelect;
  }
  check(){
    isCheck = !isCheck;
  }
  CommentType({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.consumptionLevelId,
    required this.consumptionLevelName,
    required this.typeCode,
    required this.typeName,
    required this.description,
    required this.pointsRequired,
    required this.levelColor,
    required this.isActive,
    this.isSelect = true,
    this.isCheck = false,
    required this.createdAt,
    required this.sortOrder,
  });

  factory CommentType.fromJson(Map<String, dynamic> json) {
    return CommentType(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryIcon: json['category_icon'],
      categoryColor: json['category_color'],
      consumptionLevelId: json['consumption_level_id'],
      consumptionLevelName: json['consumption_level_name'],
      typeCode: json['type_code'],
      typeName: json['type_name'],
      description: json['description'],
      pointsRequired: json['points_required'],
      levelColor: json['level_color'],
      isActive: json['is_active'],
      isSelect: json['isSelect'] ?? true,
      createdAt: json['created_at'],
      sortOrder: json['sort_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_icon': categoryIcon,
      'category_color': categoryColor,
      'consumption_level_id': consumptionLevelId,
      'consumption_level_name': consumptionLevelName,
      'type_code': typeCode,
      'type_name': typeName,
      'description': description,
      'points_required': pointsRequired,
      'level_color': levelColor,
      'is_active': isActive,
      'isSelect': isSelect,
      'created_at': createdAt,
      'sort_order': sortOrder,
    };
  }
}
