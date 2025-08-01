import 'package:flutter/material.dart';
import 'main_navigation_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A), // Dark background for top section
              Color(0xFF8B4513), // Warm wooden color for bottom section
            ],
            stops: [0.0, 0.4], // Transition point
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section - Dark Background with Food Elements
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    // Floating food elements
                    Positioned(
                      top: 60,
                      left: 40,
                      child: _buildFloatingFoodElement('🍕', 50),
                    ),
                    Positioned(
                      top: 120,
                      right: 50,
                      child: _buildFloatingFoodElement('🍜', 40),
                    ),
                    Positioned(
                      top: 180,
                      left: 80,
                      child: _buildFloatingFoodElement('🍰', 35),
                    ),
                    
                    // Main food illustration
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Food icons in circle
                              Positioned(
                                top: 30,
                                left: 30,
                                child: _buildFoodIcon(Icons.restaurant, const Color(0xFFFF6B6B)),
                              ),
                              Positioned(
                                top: 60,
                                right: 30,
                                child: _buildFoodIcon(Icons.cake, const Color(0xFF4ECDC4)),
                              ),
                              Positioned(
                                bottom: 40,
                                left: 50,
                                child: _buildFoodIcon(Icons.local_drink, const Color(0xFFFFE66D)),
                              ),
                              Positioned(
                                bottom: 60,
                                right: 50,
                                child: _buildFoodIcon(Icons.set_meal, const Color(0xFFA8E6CF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom Section - Wooden Surface with Content
              Expanded(
                flex: 6,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD2691E), // Warm wooden surface
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Wood grain pattern
                      _buildWoodGrain(),
                      
                      // Decorative elements
                      Positioned(
                        top: 30,
                        left: 40,
                        child: _buildDecorativeElement('🍽️', 40),
                      ),
                      Positioned(
                        top: 80,
                        right: 50,
                        child: _buildDecorativeElement('🥢', 30),
                      ),
                      
                      // Text and Button
                      Positioned(
                        bottom: 80,
                        left: 0,
                        right: 0,
                        child: _buildTextAndButton(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingFoodElement(String emoji, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.6),
        ),
      ),
    );
  }

  Widget _buildFoodIcon(IconData icon, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildWoodGrain() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: WoodGrainPainter(),
      ),
    );
  }

  Widget _buildDecorativeElement(String emoji, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }

  Widget _buildTextAndButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Main text
          Text(
            'Bắt đầu với\nnhững món ăn',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Start button
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigationPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // Golden yellow
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA0522D).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < size.height; i += 8) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 