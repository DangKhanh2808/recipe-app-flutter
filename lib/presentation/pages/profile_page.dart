import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_events.dart';
import '../blocs/profile/profile_states.dart';
import '../widgets/profile/profile_avatar.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/profile_actions.dart';
import '../widgets/profile/favorite_recipes_grid.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(const ProfileLoadRequested()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary500,
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(const ProfileLoadRequested());
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            return _buildProfileContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoaded state) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          pinned: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Trang cá nhân',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                // Show menu options
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.neutral200,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Profile Content
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Avatar
              ProfileAvatar(
                imageUrl: state.userProfile.avatarUrl,
                size: 100,
              ),
              
              const SizedBox(height: 16),
              
              // Name
              Text(
                state.userProfile.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Stats
              ProfileStats(
                postsCount: state.userProfile.postsCount,
                followersCount: state.userProfile.followersCount,
                followingCount: state.userProfile.followingCount,
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              ProfileActions(
                isFollowing: state.isFollowing,
                onFollowTap: () {
                  context.read<ProfileBloc>().add(const ProfileFollowRequested());
                },
                onMessageTap: () {
                  context.read<ProfileBloc>().add(const ProfileMessageRequested());
                },
              ),
              
              const SizedBox(height: 20),
              
              // Favorite Recipes Grid
              FavoriteRecipesGrid(
                recipeImages: state.userProfile.favoriteRecipes,
                onRecipeTap: () {
                  // Navigate to recipe detail
                },
              ),
              
              const SizedBox(height: 100), // Bottom padding for FAB
            ],
          ),
        ),
      ],
    );
  }
} 