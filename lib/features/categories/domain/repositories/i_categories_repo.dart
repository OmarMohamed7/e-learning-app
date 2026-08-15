import '../../data/models/category_model.dart';

abstract interface class ICategoryRepository {
  Future<List<CategoryModel>> getCategories();
}
