import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_profile.dart';
import 'profile_events.dart';
import 'profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileFollowRequested>(_onProfileFollowRequested);
    on<ProfileMessageRequested>(_onProfileMessageRequested);
  }

  void _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Mock data for now - in real app this would come from API
      await Future.delayed(const Duration(milliseconds: 500));
      
      final userProfile = const UserProfile(
        id: '1',
        name: 'Quách Đăng Khanh',
        avatarUrl: null, // Will use default avatar
        postsCount: 100,
        followersCount: 100,
        followingCount: 100,
        favoriteRecipes: [
          'https://www.themealdb.com/images/media/meals/52959.jpg',
          'https://www.themealdb.com/images/media/meals/52819.jpg',
          'https://www.themealdb.com/images/media/meals/52944.jpg',
          'https://www.themealdb.com/images/media/meals/52807.jpg',
          'https://www.themealdb.com/images/media/meals/53078.jpg',
          'https://www.themealdb.com/images/media/meals/53077.jpg',
          'https://www.themealdb.com/images/media/meals/53085.jpg',
          'https://www.themealdb.com/images/media/meals/53050.jpg',
          'https://www.themealdb.com/images/media/meals/52940.jpg',
        ],
      );

      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void _onProfileFollowRequested(
    ProfileFollowRequested event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isFollowing: !currentState.isFollowing));
    }
  }

  void _onProfileMessageRequested(
    ProfileMessageRequested event,
    Emitter<ProfileState> emit,
  ) {
    // Handle message action
    // In real app, this would open chat or message screen
  }
} 