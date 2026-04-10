import 'package:flox/feature/builder/configs/base_config_model.dart';
import 'package:flox/feature/builder/configs/button_config/model/button_model.dart';
import 'package:flox/feature/builder/configs/page_settings_config/model/page_settings_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_model.g.dart';

@JsonSerializable()
class PageModel {
  @JsonKey(name: 'configs')
  final List<BaseConfigModel>? configs;
  @JsonKey(name: 'page_settings')
  final PageSettingsModel? pageSettingsConfig;
  @JsonKey(name: 'id')
  final int? pageId;
  @JsonKey(name: 'page_order')
  final int? pageOrder;
  @JsonKey(name: 'nav_button')
  final ButtonModel? navButton;

  const PageModel({
    this.configs,
    this.pageSettingsConfig,
    this.pageId,
    this.pageOrder,
    this.navButton,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) => _$PageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageModelToJson(this);

  @override
  String toString() {
    return 'PageEntity{configs: $configs, pageSettingsConfig: $pageSettingsConfig, pageId: $pageId, pageOrder: $pageOrder}';
  }
}
