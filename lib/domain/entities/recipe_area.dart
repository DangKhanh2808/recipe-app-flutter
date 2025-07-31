import 'package:equatable/equatable.dart';

class RecipeArea extends Equatable {
  final String name;

  const RecipeArea({required this.name});

  @override
  List<Object?> get props => [name];
} 