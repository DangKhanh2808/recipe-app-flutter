import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? imageUrl;
  final String? tags;
  final String? youtube;
  final List<String> ingredients;
  final List<String> measures;

  const Recipe({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.instructions,
    this.imageUrl,
    this.tags,
    this.youtube,
    required this.ingredients,
    required this.measures,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    area,
    instructions,
    imageUrl,
    tags,
    youtube,
    ingredients,
    measures,
  ];
} 