import 'package:json_annotation/json_annotation.dart';

part 'progress_values_model.g.dart';

@JsonSerializable()
class ProgressValuesModel {
  @JsonKey(name: 't')
  final String? text;
  @JsonKey(name: 'd')
  final double? duration;

  ProgressValuesModel({this.text, this.duration});

  factory ProgressValuesModel.fromJson(Map<String, dynamic> json) => _$ProgressValuesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressValuesModelToJson(this);

  factory ProgressValuesModel.sample1() => ProgressValuesModel(text: 'Analyzing your inputs', duration: 1.8);

  factory ProgressValuesModel.sample2() => ProgressValuesModel(text: 'Calculating the results', duration: 1.5);

  factory ProgressValuesModel.sample3() => ProgressValuesModel(text: 'Personalizing the results', duration: 1.0);
}
