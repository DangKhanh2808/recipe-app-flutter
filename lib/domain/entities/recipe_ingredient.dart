import 'package:equatable/equatable.dart';

class RecipeIngredient extends Equatable {
  final String name;

  const RecipeIngredient({required this.name});

  @override
  List<Object?> get props => [name];
} 