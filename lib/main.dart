import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'presentation/blocs/recipe_bloc.dart';
import 'presentation/pages/recipe_list_page.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => getIt<RecipeBloc>(),
        child: const RecipeListPage(),
      ),
    );
  }
}


