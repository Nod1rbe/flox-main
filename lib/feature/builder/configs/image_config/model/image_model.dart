import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel implements BaseConfigModel {
  @override
  String type;

  @JsonKey(name: 'i')
  final String? imageUrl;

  @JsonKey(name: 'f')
  final String? fit;

  @JsonKey(name: 'a')
  final String? alignment;

  @JsonKey(name: 'h')
  final double? height;

  @JsonKey(name: 'w')
  final double? width;

  @JsonKey(name: 'cR')
  final double? cornerRadius;

  @JsonKey(name: 'padding')
  final PaddingModel? padding;

  ImageModel({
    this.fit,
    this.imageUrl,
    this.alignment,
    this.height,
    this.width,
    this.cornerRadius,
    this.padding,
  }) : type = ViewType.image.name;

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  factory ImageModel.sample() => ImageModel(
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLd5yZUuXjw6wJ7SkgJGZ_w8P5RQpyTrhgtw&s',
        alignment: 'center',
        fit: 'cover',
        height: 100,
        width: 150,
        cornerRadius: 10,
        padding: PaddingModel(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
      );
}
