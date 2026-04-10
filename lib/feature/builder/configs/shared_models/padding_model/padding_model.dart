import 'package:flutter/src/painting/edge_insets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'padding_model.g.dart';

@JsonSerializable()
class PaddingModel {
  @JsonKey(name: 'l')
  final double left;

  @JsonKey(name: 'r')
  final double right;

  @JsonKey(name: 't')
  final double top;

  @JsonKey(name: 'b')
  final double bottom;

  PaddingModel({required this.left, required this.right, required this.top, required this.bottom});

  factory PaddingModel.fromJson(Map<String, dynamic> json) => _$PaddingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaddingModelToJson(this);

  static PaddingModel get sample => PaddingModel(left: 10, right: 10, top: 10, bottom: 10);

  factory PaddingModel.fromEdgeInsets(EdgeInsets padding) => PaddingModel(
        left: padding.left,
        right: padding.right,
        top: padding.top,
        bottom: padding.bottom,
      );
}
