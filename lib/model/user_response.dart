class UserResponse {
  int? code;
  CommentInfo? commentInfo;
  InviteInfo? inviteInfo;
  PointsInfo? pointsInfo;
  SystemInfo? systemInfo;
  UserInfo? userInfo;

  UserResponse({
    this.code,
    this.commentInfo,
    this.inviteInfo,
    this.pointsInfo,
    this.systemInfo,
    this.userInfo,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    code: json['code'] ?? 0,
    commentInfo: json['comment_info'] != null
        ? CommentInfo.fromJson(json['comment_info'])
        : null,
    inviteInfo: json['invite_info'] != null
        ? InviteInfo.fromJson(json['invite_info'])
        : null,
    pointsInfo: json['points_info'] != null
        ? PointsInfo.fromJson(json['points_info'])
        : null,
    systemInfo: json['system_info'] != null
        ? SystemInfo.fromJson(json['system_info'])
        : null,
    userInfo: json['user_info'] != null
        ? UserInfo.fromJson(json['user_info'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'comment_info': commentInfo?.toJson(),
    'invite_info': inviteInfo?.toJson(),
    'points_info': pointsInfo?.toJson(),
    'system_info': systemInfo?.toJson(),
    'user_info': userInfo?.toJson(),
  };
}

class CommentInfo {
  int? dailyLimit;
  int? remainingTimes;
  int? todayComments;
  int? totalComments;

  CommentInfo({
    this.dailyLimit,
    this.remainingTimes,
    this.todayComments,
    this.totalComments,
  });

  factory CommentInfo.fromJson(Map<String, dynamic> json) => CommentInfo(
    dailyLimit: json['daily_limit'] ?? 0,
    remainingTimes: json['remaining_times'] ?? 0,
    todayComments: json['today_comments'] ?? 0,
    totalComments: json['total_comments'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'daily_limit': dailyLimit,
    'remaining_times': remainingTimes,
    'today_comments': todayComments,
    'total_comments': totalComments,
  };
}

class InviteInfo {
  String? inviteCode;
  int? invitedBy;
  int? invitedCount;

  InviteInfo({
    this.inviteCode,
    this.invitedBy,
    this.invitedCount,
  });

  factory InviteInfo.fromJson(Map<String, dynamic> json) => InviteInfo(
    inviteCode: json['invite_code'] ?? '',
    invitedBy: json['invited_by'],
    invitedCount: json['invited_count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'invite_code': inviteCode,
    'invited_by': invitedBy,
    'invited_count': invitedCount,
  };
}

class PointsInfo {
  int? availablePoints;
  int? currentPoints;
  int? frozenPoints;
  int? totalPointsConsumed;
  int? totalPointsRewarded;

  PointsInfo({
    this.availablePoints,
    this.currentPoints,
    this.frozenPoints,
    this.totalPointsConsumed,
    this.totalPointsRewarded,
  });

  factory PointsInfo.fromJson(Map<String, dynamic> json) => PointsInfo(
    availablePoints: json['available_points'] ?? 0,
    currentPoints: json['current_points'] ?? 0,
    frozenPoints: json['frozen_points'] ?? 0,
    totalPointsConsumed: json['total_points_consumed'] ?? 0,
    totalPointsRewarded: json['total_points_rewarded'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'available_points': availablePoints,
    'current_points': currentPoints,
    'frozen_points': frozenPoints,
    'total_points_consumed': totalPointsConsumed,
    'total_points_rewarded': totalPointsRewarded,
  };
}


class SystemInfo {
  int? freeTrials;
  String? memberSince;

  SystemInfo({
    this.freeTrials,
    this.memberSince,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) => SystemInfo(
    freeTrials: json['free_trials'] ?? 0,
    memberSince: json['member_since'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'free_trials': freeTrials,
    'member_since': memberSince,
  };
}

class UserInfo {
  double? balance;
  String? city;
  String? createdAt;
  int? id;
  String? industry;
  String? inviteCode;
  int? invitedBy;
  bool? isAdmin;
  String? nickname;
  String? phone;

  UserInfo({
    this.balance,
    this.city,
    this.createdAt,
    this.id,
    this.industry,
    this.inviteCode,
    this.invitedBy,
    this.isAdmin,
    this.nickname,
    this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    balance: (json['balance'] ?? 0.0).toDouble(),
    city: json['city'] ?? '',
    createdAt: json['created_at'] ?? '',
    id: json['id'] ?? 0,
    industry: json['industry'] ?? '',
    inviteCode: json['invite_code'] ?? '',
    invitedBy: json['invited_by'],
    isAdmin: json['is_admin'] ?? false,
    nickname: json['nickname'] ?? '',
    phone: json['phone'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'balance': balance,
    'city': city,
    'created_at': createdAt,
    'id': id,
    'industry': industry,
    'invite_code': inviteCode,
    'invited_by': invitedBy,
    'is_admin': isAdmin,
    'nickname': nickname,
    'phone': phone,
  };
}
