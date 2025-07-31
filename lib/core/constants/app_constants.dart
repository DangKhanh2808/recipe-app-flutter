class AppConstants {
  // API URLs
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String apiKey = '1'; // Test API key
  
  // App Info
  static const String appName = 'Recipe App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'Unknown error occurred';
  
  // API Endpoints
  static const String searchByName = '/search.php?s=';
  static const String searchByFirstLetter = '/search.php?f=';
  static const String lookupById = '/lookup.php?i=';
  static const String randomMeal = '/random.php';
  static const String categories = '/categories.php';
  static const String filterByCategory = '/filter.php?c=';
  static const String filterByArea = '/filter.php?a=';
  static const String filterByIngredient = '/filter.php?i=';
  static const String listCategories = '/list.php?c=list';
  static const String listAreas = '/list.php?a=list';
  static const String listIngredients = '/list.php?i=list';
} 