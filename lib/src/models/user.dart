// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

/// All possible roles user can have.
enum Role { admin, agent, moderator, user }

/// A class that represents user.
@JsonSerializable()
@immutable
abstract class User extends Equatable {
  /// Creates a user.
  const User._({
    this.createdAt,
    this.name,
    required this.id,
    this.imageUrl,
    this.phone,
    this.lastSeen,
    this.metadata,
    this.role,
    this.updatedAt,
  });

  const factory User({
    int? createdAt,
    String? name,
    required String id,
    String? imageUrl,
    String? phone,
    int? lastSeen,
    Map<String, dynamic>? metadata,
    Role? role,
    int? updatedAt,
  }) = _User;

  /// Created user timestamp, in ms.
  final int? createdAt;

  /// First name of the user.
  final String? name;

  /// Unique ID of the user.
  final String id;

  /// Remote image URL representing user's avatar.
  final String? imageUrl;

  /// Last name of the user.
  final String? phone;

  /// Timestamp when user was last visible, in ms.
  final int? lastSeen;

  /// Additional custom metadata or attributes related to the user.
  final Map<String, dynamic>? metadata;

  /// User [Role].
  final Role? role;

  /// Updated user timestamp, in ms.
  final int? updatedAt;

  /// Equatable props.
  @override
  List<Object?> get props => [
        createdAt,
        name,
        id,
        imageUrl,
        phone,
        lastSeen,
        metadata,
        role,
        updatedAt,
      ];

  User copyWith({
    int? createdAt,
    String? name,
    String? id,
    String? imageUrl,
    String? phone,
    int? lastSeen,
    Map<String, dynamic>? metadata,
    Role? role,
    int? updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'imageUrl': imageUrl};
  }

  static fromMap(Map<String, dynamic> value) {
    return User(
        id: value["id"],
        name: value["name"],
        phone: value["phone"],
        imageUrl: value["imageUrl"]);
  }
}

/// A utility class to enable better copyWith.
class _User extends User {
  const _User({
    super.createdAt,
    super.name,
    required super.id,
    super.imageUrl,
    super.phone,
    super.lastSeen,
    super.metadata,
    super.role,
    super.updatedAt,
  }) : super._();

  @override
  User copyWith({
    dynamic createdAt = _Unset,
    dynamic name = _Unset,
    String? id,
    dynamic imageUrl = _Unset,
    dynamic phone = _Unset,
    dynamic lastSeen = _Unset,
    dynamic metadata = _Unset,
    dynamic role = _Unset,
    dynamic updatedAt = _Unset,
  }) =>
      _User(
        createdAt: createdAt == _Unset ? this.createdAt : createdAt as int?,
        name: name == _Unset ? this.name : name as String?,
        id: id ?? this.id,
        imageUrl: imageUrl == _Unset ? this.imageUrl : imageUrl as String?,
        phone: phone == _Unset ? this.phone : phone as String?,
        lastSeen: lastSeen == _Unset ? this.lastSeen : lastSeen as int?,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        role: role == _Unset ? this.role : role as Role?,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
      );
}

class _Unset {}
