import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe_category.dart';

class CategoryModel extends Equatable {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  const CategoryModel({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idCategory: json['idCategory'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strCategoryThumb: json['strCategoryThumb'] ?? '',
      strCategoryDescription: json['strCategoryDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategory': idCategory,
      'strCategory': strCategory,
      'strCategoryThumb': strCategoryThumb,
      'strCategoryDescription': strCategoryDescription,
    };
  }

  RecipeCategory toEntity() {
    return RecipeCategory(
      id: idCategory,
      name: strCategory,
      imagePath: strCategoryThumb,
      recipeCount: 0, // Sẽ được cập nhật sau khi lấy từ API
    );
  }

  RecipeCategory toEntityWithCount(int count) {
    return RecipeCategory(
      id: idCategory,
      name: strCategory,
      imagePath: strCategoryThumb,
      recipeCount: count,
    );
  }

  @override
  List<Object?> get props => [idCategory, strCategory, strCategoryThumb, strCategoryDescription];
} 