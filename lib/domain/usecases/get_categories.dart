import 'package:dartz/dartz.dart';
import '../entities/recipe_category.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class GetCategories {
  final RecipeRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<RecipeCategory>>> call() async {
    return await repository.getCategories();
  }
} 