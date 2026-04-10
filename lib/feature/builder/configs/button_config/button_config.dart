import 'package:flox/core/enums/ui_enums/basic_alignment_type.dart';
import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/button_config_widget.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flutter/material.dart';

class ButtonConfig extends BaseConfig {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double width;
  final double height;
  final double textSize;
  final FontWeight textWeight;
  final Alignment alignment;
  final String fontFamily;

  ButtonConfig({
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required super.padding,
    required this.radius,
    required this.width,
    required this.height,
    required this.textSize,
    required this.textWeight,
    required this.alignment,
    required this.fontFamily,
  }) : super(type: ViewType.button);

  factory ButtonConfig.fromModel(ButtonModel model) => ButtonConfig(
        text: model.text ?? '',
        buttonColor: model.buttonColor.toColor,
        textColor: model.textColor.toColor,
        padding: EdgeInsets.zero.fromPaddingModel(model.padding),
        radius: model.radius ?? 16,
        width: model.width ?? 250,
        height: model.height ?? 48,
        textSize: model.textSize ?? 14,
        textWeight: TextWeightType.fromModel(model.textWeight ?? 500),
        alignment: BasicAlignmentType.fromModel(model.alignment),
        fontFamily: model.fontFamily ?? FontOptions.defaultFont,
      );

  @override
  ButtonModel toModel() => ButtonModel(
        text: text,
        buttonColor: buttonColor.toHexString(),
        textColor: textColor.toHexString(),
        radius: radius,
        padding: PaddingModel.fromEdgeInsets(padding),
        width: width,
        height: height,
        textSize: textSize,
        textWeight: TextWeightType.toModel(textWeight),
        alignment: BasicAlignmentType.toModel(alignment),
        fontFamily: fontFamily,
      );

  ButtonConfig copyWith({
    String? text,
    Color? buttonColor,
    Color? textColor,
    EdgeInsets? padding,
    double? radius,
    double? width,
    double? height,
    double? textSize,
    FontWeight? textWeight,
    Alignment? alignment,
    String? fontFamily,
  }) {
    return ButtonConfig(
      text: text ?? this.text,
      buttonColor: buttonColor ?? this.buttonColor,
      textColor: textColor ?? this.textColor,
      padding: padding ?? this.padding,
      radius: radius ?? this.radius,
      width: width ?? this.width,
      height: height ?? this.height,
      textSize: textSize ?? this.textSize,
      textWeight: textWeight ?? this.textWeight,
      alignment: alignment ?? this.alignment,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) {
    return ButtonConfigWidget(
      key: key,
      config: this,
      isSelected: isSelected,
    );
  }

  @override
  String toString() {
    return 'ButtonConfig{'
        'text: "$text", '
        'buttonColor: ${buttonColor.value.toRadixString(16)}, '
        'textColor: ${textColor.value.toRadixString(16)}, '
        'padding: $padding, '
        'radius: $radius, '
        'width: $width, '
        'height: $height, '
        'textSize: $textSize, '
        'textWeight: $textWeight, '
        'alignment: $alignment, '
        'fontFamily: $fontFamily'
        '}';
  }
}
