import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/common/search_bar_widget.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_events.dart';
import '../blocs/search/search_states.dart';
import '../../domain/entities/recipe.dart';
import '../../core/di/injection.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(20),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchQueryChanged(query));
                },
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    context.read<SearchBloc>().add(SearchSubmitted(query));
                  }
                },
                hintText: 'Tìm kiếm công thức...',
              ),
            ),
            
            // Search Results/Suggestions
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return _buildPopularSearches();
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchSuggestions) {
                    return _buildSuggestions(state.suggestions);
                  } else if (state is SearchResults) {
                    return _buildSearchResults(state.recipes);
                  } else if (state is SearchError) {
                    return _buildError(state.message);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tìm kiếm phổ biến',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final popularSearches = [
                'Pizza',
                'Chicken',
                'Beef',
                'Seafood',
                'Dessert',
                'Vegetarian',
              ];
              
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: popularSearches.map((tag) => _buildSearchTag(tag)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String tag) {
    return GestureDetector(
      onTap: () {
        _searchController.text = tag;
        context.read<SearchBloc>().add(SearchSubmitted(tag));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary300),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.primary600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return _buildSuggestionItem(suggestion);
      },
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return GestureDetector(
      onTap: () {
        _searchController.text = suggestion;
        context.read<SearchBloc>().add(SearchSubmitted(suggestion));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.neutral200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                suggestion,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Recipe> recipes) {
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _buildRecipeItem(recipe);
      },
    );
  }

  Widget _buildRecipeItem(Recipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Recipe Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: recipe.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      recipe.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.restaurant,
                          color: AppColors.textSecondary,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.restaurant,
                    color: AppColors.textSecondary,
                  ),
          ),
          const SizedBox(width: 12),
          
          // Recipe Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name ?? 'Unknown Recipe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (recipe.category != null)
                  Text(
                    recipe.category!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          
          // Arrow
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
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
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 