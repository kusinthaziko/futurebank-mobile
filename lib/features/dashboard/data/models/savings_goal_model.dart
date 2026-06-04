class SavingsGoalModel {
  final String id;
  final String name;
  final String targetAmount;
  final String currentAmount;
  final String? deadline;
  final String category;
  final String status;

  const SavingsGoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.category,
    required this.status,
  });

  double get progress {
    final t = double.tryParse(targetAmount) ?? 1;
    final c = double.tryParse(currentAmount) ?? 0;
    return t > 0 ? (c / t).clamp(0.0, 1.0) : 0;
  }

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: json['target_amount'] as String,
      currentAmount: json['current_amount'] as String,
      deadline: json['deadline'] as String?,
      category: json['category'] as String? ?? 'Personal',
      status: json['status'] as String? ?? 'active',
    );
  }
}
