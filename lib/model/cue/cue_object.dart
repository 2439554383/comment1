import 'cue_item.dart';

class ItemListResponse {
  int code;
  String message;
  int total;
  List<CueItem> rows;

  ItemListResponse({
    this.code = 0,
    this.message = '',
    this.total = 0,
    this.rows = const [],
  });

  factory ItemListResponse.fromJson(Map<String, dynamic> json) {
    return ItemListResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      rows: (json['rows'] as List? ?? [])
          .map((e) => CueItem.fromJson(e ?? {}))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'total': total,
      'rows': rows.map((e) => e.toJson()).toList(),
    };
  }
}
