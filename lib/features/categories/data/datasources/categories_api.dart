import 'package:dio/dio.dart';
import 'package:mentor_stream_flutter/features/categories/data/models/category_model.dart';
import 'package:retrofit/retrofit.dart';

part 'categories_api.g.dart';

@RestApi()
abstract class CategoriesApi {
  factory CategoriesApi(Dio dio, {String? baseUrl}) = _CategoriesApi;

  @GET('/categories')
  Future<List<CategoryModel>> getCategories();
}
