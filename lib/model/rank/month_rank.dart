class LeaderboardResponse {
  int? currentUserRank;
  CurrentUserStats? currentUserStats;
  FakeDataInfo? fakeDataInfo;
  List<LeaderboardItem>? leaderboard;
  int? month;
  RewardInfo? rewardInfo;
  int? year;

  LeaderboardResponse({
    this.currentUserRank,
    this.currentUserStats,
    this.fakeDataInfo,
    this.leaderboard,
    this.month,
    this.rewardInfo,
    this.year,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      currentUserRank: json['current_user_rank'] ?? 0,
      currentUserStats: json['current_user_stats'] != null
          ? CurrentUserStats.fromJson(json['current_user_stats'])
          : CurrentUserStats(),
      fakeDataInfo: json['fake_data_info'] != null
          ? FakeDataInfo.fromJson(json['fake_data_info'])
          : FakeDataInfo(),
      leaderboard: LeaderboardItem.fromJsonList(json['leaderboard']),
      month: json['month'] ?? 0,
      rewardInfo: json['reward_info'] != null
          ? RewardInfo.fromJson(json['reward_info'])
          : RewardInfo(),
      year: json['year'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_user_rank': currentUserRank ?? 0,
    'current_user_stats': currentUserStats?.toJson(),
    'fake_data_info': fakeDataInfo?.toJson(),
    'leaderboard': leaderboard?.map((e) => e.toJson()).toList() ?? [],
    'month': month ?? 0,
    'reward_info': rewardInfo?.toJson(),
    'year': year ?? 0,
  };
}

class CurrentUserStats {
  int? totalComments;
  int? totalPoints;

  CurrentUserStats({this.totalComments, this.totalPoints});

  factory CurrentUserStats.fromJson(Map<String, dynamic> json) {
    return CurrentUserStats(
      totalComments: json['total_comments'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_comments': totalComments ?? 0,
    'total_points': totalPoints ?? 0,
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

  factory FakeDataInfo.fromJson(Map<String, dynamic> json) {
    return FakeDataInfo(
      fakeEntriesCount: json['fake_entries_count'] ?? 0,
      note: json['note'] ?? '',
      realEntriesCount: json['real_entries_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'fake_entries_count': fakeEntriesCount ?? 0,
    'note': note ?? '',
    'real_entries_count': realEntriesCount ?? 0,
  };
}

class LeaderboardItem {
  String? city;
  String? industry;
  bool? isFake;
  String? nickname;
  String? phone;
  int? rank;
  double? rewardAmount;
  int? totalComments;
  double? totalPoints;
  dynamic userId; // 可能是 String 也可能是 int

  LeaderboardItem({
    this.city,
    this.industry,
    this.isFake,
    this.nickname,
    this.phone,
    this.rank,
    this.rewardAmount,
    this.totalComments,
    this.totalPoints,
    this.userId,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      city: json['city'] ?? '',
      industry: json['industry'] ?? '',
      isFake: json['is_fake'] ?? false,
      nickname: json['nickname'] ?? '',
      phone: json['phone'] ?? '',
      rank: json['rank'] ?? 0,
      rewardAmount: (json['reward_amount'] is int)
          ? (json['reward_amount'] as int).toDouble()
          : (json['reward_amount'] ?? 0.0),
      totalComments: json['total_comments'] ?? 0,
      totalPoints: (json['total_points'] is int)
          ? (json['total_points'] as int).toDouble()
          : (json['total_points'] ?? 0.0),
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city ?? '',
    'industry': industry ?? '',
    'is_fake': isFake ?? false,
    'nickname': nickname ?? '',
    'phone': phone ?? '',
    'rank': rank ?? 0,
    'reward_amount': rewardAmount ?? 0.0,
    'total_comments': totalComments ?? 0,
    'total_points': totalPoints ?? 0.0,
    'user_id': userId ?? '',
  };

  /// 🔥 静态方法：把后端返回的 List 转为 List<LeaderboardItem>
  static List<LeaderboardItem> fromJsonList(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) => LeaderboardItem.fromJson(e)).toList();
  }
}

class RewardInfo {
  double? firstPlace;
  double? secondPlace;
  double? thirdPlace;

  RewardInfo({this.firstPlace, this.secondPlace, this.thirdPlace});

  factory RewardInfo.fromJson(Map<String, dynamic> json) {
    return RewardInfo(
      firstPlace: (json['first_place'] is int)
          ? (json['first_place'] as int).toDouble()
          : (json['first_place'] ?? 0.0),
      secondPlace: (json['second_place'] is int)
          ? (json['second_place'] as int).toDouble()
          : (json['second_place'] ?? 0.0),
      thirdPlace: (json['third_place'] is int)
          ? (json['third_place'] as int).toDouble()
          : (json['third_place'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() => {
    'first_place': firstPlace ?? 0.0,
    'second_place': secondPlace ?? 0.0,
    'third_place': thirdPlace ?? 0.0,
  };
}
