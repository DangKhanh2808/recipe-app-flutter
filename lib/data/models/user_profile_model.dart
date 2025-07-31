import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    required super.postsCount,
    required super.followersCount,
    required super.followingCount,
    required super.favoriteRecipes,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'],
      postsCount: json['postsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      favoriteRecipes: List<String>.from(json['favoriteRecipes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'favoriteRecipes': favoriteRecipes,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
      favoriteRecipes: favoriteRecipes,
    );
  }
} 