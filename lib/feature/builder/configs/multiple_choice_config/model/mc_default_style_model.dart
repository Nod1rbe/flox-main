import 'package:json_annotation/json_annotation.dart';

part 'mc_default_style_model.g.dart';

@JsonSerializable()
class McDefaultStyleModel {
  @JsonKey(name: 'mL')
  final bool? multiSelection;

  @JsonKey(name: 'shI')
  final bool? showIcon;

  @JsonKey(name: 'cR')
  final double? cornerRadius;

  @JsonKey(name: 'a')
  final String? alignment;

  @JsonKey(name: 'tC')
  final String? textColor;

  @JsonKey(name: 'bgC')
  final String? backgroundColor;

  @JsonKey(name: 'fW')
  final int? fontWeight;

  @JsonKey(name: 'fS')
  final double? fontSize;

  @JsonKey(name: 'fF')
  final String? fontFamily;

  McDefaultStyleModel({
    this.multiSelection,
    this.showIcon,
    this.cornerRadius,
    this.alignment,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
  });

  factory McDefaultStyleModel.fromJson(Map<String, dynamic> json) => _$McDefaultStyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$McDefaultStyleModelToJson(this);

  factory McDefaultStyleModel.sample() => McDefaultStyleModel(
        multiSelection: true,
        showIcon: true,
        cornerRadius: 10,
        alignment: 'center',
        textColor: 'FFFFFF',
        backgroundColor: '4489F7',
        fontWeight: 500,
        fontSize: 14,
        fontFamily: 'Inter',
      );
}
