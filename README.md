# Recipe App

Ứng dụng Flutter sử dụng Clean Architecture và Bloc pattern để hiển thị công thức nấu ăn từ TheMealDB API.

## Cấu trúc Clean Architecture

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── failures.dart
│   ├── utils/
│   │   └── recipe_parser.dart
│   └── di/
│       └── injection.dart
├── data/
│   ├── datasources/
│   │   └── recipe_remote_data_source.dart
│   ├── models/
│   │   └── recipe_model.dart
│   └── repositories/
│       └── recipe_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── recipe.dart
│   ├── repositories/
│   │   └── recipe_repository.dart
│   └── usecases/
│       └── get_recipes.dart
└── presentation/
    ├── blocs/
    │   └── recipe_bloc.dart
    ├── pages/
    │   └── recipe_list_page.dart
    └── widgets/
        └── recipe_card.dart
```

## Tính năng

- **Clean Architecture**: Tách biệt rõ ràng các layer (Presentation, Domain, Data)
- **Bloc Pattern**: Quản lý state với flutter_bloc
- **Dependency Injection**: Sử dụng get_it để quản lý dependencies
- **TheMealDB API**: Tích hợp với API miễn phí để lấy công thức nấu ăn
- **Error Handling**: Xử lý lỗi với Either type từ dartz

## API Endpoints được sử dụng

Dựa trên [TheMealDB API](https://www.themealdb.com/api.php):

- `GET /random.php` - Lấy công thức ngẫu nhiên
- `GET /lookup.php?i={id}` - Lấy công thức theo ID
- `GET /search.php?s={name}` - Tìm kiếm theo tên
- `GET /search.php?f={letter}` - Tìm kiếm theo chữ cái đầu
- `GET /filter.php?c={category}` - Lọc theo danh mục
- `GET /filter.php?a={area}` - Lọc theo khu vực
- `GET /filter.php?i={ingredient}` - Lọc theo nguyên liệu
- `GET /categories.php` - Lấy danh sách danh mục
- `GET /list.php?c=list` - Lấy danh sách danh mục
- `GET /list.php?a=list` - Lấy danh sách khu vực
- `GET /list.php?i=list` - Lấy danh sách nguyên liệu

## Cài đặt

1. Clone repository
2. Chạy `flutter pub get` để cài đặt dependencies
3. Chạy `flutter run` để khởi chạy ứng dụng

## Dependencies chính

- `flutter_bloc`: State management
- `dartz`: Functional programming utilities
- `get_it`: Dependency injection
- `dio`: HTTP client
- `equatable`: Value equality

## Cách sử dụng

1. Ứng dụng sẽ tự động load 10 công thức ngẫu nhiên khi khởi động
2. Sử dụng nút search để tìm kiếm công thức theo tên
3. Mỗi công thức hiển thị: tên, danh mục, khu vực, và danh sách nguyên liệu

## Lưu ý

- Sử dụng API key test "1" cho mục đích phát triển
- Một số tính năng premium không được sử dụng
- Ứng dụng chỉ đọc dữ liệu, không có chức năng tạo/sửa/xóa
