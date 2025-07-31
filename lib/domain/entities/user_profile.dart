import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final List<String> favoriteRecipes;

  const UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.favoriteRecipes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        postsCount,
        followersCount,
        followingCount,
        favoriteRecipes,
      ];
} 