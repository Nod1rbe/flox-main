// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsModel _$AnalyticsModelFromJson(Map<String, dynamic> json) =>
    AnalyticsModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      funnelId: json['funnel_id'] as String,
      pageId: (json['page_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      fieldName: json['field_name'] as String?,
      value: json['value'] as String?,
      trafficSource: json['traffic_source'] as String?,
    );

Map<String, dynamic> _$AnalyticsModelToJson(AnalyticsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'funnel_id': instance.funnelId,
      'page_id': instance.pageId,
      'created_at': instance.createdAt.toIso8601String(),
      'field_name': instance.fieldName,
      'value': instance.value,
      'traffic_source': instance.trafficSource,
    };
