import 'package:json_annotation/json_annotation.dart';

part 'page_views_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PageViewsModel {
  final int pageId;
  final DateTime date;
  final int telegram;
  final int instagram;
  final int x;
  final int facebook;

  const PageViewsModel({
    required this.pageId,
    required this.date,
    required this.telegram,
    required this.instagram,
    required this.x,
    required this.facebook,
  });

  factory PageViewsModel.fromJson(Map<String, dynamic> json) => _$PageViewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageViewsModelToJson(this);

  @override
  String toString() {
    return 'PageViewsModel(pageId: $pageId, date: $date, telegram: $telegram, instagram: $instagram, x: $x, facebook: $facebook)';
  }
}
