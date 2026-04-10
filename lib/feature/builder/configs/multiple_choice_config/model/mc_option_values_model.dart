import 'package:json_annotation/json_annotation.dart';

part 'mc_option_values_model.g.dart';

@JsonSerializable()
class McOptionValuesModel {
  @JsonKey(name: 't')
  final String? text;

  @JsonKey(name: 'lI')
  final String? leadingIcon;

  McOptionValuesModel({this.text, this.leadingIcon});

  factory McOptionValuesModel.fromJson(Map<String, dynamic> json) => _$McOptionValuesModelFromJson(json);

  Map<String, dynamic> toJson() => _$McOptionValuesModelToJson(this);

  factory McOptionValuesModel.sample1() => McOptionValuesModel(text: 'Option 1', leadingIcon: '😑');

  factory McOptionValuesModel.sample2() => McOptionValuesModel(text: 'Option 2', leadingIcon: '😁');

  factory McOptionValuesModel.sample3() => McOptionValuesModel(text: 'Option 3', leadingIcon: '😂');
}
