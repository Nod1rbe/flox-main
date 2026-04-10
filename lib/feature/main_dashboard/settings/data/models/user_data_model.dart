import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel {
  final String name;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String email;
  final String imageUrl;

  const UserDataModel({
    this.name = '',
    this.email = '',
    this.imageUrl = '',
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);

  UserDataModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
  }) {
    return UserDataModel(
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() => 'UserDataModel(name: $name, email: $email, imageUrl: $imageUrl)';
}
