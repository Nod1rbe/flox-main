// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'funnel_projects_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FunnelProjectsModel _$FunnelProjectsModelFromJson(Map<String, dynamic> json) =>
    FunnelProjectsModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      pageIds: (json['page_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      links:
          (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$FunnelProjectsModelToJson(
        FunnelProjectsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'page_ids': instance.pageIds,
      'links': instance.links,
    };
