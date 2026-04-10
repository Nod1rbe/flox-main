import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/base_config.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/feature/builder/configs/page_settings_config/page_settings_config.dart';
import 'package:flutter/material.dart';

class PageData {
  final List<BaseConfig> configs;
  final PageSettingsConfig pageSettingsConfig;
  final int pageId;
  final int pageOrder;
  final ButtonConfig navButton;

  PageData({
    required this.configs,
    required this.pageSettingsConfig,
    required this.pageId,
    required this.pageOrder,
    required this.navButton,
  });

  factory PageData.sample(int order) {
    return PageData(
      configs: [],
      pageSettingsConfig: PageSettingsConfig(
        gradientSettings: null,
        backgroundImage: '',
        scrollable: true,
        backgroundColor: Colors.white,
        autoNavigate: false,
        duration: const Duration(milliseconds: 500),
      ),
      navButton: ButtonConfig(
        text: 'Continue',
        buttonColor: AppColors.black,
        textColor: AppColors.white,
        padding: const EdgeInsets.all(16).copyWith(top: 10),
        radius: 12,
        width: 250,
        height: 42,
        textSize: 14,
        textWeight: FontWeight.w500,
        alignment: Alignment.center,
        fontFamily: 'Inter',
      ),
      pageId: 0,
      pageOrder: order,
    );
  }

  PageData copyWith({
    List<BaseConfig>? configs,
    PageSettingsConfig? pageSettingsConfig,
    int? pageId,
    int? pageOrder,
    ButtonConfig? navButton,
  }) {
    return PageData(
      configs: configs ?? this.configs,
      pageSettingsConfig: pageSettingsConfig ?? this.pageSettingsConfig,
      pageId: pageId ?? this.pageId,
      pageOrder: pageOrder ?? this.pageOrder,
      navButton: navButton ?? this.navButton,
    );
  }

  @override
  String toString() {
    return 'PageData{configs: $configs, pageSettingsConfig: $pageSettingsConfig, pageId: $pageId, pageOrder: $pageOrder, navButton: $navButton}';
  }
}
