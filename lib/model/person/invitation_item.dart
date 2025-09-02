class InvitationRecord {
  final String avatarUrl;        // 用户头像 URL
  final String name;             // 用户名
  final String invitedAt;        // 邀请时间
  final String invitationStatus; // 邀请状态文本

  InvitationRecord({
    required this.avatarUrl,
    required this.name,
    required this.invitedAt,
    required this.invitationStatus,
  });

  factory InvitationRecord.fromJson(Map<String, dynamic> json) {
    return InvitationRecord(
      avatarUrl: json['avatarUrl'] ?? '',
      name: json['name'] ?? '',
      invitedAt: json['invitedAt'] ?? '',
      invitationStatus: json['invitationStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatarUrl': avatarUrl,
      'name': name,
      'invitedAt': invitedAt,
      'invitationStatus': invitationStatus,
    };
  }
}
