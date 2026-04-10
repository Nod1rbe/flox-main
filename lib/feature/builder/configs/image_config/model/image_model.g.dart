// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => ImageModel(
      fit: json['f'] as String?,
      imageUrl: json['i'] as String?,
      alignment: json['a'] as String?,
      height: (json['h'] as num?)?.toDouble(),
      width: (json['w'] as num?)?.toDouble(),
      cornerRadius: (json['cR'] as num?)?.toDouble(),
      padding: json['padding'] == null
          ? null
          : PaddingModel.fromJson(json['padding'] as Map<String, dynamic>),
    )..type = json['type'] as String;

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'i': instance.imageUrl,
      'f': instance.fit,
      'a': instance.alignment,
      'h': instance.height,
      'w': instance.width,
      'cR': instance.cornerRadius,
      'padding': instance.padding,
    };
