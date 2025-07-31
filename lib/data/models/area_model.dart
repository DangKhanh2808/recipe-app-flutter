import '../../domain/entities/recipe_area.dart';

class AreaModel extends RecipeArea {
  const AreaModel({required String name}) : super(name: name);

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(name: json['strArea'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'strArea': name};
  }
} 