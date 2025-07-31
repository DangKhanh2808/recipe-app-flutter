import 'package:equatable/equatable.dart';

class OnboardingPageEntity extends Equatable {
  final String title;
  final String description;
  final String imagePath;
  final String? buttonText;

  const OnboardingPageEntity({
    required this.title,
    required this.description,
    required this.imagePath,
    this.buttonText,
  });

  @override
  List<Object?> get props => [title, description, imagePath, buttonText];
}

class OnboardingData {
  static const List<OnboardingPageEntity> pages = [
    OnboardingPageEntity(
      title: 'Bắt đầu với những món ăn',
      description: 'Khám phá hàng nghìn công thức nấu ăn ngon từ khắp nơi trên thế giới',
      imagePath: 'assets/images/onboarding_1.png',
      buttonText: 'Bắt đầu',
    ),
    OnboardingPageEntity(
      title: 'Tìm kiếm dễ dàng',
      description: 'Tìm kiếm công thức theo nguyên liệu, danh mục hoặc tên món ăn',
      imagePath: 'assets/images/onboarding_2.png',
      buttonText: 'Tiếp tục',
    ),
    OnboardingPageEntity(
      title: 'Lưu trữ yêu thích',
      description: 'Lưu lại những công thức yêu thích và tạo bộ sưu tập riêng',
      imagePath: 'assets/images/onboarding_3.png',
      buttonText: 'Hoàn thành',
    ),
  ];
} 