import 'dart:ui';

import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/model/mc_selection_style_model.dart';

class McSelectedStyleConfig {
  final Color textColor;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final double fontSize;
  final String fontFamily;

  McSelectedStyleConfig({
    required this.textColor,
    required this.backgroundColor,
    required this.fontWeight,
    required this.fontSize,
    required this.fontFamily,
  });

  factory McSelectedStyleConfig.fromModel(McSelectionStyleModel model) {
    return McSelectedStyleConfig(
      textColor: model.textColor.toColor,
      backgroundColor: model.backgroundColor.toColor,
      fontWeight: TextWeightType.fromModel(model.fontWeight ?? 500),
      fontSize: model.fontSize ?? 16,
      fontFamily: model.fontFamily ?? FontOptions.defaultFont,
    );
  }

  McSelectedStyleConfig copyWith({
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    double? fontSize,
    String? fontFamily,
  }) {
    return McSelectedStyleConfig(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  McSelectionStyleModel toModel() {
    return McSelectionStyleModel(
      textColor: textColor.toHexString(),
      backgroundColor: backgroundColor.toHexString(),
      fontWeight: fontWeight.value,
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
  }
}
