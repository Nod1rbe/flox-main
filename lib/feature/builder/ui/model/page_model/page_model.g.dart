// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageModel _$PageModelFromJson(Map<String, dynamic> json) => PageModel(
      configs: (json['configs'] as List<dynamic>?)
          ?.map((e) => BaseConfigModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageSettingsConfig: json['page_settings'] == null
          ? null
          : PageSettingsModel.fromJson(
              json['page_settings'] as Map<String, dynamic>),
      pageId: (json['id'] as num?)?.toInt(),
      pageOrder: (json['page_order'] as num?)?.toInt(),
      navButton: json['nav_button'] == null
          ? null
          : ButtonModel.fromJson(json['nav_button'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'configs': instance.configs,
      'page_settings': instance.pageSettingsConfig,
      'id': instance.pageId,
      'page_order': instance.pageOrder,
      'nav_button': instance.navButton,
    };
