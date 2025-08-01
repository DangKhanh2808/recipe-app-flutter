import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/recipe.dart';
import '../blocs/video_recipe/video_recipe_bloc.dart';
import '../blocs/video_recipe/video_recipe_events.dart';
import '../blocs/video_recipe/video_recipe_states.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_events.dart';
import '../blocs/favorite/favorite_states.dart';
import '../widgets/cards/video_recipe_card.dart';
import '../widgets/navigation/bottom_navigation_bar.dart';
import 'video_player_page.dart';

class VideoRecipePage extends StatefulWidget {
  const VideoRecipePage({Key? key}) : super(key: key);

  @override
  State<VideoRecipePage> createState() => _VideoRecipePageState();
}

class _VideoRecipePageState extends State<VideoRecipePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        context.read<VideoRecipeBloc>().add(
          VideoRecipeTabChanged(_tabController.index),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<VideoRecipeBloc>()..add(const VideoRecipeStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<FavoriteBloc>()..add(const LoadFavorites()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVideoTab(),
                  _buildRecipeTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Công thức',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          onPressed: () {
            // TODO: Implement search
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary500,
        indicatorWeight: 3,
        labelColor: AppColors.primary500,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Video'),
          Tab(text: 'Công thức'),
        ],
      ),
    );
  }

  Widget _buildVideoTab() {
    return BlocBuilder<VideoRecipeBloc, VideoRecipeState>(
      builder: (context, state) {
        if (state is VideoRecipeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VideoRecipeLoaded) {
          return _buildVideoList(state.videoRecipes);
        } else if (state is VideoRecipeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lỗi: ${state.message}',
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<VideoRecipeBloc>().add(const VideoRecipeRefresh());
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildVideoList(List<Recipe> recipes) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: VideoRecipeListCard(
            recipe: recipe,
            index: index,
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
    );
  }

  Widget _buildRecipeTab() {
    return BlocBuilder<VideoRecipeBloc, VideoRecipeState>(
      builder: (context, state) {
        if (state is VideoRecipeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VideoRecipeLoaded) {
          return _buildRecipeList(state.recipeRecipes);
        } else if (state is VideoRecipeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lỗi: ${state.message}',
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<VideoRecipeBloc>().add(const VideoRecipeRefresh());
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: RecipeListCard(
            recipe: recipe,
            onTap: () {
              // TODO: Navigate to recipe detail
            },
          ),
        );
      },
    );
  }


}

class VideoRecipeListCard extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final VoidCallback? onTap;

  const VideoRecipeListCard({
    Key? key,
    required this.recipe,
    required this.index,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Image with play button
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: recipe.imageUrl != null
                    ? Image.network(
                        recipe.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            // Rating badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 10,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Play button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.primary500,
                    size: 30,
                  ),
                ),
              ),
            ),

            // Content overlay on image
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Duration
                    Text(
                      '1 tiếng 20 phút',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Author and like button
                    Row(
                      children: [
                        // Author avatar
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary500,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Author name
                        const Text(
                          'Quách Đăng Khanh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        // Like button
                        BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, favoriteState) {
                            final isFavorite = favoriteState is FavoriteLoaded 
                                ? favoriteState.favoriteStatus[recipe.id] ?? false
                                : false;
                            final isLoading = favoriteState is FavoriteLoaded 
                                ? favoriteState.isLoading
                                : false;
                            
                            return IconButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<FavoriteBloc>().add(
                                        ToggleFavorite(recipe.id),
                                      );
                                    },
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? AppColors.error : Colors.white,
                                      size: 20,
                                    ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.restaurant,
          color: AppColors.textSecondary,
          size: 40,
        ),
      ),
    );
  }
}

class RecipeListCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeListCard({
    Key? key,
    required this.recipe,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                color: AppColors.surface,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: recipe.imageUrl != null
                    ? Image.network(
                        recipe.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Category and area
                    if (recipe.category != null || recipe.area != null)
                      Text(
                        [recipe.category, recipe.area]
                            .where((e) => e != null)
                            .join(' • '),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 12),
                    // Author and like button
                    Row(
                      children: [
                        // Author avatar
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary500,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Author name
                        const Text(
                          'Quách Đăng Khanh',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        // Like button
                        BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, favoriteState) {
                            final isFavorite = favoriteState is FavoriteLoaded 
                                ? favoriteState.favoriteStatus[recipe.id] ?? false
                                : false;
                            final isLoading = favoriteState is FavoriteLoaded 
                                ? favoriteState.isLoading
                                : false;
                            
                            return IconButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<FavoriteBloc>().add(
                                        ToggleFavorite(recipe.id),
                                      );
                                    },
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.textSecondary,
                                      ),
                                    )
                                  : Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? AppColors.error : AppColors.textSecondary,
                                      size: 20,
                                    ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.restaurant,
          color: AppColors.textSecondary,
          size: 30,
        ),
      ),
    );
  }
} 