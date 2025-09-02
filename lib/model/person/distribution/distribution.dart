class DistributionResponse {
  int? code;
  String? message;
  List<Record>? records;
  Pagination? pagination;
  Summary? summary;

  DistributionResponse({
    this.code,
    this.message,
    this.records,
    this.pagination,
    this.summary,
  });

  factory DistributionResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DistributionResponse();

    return DistributionResponse(
      code: json["code"] ?? 0,
      message: json["message"] ?? "--",
      records: (json["records"] as List?)
          ?.map((e) => Record.fromJson(e))
          .toList() ??
          [],
      pagination: Pagination.fromJson(json["pagination"]),
      summary: Summary.fromJson(json["summary"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "records": records?.map((e) => e.toJson()).toList(),
      "pagination": pagination?.toJson(),
      "summary": summary?.toJson(),
    };
  }
}

class Record {
  int? id;
  double? amount;
  double? commissionRate;
  String? status;
  String? sourceType;
  int? sourceId;
  InvitedUser? invitedUser;
  String? createdAt;
  String? processedAt;

  Record({
    this.id,
    this.amount,
    this.commissionRate,
    this.status,
    this.sourceType,
    this.sourceId,
    this.invitedUser,
    this.createdAt,
    this.processedAt,
  });

  factory Record.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Record();

    return Record(
      id: json["id"] ?? 0,
      amount: (json["amount"] ?? 0.0).toDouble(),
      commissionRate: (json["commission_rate"] ?? 0.0).toDouble(),
      status: json["status"] ?? "--",
      sourceType: json["source_type"] ?? "--",
      sourceId: json["source_id"] ?? 0,
      invitedUser: InvitedUser.fromJson(json["invited_user"]),
      createdAt: json["created_at"] ?? "--",
      processedAt: json["processed_at"] ?? "--",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "commission_rate": commissionRate,
      "status": status,
      "source_type": sourceType,
      "source_id": sourceId,
      "invited_user": invitedUser?.toJson(),
      "created_at": createdAt,
      "processed_at": processedAt,
    };
  }
}

class InvitedUser {
  String? phone;
  String? nickname;

  InvitedUser({this.phone, this.nickname});

  factory InvitedUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return InvitedUser();

    return InvitedUser(
      phone: json["phone"] ?? "--",
      nickname: json["nickname"] ?? "--",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
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
      page: json["page"] ?? 0,
      perPage: json["per_page"] ?? 0,
      total: json["total"] ?? 0,
      pages: json["pages"] ?? 0,
      hasPrev: json["has_prev"] ?? false,
      hasNext: json["has_next"] ?? false,
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

class Summary {
  double? totalCommission;
  double? pendingCommission;
  double? paidCommission;
  int? invitedUsersCount;

  Summary({
    this.totalCommission,
    this.pendingCommission,
    this.paidCommission,
    this.invitedUsersCount,
  });

  factory Summary.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Summary();

    return Summary(
      totalCommission: (json["total_commission"] ?? 0.0).toDouble(),
      pendingCommission: (json["pending_commission"] ?? 0.0).toDouble(),
      paidCommission: (json["paid_commission"] ?? 0.0).toDouble(),
      invitedUsersCount: json["invited_users_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_commission": totalCommission,
      "pending_commission": pendingCommission,
      "paid_commission": paidCommission,
      "invited_users_count": invitedUsersCount,
    };
  }
}
