import 'package:flox/core/enums/ui_enums/basic_alignment_type.dart';
import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/model/text_field_model.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config_widget.dart';
import 'package:flutter/cupertino.dart';

class TextFieldConfig extends BaseConfig {
  final double cornerRadius;
  final Alignment alignment;
  final String hintText;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final double fontSize;
  final String fontFamily;
  final String analyticsFieldName;

  TextFieldConfig({
    required this.hintText,
    required this.analyticsFieldName,
    required super.padding,
    required this.cornerRadius,
    required this.alignment,
    required this.textColor,
    required this.backgroundColor,
    required this.fontWeight,
    required this.fontSize,
    required this.fontFamily,
  }) : super(type: ViewType.textField);

  factory TextFieldConfig.fromModel(TextFieldModel model) {
    return TextFieldConfig(
      hintText: model.hintText ?? 'Enter text',
      analyticsFieldName: model.analyticsFieldsName ?? '',
      padding: EdgeInsets.zero.fromPaddingModel(model.padding),
      cornerRadius: model.cornerRadius ?? 0,
      alignment: BasicAlignmentType.fromModel(model.alignment),
      textColor: model.textColor.toColor,
      backgroundColor: model.backgroundColor.toColor,
      fontWeight: TextWeightType.fromModel(model.fontWeight ?? 400),
      fontSize: model.fontSize ?? 16,
      fontFamily: model.fontFamily ?? FontOptions.defaultFont,
    );
  }

  TextFieldConfig copyWith({
    EdgeInsets? padding,
    double? cornerRadius,
    Alignment? alignment,
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    double? fontSize,
    String? fontFamily,
    String? hintText,
    String? analyticsFieldsName,
  }) {
    return TextFieldConfig(
      hintText: hintText ?? this.hintText,
      analyticsFieldName: analyticsFieldsName ?? analyticsFieldName,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      alignment: alignment ?? this.alignment,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) {
    return TextFieldConfigWidget(
      config: this,
      isSelected: isSelected,
      key: key,
    );
  }

  @override
  String toString() {
    return 'TextFieldConfig{padding: $padding, cornerRadius: $cornerRadius, alignment: $alignment, textColor: $textColor, backgroundColor: $backgroundColor, fontWeight: $fontWeight, fontSize: $fontSize, analyticsFieldsName: $analyticsFieldName}';
  }

  @override
  TextFieldModel toModel() {
    var padding = PaddingModel.fromEdgeInsets(this.padding);
    return TextFieldModel(
      hintText: hintText,
      analyticsFieldsName: analyticsFieldName,
      padding: padding,
      cornerRadius: cornerRadius,
      alignment: BasicAlignmentType.toModel(alignment),
      textColor: textColor.toHexString(),
      backgroundColor: backgroundColor.toHexString(),
      fontWeight: TextWeightType.toModel(fontWeight),
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
  }
}
