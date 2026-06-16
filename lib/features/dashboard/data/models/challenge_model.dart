class ChallengeModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final double progress;
  final int? streakDays;
  final int daysRemaining;
  final String status;

  const ChallengeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.progress,
    this.streakDays,
    required this.daysRemaining,
    required this.status,
  });

  bool get isStreak => type == 'streak';

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'savings',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      streakDays: json['streakDays'] as int?,
      daysRemaining: (json['daysRemaining'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'active',
    );
  }
}
