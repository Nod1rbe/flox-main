import 'package:flox/core/enums/ui_enums/basic_alignment_type.dart';
import 'package:flox/core/enums/ui_enums/basic_box_fit_type.dart';
import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/image_config/image_config_widget.dart';
import 'package:flox/feature/builder/configs/image_config/model/image_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flutter/cupertino.dart';

class ImageConfig extends BaseConfig {
  final String imageUrl;
  final Alignment alignment;
  final double height;
  final double width;
  final double cornerRadius;
  final BoxFit fit;

  ImageConfig({
    required this.fit,
    required this.imageUrl,
    required this.alignment,
    required this.height,
    required this.width,
    required this.cornerRadius,
    required super.padding,
  }) : super(type: ViewType.image);

  factory ImageConfig.fromModel(ImageModel model) {
    return ImageConfig(
      fit: BasicBoxFitType.fromModel(model.fit),
      imageUrl: model.imageUrl ?? '',
      alignment: BasicAlignmentType.fromModel(model.alignment),
      height: model.height ?? 100,
      width: model.width ?? 400,
      cornerRadius: model.cornerRadius ?? 12,
      padding: EdgeInsets.zero.fromPaddingModel(model.padding),
    );
  }

  ImageConfig copyWith({
    String? imageUrl,
    Alignment? alignment,
    BoxFit? fit,
    double? height,
    double? width,
    double? cornerRadius,
    EdgeInsets? padding,
  }) {
    return ImageConfig(
      fit: fit ?? this.fit,
      imageUrl: imageUrl ?? this.imageUrl,
      alignment: alignment ?? this.alignment,
      height: height ?? this.height,
      width: width ?? this.width,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      padding: padding ?? this.padding,
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) {
    return ImageConfigWidget(config: this, isSelected: isSelected, key: key);
  }

  @override
  String toString() {
    return 'ImageConfig{imageUrl: $imageUrl, alignment: $alignment, height: $height, width: $width, cornerRadius: $cornerRadius, boxFit: $fit}';
  }

  @override
  BaseConfigModel toModel() {
    var padding = PaddingModel.fromEdgeInsets(this.padding);
    return ImageModel(
      fit: BasicBoxFitType.toModel(fit),
      imageUrl: imageUrl,
      alignment: BasicAlignmentType.toModel(alignment),
      height: height,
      width: width,
      cornerRadius: cornerRadius,
      padding: padding,
    );
  }
}
