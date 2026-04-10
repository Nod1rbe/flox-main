import 'package:flox/core/extensions/hex_color_extensions.dart';
import 'package:flutter/material.dart';

import 'model/gradient_settings_model.dart';
import 'model/page_settings_model.dart';

class PageSettingsConfig {
  final String backgroundImage;
  final bool scrollable;
  final Color? backgroundColor;
  final GradientSettingsModel? gradientSettings;
  final bool autoNavigate;
  final Duration duration;

  PageSettingsConfig({
    this.gradientSettings,
    required this.backgroundImage,
    required this.scrollable,
    this.backgroundColor,
    required this.autoNavigate,
    required this.duration,
  });

  factory PageSettingsConfig.fromModel(PageSettingsModel model) {
    final hasGradient =
        model.gradientSettings?.gradientColors != null && model.gradientSettings!.gradientColors!.isNotEmpty;

    return PageSettingsConfig(
      gradientSettings: model.gradientSettings,
      backgroundImage: model.backgroundImage ?? '',
      scrollable: model.scrollable ?? false,
      backgroundColor: hasGradient ? null : model.backgroundColor?.toColor,
      autoNavigate: model.autoNavigation ?? false,
      duration: Duration(milliseconds: (1000 * (model.durationInSeconds ?? 1)).toInt()),
    );
  }

  PageSettingsModel toModel() {
    return PageSettingsModel(
      gradientSettings: gradientSettings,
      backgroundImage: backgroundImage,
      scrollable: scrollable,
      backgroundColor: backgroundColor?.toHexString(),
      autoNavigation: autoNavigate,
      durationInSeconds: duration.inMilliseconds / 1000,
    );
  }

  PageSettingsConfig copyWith({
    String? backgroundImage,
    bool? scrollable,
    Color? backgroundColor,
    bool? autoNavigate,
    GradientSettingsModel? gradientSettings,
    Duration? duration,
  }) {
    final bool backgroundChanged = backgroundColor != null && backgroundColor != this.backgroundColor;
    final bool gradientChanged = gradientSettings != null && gradientSettings != this.gradientSettings;

    return PageSettingsConfig(
      backgroundImage: backgroundImage ?? this.backgroundImage,
      scrollable: scrollable ?? this.scrollable,
      backgroundColor: gradientChanged ? null : (backgroundColor ?? this.backgroundColor),
      gradientSettings: backgroundChanged ? null : (gradientSettings ?? this.gradientSettings),
      autoNavigate: autoNavigate ?? this.autoNavigate,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'PageSettingsConfig{backgroundImage: $backgroundImage, scrollable: $scrollable, backgroundColor: $backgroundColor, gradientSettings: $gradientSettings, autoNavigate: $autoNavigate, duration: $duration}';
  }
}
