import 'package:flox/core/enums/ui_enums/text_weight_type.dart';
import 'package:flox/core/constants/font_options.dart';
import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/progress_config/model/progress_model.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config_values.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config_widget.dart';
import 'package:flox/feature/builder/configs/shared_models/padding_model/padding_model.dart';
import 'package:flutter/cupertino.dart';

class ProgressConfig extends BaseConfig {
  final double height;
  final double cornerRadius;
  final bool showIcon;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final double fontSize;
  final String fontFamily;
  final List<ProgressConfigValues> progressValues;

  ProgressConfig({
    required super.padding,
    required this.height,
    required this.cornerRadius,
    required this.showIcon,
    required this.textColor,
    required this.backgroundColor,
    required this.fontWeight,
    required this.fontSize,
    required this.fontFamily,
    required this.progressValues,
  }) : super(type: ViewType.progress);

  factory ProgressConfig.fromModel(ProgressModel model) {
    return ProgressConfig(
      padding: EdgeInsets.zero.fromPaddingModel(model.padding),
      height: model.height ?? 12,
      cornerRadius: model.cornerRadius ?? 4,
      showIcon: model.showIcon ?? true,
      textColor: model.textColor.toColor,
      backgroundColor: model.backgroundColor.toColor,
      fontWeight: TextWeightType.fromModel(model.fontWeight ?? 400),
      fontSize: model.fontSize ?? 16,
      fontFamily: model.fontFamily ?? FontOptions.defaultFont,
      progressValues:
          model.progressValues?.map((e) => ProgressConfigValues.fromModel(e)).toList() ?? [],
    );
  }

  @override
  Widget toWidget(bool isSelected, {Key? key}) {
    return ProgressConfigWidget(
      config: this,
      isSelected: isSelected,
      key: key,
    );
  }

  ProgressConfig copyWith({
    EdgeInsets? padding,
    double? height,
    double? cornerRadius,
    bool? showIcon,
    Color? textColor,
    Color? backgroundColor,
    FontWeight? fontWeight,
    double? fontSize,
    String? fontFamily,
    List<ProgressConfigValues>? progressValues,
  }) {
    return ProgressConfig(
      padding: padding ?? this.padding,
      height: height ?? this.height,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      showIcon: showIcon ?? this.showIcon,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      progressValues: progressValues ?? this.progressValues,
    );
  }

  @override
  BaseConfigModel toModel() {
    var progressValues = this.progressValues.map((e) => e.toModel()).toList();
    return ProgressModel(
      padding: PaddingModel.fromEdgeInsets(padding),
      height: height,
      cornerRadius: cornerRadius,
      showIcon: showIcon,
      textColor: textColor.toHexString(),
      backgroundColor: backgroundColor.toHexString(),
      fontWeight: fontWeight.value,
      fontSize: fontSize,
      fontFamily: fontFamily,
      progressValues: progressValues,
    );
  }
}
