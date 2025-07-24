import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.avatarUrl,
    required super.createdAt,
    super.lastSignInAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
    );
  }

  factory UserModel.fromSupabaseUser(dynamic user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['full_name'] as String? ?? 
            user.userMetadata?['name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String? ?? 
                 user.userMetadata?['picture'] as String?,
      createdAt: DateTime.parse(user.createdAt),
      lastSignInAt: user.lastSignInAt != null
          ? DateTime.parse(user.lastSignInAt)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }
}
