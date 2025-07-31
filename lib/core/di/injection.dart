import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/recipe_remote_data_source.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/usecases/get_recipes.dart';
import '../../presentation/blocs/recipe_bloc.dart';
import '../constants/app_constants.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Dio
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  // Data sources
  getIt.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(getIt<RecipeRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetRandomRecipes(getIt<RecipeRepository>()));
  getIt.registerLazySingleton(() => SearchRecipesByName(getIt<RecipeRepository>()));
  getIt.registerLazySingleton(() => GetRecipesByCategory(getIt<RecipeRepository>()));

  // Blocs
  getIt.registerFactory(() => RecipeBloc(
    getRandomRecipes: getIt<GetRandomRecipes>(),
    searchRecipesByName: getIt<SearchRecipesByName>(),
  ));
} 