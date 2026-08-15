import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_stream_flutter/core/network/dio_client.dart';
import 'package:mentor_stream_flutter/features/categories/data/datasources/categories_api.dart';
import 'package:mentor_stream_flutter/features/categories/data/models/category_model.dart';
import 'package:mentor_stream_flutter/features/categories/data/repositories/firebase_category_repository.dart';
import 'package:mentor_stream_flutter/features/categories/data/repositories/remote_category_repository.dart';
import 'package:mentor_stream_flutter/features/categories/domain/repositories/i_categories_repo.dart';

/// Base URL for the local categories REST API.
///
/// NOTE: this differs from `core/network/network_providers.dart`'s
/// `baseUrl` (`http://localhost:8000/api`) — that one backs the generic
/// health-check [RetrofitClient]. If both should point at the same local
/// server, reconcile the two constants.
const String _categoriesApiBaseUrl = 'http://localhost:3000';

final Provider<Dio> categoriesDioProvider = Provider<Dio>((ref) {
  return DioClient(baseUrl: _categoriesApiBaseUrl).dio;
});

final Provider<CategoriesApi> categoriesApiProvider = Provider<CategoriesApi>((
  ref,
) {
  final dio = ref.watch(categoriesDioProvider);
  return CategoriesApi(dio, baseUrl: _categoriesApiBaseUrl);
});

/// [ICategoryRepository] backed by the local REST API.
final Provider<RemoteCategoryRepository> remoteCategoryRepositoryProvider =
    Provider<RemoteCategoryRepository>((ref) {
      return RemoteCategoryRepository(
        remoteDataSource: ref.watch(categoriesApiProvider),
      );
    });

/// [ICategoryRepository] backed by Firestore.
final Provider<FirebaseCategoryRepository> firebaseCategoryRepositoryProvider =
    Provider<FirebaseCategoryRepository>((ref) {
      return FirebaseCategoryRepository();
    });

/// The active [ICategoryRepository] the app reads from. Swap this to
/// [remoteCategoryRepositoryProvider] to switch to the local REST API
/// without touching any UI code.
final Provider<ICategoryRepository> categoryRepositoryProvider =
    Provider<ICategoryRepository>((ref) {
      return ref.watch(firebaseCategoryRepositoryProvider);
    });

final FutureProvider<List<CategoryModel>> categoriesProvider =
    FutureProvider<List<CategoryModel>>((ref) {
      return ref.watch(categoryRepositoryProvider).getCategories();
    });
