class RechargeResponse {
  int? code;
  String? message;
  List<RechargeRecord>? records;
  Pagination? pagination;
  Statistics? statistics;

  RechargeResponse({
    this.code,
    this.message,
    this.records,
    this.pagination,
    this.statistics,
  });

  factory RechargeResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RechargeResponse();
    return RechargeResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '--',
      records: (json['records'] as List?)
          ?.map((e) => RechargeRecord.fromJson(e))
          .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination']),
      statistics: Statistics.fromJson(json['statistics']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "records": records?.map((e) => e.toJson()).toList(),
      "pagination": pagination?.toJson(),
      "statistics": statistics?.toJson(),
    };
  }
}

class RechargeRecord {
  int? id;
  int? userId;
  double? amount;
  int? points;
  String? paymentMethod;
  String? transactionId;
  String? outTradeNo;
  String? status;
  String? createdAt;
  String? completedAt;
  double? commissionGenerated;
  CommissionRecipient? commissionRecipient;

  RechargeRecord({
    this.id,
    this.userId,
    this.amount,
    this.points,
    this.paymentMethod,
    this.transactionId,
    this.outTradeNo,
    this.status,
    this.createdAt,
    this.completedAt,
    this.commissionGenerated,
    this.commissionRecipient,
  });

  factory RechargeRecord.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RechargeRecord();
    return RechargeRecord(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      points: json['points'] ?? 0,
      paymentMethod: json['payment_method'] ?? '--',
      transactionId: json['transaction_id'] ?? '--',
      outTradeNo: json['out_trade_no'] ?? '--',
      status: json['status'] ?? '--',
      createdAt: json['created_at'] ?? '--',
      completedAt: json['completed_at'] ?? '--',
      commissionGenerated: (json['commission_generated'] ?? 0).toDouble(),
      commissionRecipient:
      CommissionRecipient.fromJson(json['commission_recipient']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "amount": amount,
      "points": points,
      "payment_method": paymentMethod,
      "transaction_id": transactionId,
      "out_trade_no": outTradeNo,
      "status": status,
      "created_at": createdAt,
      "completed_at": completedAt,
      "commission_generated": commissionGenerated,
      "commission_recipient": commissionRecipient?.toJson(),
    };
  }
}

class CommissionRecipient {
  int? userId;
  String? nickname;

  CommissionRecipient({this.userId, this.nickname});

  factory CommissionRecipient.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CommissionRecipient();
    return CommissionRecipient(
      userId: json['user_id'] ?? 0,
      nickname: json['nickname'] ?? '--',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "nickname": nickname,
    };
  }
}

class Pagination {
  int? page;
  int? perPage;
  int? total;
  int? pages;
  bool? hasPrev;
  bool? hasNext;

  Pagination({
    this.page,
    this.perPage,
    this.total,
    this.pages,
    this.hasPrev,
    this.hasNext,
  });

  factory Pagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Pagination();
    return Pagination(
      page: json['page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
      hasPrev: json['has_prev'] ?? false,
      hasNext: json['has_next'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "per_page": perPage,
      "total": total,
      "pages": pages,
      "has_prev": hasPrev,
      "has_next": hasNext,
    };
  }
}

class Statistics {
  double? totalAmount;
  int? totalRecords;
  double? successfulAmount;
  double? failedAmount;

  Statistics({
    this.totalAmount,
    this.totalRecords,
    this.successfulAmount,
    this.failedAmount,
  });

  factory Statistics.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Statistics();
    return Statistics(
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      totalRecords: json['total_records'] ?? 0,
      successfulAmount: (json['successful_amount'] ?? 0).toDouble(),
      failedAmount: (json['failed_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_amount": totalAmount,
      "total_records": totalRecords,
      "successful_amount": successfulAmount,
      "failed_amount": failedAmount,
    };
  }
}
