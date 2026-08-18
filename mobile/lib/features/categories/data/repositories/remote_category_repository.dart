import 'package:mentor_stream_flutter/features/categories/data/datasources/categories_api.dart';
import 'package:mentor_stream_flutter/features/categories/data/models/category_model.dart';
import 'package:mentor_stream_flutter/features/categories/domain/repositories/i_categories_repo.dart';

/// [ICategoryRepository] backed by the local REST API (via [CategoriesApi]).
class RemoteCategoryRepository implements ICategoryRepository {
  const RemoteCategoryRepository({required CategoriesApi remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CategoriesApi _remoteDataSource;

  @override
  Future<List<CategoryModel>> getCategories() {
    return _remoteDataSource.getCategories();
  }
}
