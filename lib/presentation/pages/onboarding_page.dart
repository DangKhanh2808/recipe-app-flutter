import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/onboarding/onboarding_bloc.dart';
import '../blocs/onboarding/onboarding_events.dart';
import '../blocs/onboarding/onboarding_states.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../core/constants/app_colors.dart';
import 'home_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc()..add(const OnboardingStarted()),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoaded) {
              return _buildOnboardingContent(context, state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildOnboardingContent(BuildContext context, OnboardingLoaded state) {
    final currentPage = OnboardingData.pages[state.currentPage];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary500.withOpacity(0.1),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    context.read<OnboardingBloc>().add(const OnboardingSkip());
                  },
                  child: Text(
                    'Bỏ qua',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Expanded(
                      flex: 3,
                      child: _buildIllustration(currentPage),
                    ),
                    
                    // Text content
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            currentPage.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentPage.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    // Action button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (state.isLastPage) {
                              context.read<OnboardingBloc>().add(const OnboardingComplete());
                            } else {
                              context.read<OnboardingBloc>().add(const OnboardingNextPage());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentPage.buttonText ?? 'Tiếp tục',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Page indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(state.totalPages, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == state.currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: index == state.currentPage 
                          ? AppColors.primary500 
                          : AppColors.neutral300,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(OnboardingPageEntity page) {
    switch (page.title) {
      case 'Bắt đầu với những món ăn':
        return _buildFoodIllustration();
      case 'Tìm kiếm dễ dàng':
        return _buildSearchIllustration();
      case 'Lưu trữ yêu thích':
        return _buildFavoriteIllustration();
      default:
        return _buildFoodIllustration();
    }
  }

  Widget _buildFoodIllustration() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Stack(
        children: [
          // Background circle
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary100,
              ),
            ),
          ),
          
          // Food items
          Positioned(
            top: 60,
            left: 80,
            child: _buildFoodItem(Icons.restaurant, AppColors.primary500),
          ),
          Positioned(
            top: 100,
            right: 80,
            child: _buildFoodItem(Icons.cake, AppColors.secondary500),
          ),
          Positioned(
            bottom: 80,
            left: 60,
            child: _buildFoodItem(Icons.local_drink, AppColors.success),
          ),
          Positioned(
            bottom: 120,
            right: 60,
            child: _buildFoodItem(Icons.set_meal, AppColors.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIllustration() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Stack(
        children: [
          // Background circle
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary100,
              ),
            ),
          ),
          
          // Search icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary500,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary500.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          
          // Floating elements
          Positioned(
            top: 40,
            left: 60,
            child: _buildFloatingElement('Beef', AppColors.primary500),
          ),
          Positioned(
            top: 80,
            right: 50,
            child: _buildFloatingElement('Chicken', AppColors.success),
          ),
          Positioned(
            bottom: 60,
            left: 50,
            child: _buildFloatingElement('Dessert', AppColors.warning),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteIllustration() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Stack(
        children: [
          // Background circle
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.1),
              ),
            ),
          ),
          
          // Heart icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          
          // Recipe cards
          Positioned(
            top: 30,
            left: 40,
            child: _buildRecipeCard('Phở Bò', AppColors.primary500),
          ),
          Positioned(
            top: 70,
            right: 30,
            child: _buildRecipeCard('Bún Chả', AppColors.secondary500),
          ),
          Positioned(
            bottom: 40,
            left: 50,
            child: _buildRecipeCard('Cơm Tấm', AppColors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildFloatingElement(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRecipeCard(String title, Color color) {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
} 