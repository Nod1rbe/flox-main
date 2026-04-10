import 'package:flox/core/enums/ui_enums/basic_text_alignment_type.dart';
import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_default_style_model.dart';
import 'package:flutter/cupertino.dart';

class McDefaultStyleConfig {
  final bool multiSelection;
  final bool showIcon;
  final double cornerRadius;
  final TextAlign alignment;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final double fontSize;
  final String fontFamily;

  McDefaultStyleConfig({
    required this.multiSelection,
    required this.showIcon,
    required this.cornerRadius,
    required this.alignment,
    required this.textColor,
    required this.backgroundColor,
    required this.fontWeight,
    required this.fontSize,
    required this.fontFamily,
  });

  factory McDefaultStyleConfig.fromModel(McDefaultStyleModel model) {
    return McDefaultStyleConfig(
      multiSelection: model.multiSelection ?? false,
      showIcon: model.showIcon ?? false,
      cornerRadius: model.cornerRadius ?? 8,
      alignment: BasicTextAlignmentType.fromModel(model.alignment ?? 'left'),
      textColor: model.textColor.toColor,
      backgroundColor: model.backgroundColor.toColor,
      fontWeight: TextWeightType.fromModel(model.fontWeight ?? 400),
      fontSize: model.fontSize ?? 16,
      fontFamily: model.fontFamily ?? FontOptions.defaultFont,
    );
  }

  McDefaultStyleConfig copyWith({
    bool? multiSelection,
    bool? showIcon,
    double? cornerRadius,
    TextAlign? alignment,
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    double? fontSize,
    String? fontFamily,
  }) {
    return McDefaultStyleConfig(
      multiSelection: multiSelection ?? this.multiSelection,
      showIcon: showIcon ?? this.showIcon,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      alignment: alignment ?? this.alignment,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  McDefaultStyleModel toModel() {
    return McDefaultStyleModel(
      multiSelection: multiSelection,
      showIcon: showIcon,
      cornerRadius: cornerRadius,
      alignment: BasicTextAlignmentType.toModel(alignment),
      textColor: textColor.toHexString(),
      backgroundColor: backgroundColor.toHexString(),
      fontWeight: TextWeightType.toModel(fontWeight),
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
  }
}
