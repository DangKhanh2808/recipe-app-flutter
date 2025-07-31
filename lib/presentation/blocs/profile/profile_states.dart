import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
  final bool isFollowing;

  const ProfileLoaded({
    required this.userProfile,
    this.isFollowing = false,
  });

  @override
  List<Object?> get props => [userProfile, isFollowing];

  ProfileLoaded copyWith({
    UserProfile? userProfile,
    bool? isFollowing,
  }) {
    return ProfileLoaded(
      userProfile: userProfile ?? this.userProfile,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
} 