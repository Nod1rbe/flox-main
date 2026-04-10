import 'package:json_annotation/json_annotation.dart';

part 'mc_selection_style_model.g.dart';

@JsonSerializable()
class McSelectionStyleModel {
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

  McSelectionStyleModel({this.textColor, this.backgroundColor, this.fontWeight, this.fontSize, this.fontFamily});

  factory McSelectionStyleModel.fromJson(Map<String, dynamic> json) => _$McSelectionStyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$McSelectionStyleModelToJson(this);

  factory McSelectionStyleModel.sample() => McSelectionStyleModel(
        textColor: 'FFFFFF',
        backgroundColor: 'F3C63E',
        fontWeight: 400,
        fontSize: 14,
        fontFamily: 'Inter',
      );
}
