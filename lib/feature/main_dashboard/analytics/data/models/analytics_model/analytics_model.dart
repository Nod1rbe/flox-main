import 'package:json_annotation/json_annotation.dart';

part 'analytics_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AnalyticsModel {
  final String id;
  final String sessionId;
  final String funnelId;
  final int pageId;
  final DateTime createdAt;
  final String? fieldName;
  final String? value;

  const AnalyticsModel({
    required this.id,
    required this.sessionId,
    required this.funnelId,
    required this.pageId,
    required this.createdAt,
    this.fieldName,
    this.value,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => _$AnalyticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsModelToJson(this);

  @override
  String toString() {
    return 'AnalyticsModel(id: $id, sessionId: $sessionId, funnelId: $funnelId, pageId: $pageId, createdAt: $createdAt, fieldName: $fieldName, value: $value)';
  }
}
