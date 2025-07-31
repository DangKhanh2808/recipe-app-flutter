import 'package:dartz/dartz.dart';
import '../entities/recipe_area.dart';
import '../repositories/recipe_repository.dart';
import '../../core/errors/failures.dart';

class GetAreas {
  final RecipeRepository repository;

  GetAreas(this.repository);

  Future<Either<Failure, List<RecipeArea>>> call() async {
    return await repository.getAreas();
  }
} 