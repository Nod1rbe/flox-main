import 'package:json_annotation/json_annotation.dart';

part 'funnel_projects_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FunnelProjectsModel {
  final String? id;
  final String? userId;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final List<int> pageIds;
  final List<String> links;

  const FunnelProjectsModel({
    this.id,
    this.userId,
    this.name = '',
    this.description,
    this.createdAt,
    this.pageIds = const [],
    this.links = const [],
  });

  factory FunnelProjectsModel.fromJson(Map<String, dynamic> json) =>
      _$FunnelProjectsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FunnelProjectsModelToJson(this);

  FunnelProjectsModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? pageCount,
    DateTime? createdAt,
    List<int>? pageIds,
    List<String>? links,
  }) {
    return FunnelProjectsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      pageIds: pageIds ?? this.pageIds,
      links: links ?? this.links,
    );
  }

  @override
  String toString() =>
      'FunnelProjectsModel(id: $id, userId: $userId, name: $name, description: $description, createdAt: $createdAt)\n';
}
