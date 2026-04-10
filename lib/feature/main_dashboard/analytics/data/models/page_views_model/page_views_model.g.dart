// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_views_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageViewsModel _$PageViewsModelFromJson(Map<String, dynamic> json) =>
    PageViewsModel(
      pageId: (json['page_id'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      telegram: (json['telegram'] as num).toInt(),
      instagram: (json['instagram'] as num).toInt(),
      x: (json['x'] as num).toInt(),
      facebook: (json['facebook'] as num).toInt(),
    );

Map<String, dynamic> _$PageViewsModelToJson(PageViewsModel instance) =>
    <String, dynamic>{
      'page_id': instance.pageId,
      'date': instance.date.toIso8601String(),
      'telegram': instance.telegram,
      'instagram': instance.instagram,
      'x': instance.x,
      'facebook': instance.facebook,
    };
