import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_events.dart';
import '../blocs/home/home_states.dart';
import '../widgets/cards/recipe_card.dart';
import '../widgets/cards/video_recipe_card.dart';
import '../widgets/cards/category_card.dart';
import '../widgets/common/search_bar_widget.dart';
import 'onboarding_page.dart';
import 'recipe_detail_page.dart';
import 'video_player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(const HomeStarted()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is HomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Có lỗi xảy ra',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(const HomeRefresh());
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        
        if (state is HomeLoaded) {
          return _buildHomeContent(context, state);
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _handleFiltersApplied(BuildContext context, Map<String, String?> filters) {
    print('HomePage - Filters applied: $filters');
    
    // Build search query from filters
    final List<String> searchTerms = [];
    
    if (filters['category'] != null) {
      searchTerms.add(filters['category']!);
    }
    if (filters['ingredient'] != null) {
      searchTerms.add(filters['ingredient']!);
    }
    if (filters['area'] != null) {
      searchTerms.add(filters['area']!);
    }
    
    if (searchTerms.isNotEmpty) {
      final searchQuery = searchTerms.join(' ');
      context.read<HomeBloc>().add(HomeSearchChanged(searchQuery));
    }
  }

  Widget _buildHomeContent(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.surface,
          elevation: 2,
          shadowColor: AppColors.shadowLight,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Recipe App',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface,
                    AppColors.surface.withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary500,
                  size: 20,
                ),
              ),
              onPressed: () {
                // Navigate to profile
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        
        // Search Bar
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SearchBarWidget(
              initialValue: state.searchQuery,
              onChanged: (query) {
                context.read<HomeBloc>().add(HomeSearchChanged(query));
              },
              onFiltersApplied: (filters) {
                _handleFiltersApplied(context, filters);
              },
            ),
          ),
        ),
        
        // Featured Video Recipes
        SliverToBoxAdapter(
          child: _buildSectionHeader('Món nổi bật', 'Xem tất cả'),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 320,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: state.featuredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = state.featuredRecipes[index];
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: VideoRecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(recipe: recipe),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        
        // Categories
        SliverToBoxAdapter(
          child: _buildSectionHeader('Danh mục', 'Xem tất cả'),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 180,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: CategoryCard(
                    category: category,
                    onTap: () {
                      context.read<HomeBloc>().add(
                        HomeCategorySelected(category.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        
        // Recent Recipes
        SliverToBoxAdapter(
          child: _buildSectionHeader('Công thức gần đây', 'Xem tất cả'),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 240,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: state.recentRecipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recentRecipes[index];
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(recipe: recipe),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        
        // Load More Button
        if (!state.hasReachedMax)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: state.isLoadingMore
                    ? null
                    : () {
                        context.read<HomeBloc>().add(const HomeLoadMoreRecipes());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: state.isLoadingMore
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Tải thêm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, [String? actionText]) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: () {
                // Navigate to see all
              },
              child: Text(
                actionText,
                style: const TextStyle(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 