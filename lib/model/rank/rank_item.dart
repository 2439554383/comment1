class RankResponse {
  int? currentUserRank;
  CurrentUserStats? currentUserStats;
  String? date;
  FakeDataInfo? fakeDataInfo;
  List<RankItem>? leaderboard;

  RankResponse({
    this.currentUserRank,
    this.currentUserStats,
    this.date,
    this.fakeDataInfo,
    this.leaderboard,
  });

  factory RankResponse.fromJson(Map<String, dynamic> json) =>
      RankResponse(
        currentUserRank: json['current_user_rank'] ?? 0,
        currentUserStats: json['current_user_stats'] != null
            ? CurrentUserStats.fromJson(json['current_user_stats'])
            : CurrentUserStats(),
        date: json['date'] ?? '',
        fakeDataInfo: json['fake_data_info'] != null
            ? FakeDataInfo.fromJson(json['fake_data_info'])
            : FakeDataInfo(),
        leaderboard: (json['leaderboard'] as List<dynamic>?)
            ?.map((e) => RankItem.fromJson(e))
            .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
    'current_user_rank': currentUserRank,
    'current_user_stats': currentUserStats?.toJson(),
    'date': date,
    'fake_data_info': fakeDataInfo?.toJson(),
    'leaderboard': leaderboard?.map((e) => e.toJson()).toList(),
  };
}

class CurrentUserStats {
  int? commentsCount;
  int? pointsEarned;

  CurrentUserStats({
    this.commentsCount,
    this.pointsEarned,
  });

  factory CurrentUserStats.fromJson(Map<String, dynamic> json) =>
      CurrentUserStats(
        commentsCount: json['comments_count'] ?? 0,
        pointsEarned: json['points_earned'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'comments_count': commentsCount,
    'points_earned': pointsEarned,
  };
}

class FakeDataInfo {
  int? fakeEntriesCount;
  String? note;
  int? realEntriesCount;

  FakeDataInfo({
    this.fakeEntriesCount,
    this.note,
    this.realEntriesCount,
  });

  factory FakeDataInfo.fromJson(Map<String, dynamic> json) => FakeDataInfo(
    fakeEntriesCount: json['fake_entries_count'] ?? 0,
    note: json['note'] ?? '',
    realEntriesCount: json['real_entries_count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'fake_entries_count': fakeEntriesCount,
    'note': note,
    'real_entries_count': realEntriesCount,
  };
}

class RankItem {
  String? city;
  int? commentsCount;
  String? industry;
  bool? isFake;
  String? nickname;
  String? phone;
  double? pointsEarned;
  int? rank;
  dynamic userId; // 有时是 String，有时是 int

  RankItem({
    this.city,
    this.commentsCount,
    this.industry,
    this.isFake,
    this.nickname,
    this.phone,
    this.pointsEarned,
    this.rank,
    this.userId,
  });

  factory RankItem.fromJson(Map<String, dynamic> json) =>
      RankItem(
        city: json['city'] ?? '',
        commentsCount: json['comments_count'] ?? 0,
        industry: json['industry'] ?? '',
        isFake: json['is_fake'] ?? false,
        nickname: json['nickname'] ?? '',
        phone: json['phone'] ?? '',
        pointsEarned: (json['points_earned'] is int)
            ? (json['points_earned'] as int).toDouble()
            : (json['points_earned'] ?? 0.0),
        rank: json['rank'] ?? 0,
        userId: json['user_id'] ?? '',
      );

  Map<String, dynamic> toJson() => {
    'city': city,
    'comments_count': commentsCount,
    'industry': industry,
    'is_fake': isFake,
    'nickname': nickname,
    'phone': phone,
    'points_earned': pointsEarned,
    'rank': rank,
    'user_id': userId,
  };

  /// 🔥 静态方法：把后端返回的 List 转为 List<RankItem>
  static List<RankItem> fromJsonList(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) => RankItem.fromJson(e)).toList();
  }
}

