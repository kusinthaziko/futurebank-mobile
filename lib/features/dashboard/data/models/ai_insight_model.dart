class AiInsightModel {
  final String message;
  final String type;

  const AiInsightModel({required this.message, required this.type});

  factory AiInsightModel.fromJson(Map<String, dynamic> json) {
    return AiInsightModel(
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
    );
  }
}
