import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flox/feature/builder/configs/text_config/model/text_model.dart';
import 'package:flox/feature/builder/configs/text_config/text_config_widget.dart';
import 'package:flutter/material.dart';

class TextConfig extends BaseConfig {
  final String text;
  final String leadingIcon;
  final Color color;
  final double size;
  final TextAlign alignment;
  final FontWeight weight;
  final String fontFamily;

  TextConfig({
    required this.text,
    required this.leadingIcon,
    required this.color,
    required this.size,
    required this.alignment,
    required this.weight,
    required this.fontFamily,
    required super.padding,
  }) : super(type: ViewType.text);

  factory TextConfig.fromModel(TextModel model) {
    return TextConfig(
      text: model.text ?? '',
      leadingIcon: model.leadingIcon ?? '',
      color: model.color?.toColor ?? Colors.white,
      size: model.size ?? 14,
      alignment: TextAlign.values.firstWhere((e) => e.name == model.alignment),
      weight: TextWeightType.fromModel(model.weight ?? 500),
      fontFamily: model.fontFamily ?? FontOptions.defaultFont,
      padding: EdgeInsets.zero.fromPaddingModel(model.padding),
    );
  }

  @override
  TextModel toModel() {
    var padding = PaddingModel.fromEdgeInsets(this.padding);
    return TextModel(
      text: text,
      leadingIcon: leadingIcon,
      color: color.toHexString(),
      size: size,
      alignment: alignment.name,
      weight: weight.value,
      fontFamily: fontFamily,
      padding: padding,
    );
  }

  TextConfig copyWith({
    String? text,
    String? leadingIcon,
    Color? color,
    double? size,
    TextAlign? alignment,
    FontWeight? weight,
    String? fontFamily,
    EdgeInsets? padding,
  }) {
    return TextConfig(
      text: text ?? this.text,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      color: color ?? this.color,
      size: size ?? this.size,
      alignment: alignment ?? this.alignment,
      weight: weight ?? this.weight,
      fontFamily: fontFamily ?? this.fontFamily,
      padding: padding ?? this.padding,
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) {
    return TextConfigWidget(
      config: this,
      isSelected: isSelected,
      key: key,
    );
  }

  @override
  String toString() {
    return 'TextConfig{text: $text, leadingIcon: $leadingIcon, color: $color, size: $size, alignment: $alignment, weight: $weight, fontFamily: $fontFamily}';
  }
}
