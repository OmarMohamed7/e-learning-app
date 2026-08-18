import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_stream_flutter/core/network/network_providers.dart';
import 'package:mentor_stream_flutter/features/categories/data/models/category_model.dart';
import 'package:mentor_stream_flutter/features/categories/data/repositories/remote_category_repository.dart';
import 'package:mentor_stream_flutter/features/categories/domain/repositories/i_categories_repo.dart';

import '../../data/datasources/categories_api.dart';

final Provider<CategoriesApi> categoriesApiProvider = Provider<CategoriesApi>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return CategoriesApi(dio);
});

final Provider<RemoteCategoryRepository> remoteCategoryRepositoryProvider =
    Provider<RemoteCategoryRepository>((ref) {
      return RemoteCategoryRepository(
        remoteDataSource: ref.watch(categoriesApiProvider),
      );
    });

final Provider<ICategoryRepository> categoryRepositoryProvider =
    Provider<ICategoryRepository>((ref) {
      return ref.watch(remoteCategoryRepositoryProvider);
    });

final FutureProvider<List<CategoryModel>> categoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) {
      return ref.watch(categoryRepositoryProvider).getCategories();
    });
